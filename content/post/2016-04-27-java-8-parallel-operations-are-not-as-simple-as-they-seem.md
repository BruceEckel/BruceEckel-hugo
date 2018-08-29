---
date: '2016-04-27'
published: true
title: Java 8 Parallel Operations Are Not As Simple As They Seem
url: /2016/04/27/java-8-parallel-operations-are-not-as-simple-as-they-seem
---


As an exploration of the uncertainties of streams and parallel streams, let's
look at a problem that seems simple: summing an incremental sequence of numbers.
There turns out to be a surprising number of ways to do this, and I'll take the
risk of comparing them through timing---trying to be careful, but acknowledging
that I might fall into one of the many fundamental pitfalls when timing code
execution. The results may have some flaws (there's no "warming up" of the JVM,
for example), but I think it nonetheless gives some useful indications.

I'll start with a timing method `timeTest()` which takes a `LongSupplier`,
measures the length of the `getAsLong()` call, compares the result with a
`checkValue` and displays the results. It also assigns the `result` to a
volatile value just in case Java is tempted to optimize away the calculation.

Note that everything rigorously uses `long`s whereever possible; I spent a
bit of time chasing down quiet overflows before realizing that I missed 'long's
in important places.

All the numbers and discussions about time and memory refer to "my machine."
Your experience will probably be different.

```java
// Summing.java
import java.util.stream.*;
import java.util.function.*;

public class Summing {
  static volatile long x;
  static void timeTest(String id, long checkValue,
    LongSupplier operation) {
    System.out.print(id + ": ");
    long t = System.currentTimeMillis();
    long result = operation.getAsLong();
    long duration = System.currentTimeMillis() - t;
    if(result == checkValue)
      System.out.println(duration + "ms");
    else
      System.out.format("result: %d\ncheckValue: %d\n",
        result, checkValue);
    x = result; // Prevent optimization
  }
  public static int SZ = 100_000_000;
  // This even works:
  // public static int SZ = 1_000_000_000;
  // Gauss's formula:
  public static final long CHECK =
    (long)SZ * ((long)SZ + 1)/2;
  public static void main(String[] args) {
    System.out.println(CHECK);
    timeTest("Sum Stream", CHECK, () ->
      LongStream.rangeClosed(0, SZ).sum());
    timeTest("Sum Stream Parallel", CHECK, () ->
      LongStream.rangeClosed(0, SZ).parallel().sum());
    timeTest("Sum Iterated", CHECK, () ->
      LongStream.iterate(0, i -> i + 1)
        .limit(SZ+1).sum());
    // Takes longer, runs out of memory above 1_000_000:
    // timeTest("Sum Iterated Parallel", CHECK, () ->
    //   LongStream.iterate(0, i -> i + 1)
    //     .parallel()
    //     .limit(SZ+1).sum());
  }
}
/* Output:
5000000050000000
Sum Stream: 625ms
Sum Stream Parallel: 158ms
Sum Iterated: 2521ms
*/
```

The `CHECK` value is calculated using the formula created by Carl Friedrich
Gauss while still in primary school in the late 1700's.

This first version of `main()` uses the straightforward approach of generating a
`Stream` and calling `sum()`. We see the benefits of streams in that a `SZ` of a
billion is handled without overflow (I use a smaller number so the program
doesn't take so long to run). Using the basic range operation with `parallel()`
is notably faster.

If `iterate()` is used to produce the sequence the slowdown is dramatic,
probably because the lambda must be called each time a number is generated. But
if we try to parallelize that, the result not only takes longer than the
non-parallel version but it also runs out of memory when `SZ` gets above a
million. Of course you wouldn't use `iterate()` when you could use `range()`,
but if you're generating something other than a simple sequence you must use
`iterate()`. Applying `parallel()` is a reasonable thing to attempt, but
produces these surprising results. We can make some initial observations
regarding the stream parallel algorithms:

- Stream parallelism divides the incoming data into pieces so the algorithm(s)
can be applied to those separate pieces.

- Arrays split cheaply, evenly and with perfect knowledge of split sizes.

- Linked Lists have none of these properties; "splitting" a linked list only
means dividing it into "first element" and "rest of list," which is relatively
useless.

- Stateless generators behave like arrays; the use of `range` above is
stateless.

- Iterative generators behave like linked lists; `iterate()` is an iterative
generator.

Now let's try solving the problem by filling an array with values, then summing
over the array. Because the array is only allocated once, it seems unlikely
we'll run into garbage collection timing issues.

First we'll try an array filled with primitive `long`s:

```java
// Summing2.java
import java.util.*;

public class Summing2 {
  static long basicSum(long[] ia) {
    long sum = 0;
    final int sz = ia.length;
    for(int i = 0; i < sz; i++)
      sum += ia[i];
    return sum;
  }
  // Approximate largest value of SZ before
  // running out of memory on my machine:
  public static int SZ = 20_000_000;
  public static final long CHECK =
    (long)SZ * ((long)SZ + 1)/2;
  public static void main(String[] args) {
    System.out.println(CHECK);
    long[] la = new long[SZ+1];
    Arrays.parallelSetAll(la, i -> i);
    Summing.timeTest("Array Stream Sum", CHECK, () ->
      Arrays.stream(la).sum());
    Summing.timeTest("Parallel", CHECK, () ->
      Arrays.stream(la).parallel().sum());
    Summing.timeTest("Basic Sum", CHECK, () ->
      basicSum(la));
    // Destructive summation:
    Summing.timeTest("parallelPrefix", CHECK, () -> {
      Arrays.parallelPrefix(la, Long::sum);
      return la[la.length - 1];
    });
  }
}
/* Output:
200000010000000
Array Stream Sum: 114ms
Parallel: 27ms
Basic Sum: 33ms
parallelPrefix: 49ms
*/
```

The first limitation is memory size; because the array is allocated up front, we
can't create anything nearly as large as the previous version. Parallelizing
speeds things up, even a bit faster than just looping through using
`basicSum()`. Interestingly, `Arrays.parallelPrefix()` doesn't speed things up
as much as we might imagine. However, any of these techniques might be more
useful under other conditions---that's why you can't make any deterministic
statements about what to do, other than "you have to try it out."

Finally, consider the effect of using wrapped `Long`s instead:

```java
// Summing3.java
import java.util.*;

public class Summing3 {
  static long basicSum(Long[] ia) {
    long sum = 0;
    final int sz = ia.length;
    for(int i = 0; i < sz; i++)
      sum += ia[i];
    return sum;
  }
  // Approximate largest value of SZ before
  // running out of memory on my machine:
  public static int SZ = 10_000_000;
  public static final long CHECK =
    (long)SZ * ((long)SZ + 1)/2;
  public static void main(String[] args) {
    System.out.println(CHECK);
    Long[] La = new Long[SZ+1];
    Arrays.parallelSetAll(La, i -> (long)i);
    Summing.timeTest("Long Array Stream Reduce",
      CHECK, () ->
      Arrays.stream(La).reduce(0L, Long::sum));
    Summing.timeTest("Long Basic Sum", CHECK, () ->
      basicSum(La));
    // Destructive summation:
    Summing.timeTest("Long parallelPrefix",CHECK, ()-> {
      Arrays.parallelPrefix(La, Long::sum);
      return La[La.length - 1];
    });
  }
}
/* Output:
50000005000000
Long Array Stream Reduce: 1046ms
Long Basic Sum: 21ms
Long parallelPrefix: 3287ms
*/
```

Now the amount of memory available is approximately cut in half, and the amount
of time required has exploded in all cases except `basicSum()`, which simply
loops through the array. Surprisingly, `Arrays.parallelPrefix()` takes
significantly longer than any other approach.

I separated the `parallel()` version because running it inside the above program
caused a lengthy garbage collection, distorting the results:

```java
// Summing4.java
import java.util.*;

public class Summing4 {
  public static void main(String[] args) {
    System.out.println(Summing3.CHECK);
    Long[] La = new Long[Summing3.SZ+1];
    Arrays.parallelSetAll(La, i -> (long)i);
    Summing.timeTest("Long Parallel",
      Summing3.CHECK, () ->
      Arrays.stream(La).parallel().reduce(0L,Long::sum));
  }
}
/* Output:
50000005000000
Long Parallel: 1008ms
*/
```

It's slightly faster than the non-`parallel()` version, but not significantly.

A big reason for this increase in time is the processor memory cache. With the
primitive `long`s in `Summing2.java`, the array `la` is contiguous memory. The
processor can more easily anticipate the use of this array and keep the cache
filled with the array elements that will be needed next. Accessing the cache is
much, much faster than going out to main memory. It appears that the
`Long parallelPrefix` calculation suffers because it not only reads two array
elements for each calculation, plus writes the result back into the array, and
each of these produces an out-of-cache reference for the `Long`.

With `Summing3.java` and `Summing4.java`, `La` is an array of `Long`, which is
not a continguous array of data, but a contiguous array of references to `Long`
objects. Even though that array will probably be kept in cache, the objects
pointed to will almost always be out-of-cache.

These examples have used different `SZ` values to show the memory limits. To do
a time comparison, here are the results with `SZ` set to the smallest value of
10 million:

```
Sum Stream: 69ms
Sum Stream Parallel: 18ms
Sum Iterated: 277ms
Array Stream Sum: 57ms
Parallel: 14ms
Basic Sum: 16ms
parallelPrefix: 28ms
Long Array Stream Reduce: 1046ms
Long Basic Sum: 21ms
Long parallelPrefix: 3287ms
Long Parallel: 1008ms
```

While the various new built-in "parallel" tools in Java 8 are terrific, I've
seen them treated as magical panaceas: "All you need to do is throw in
`parallel()` and it will run faster!" I hope I've begun to show that this is not
the case at all, and that blindly applying the built-in "parallel" operations
can sometimes even make things run a lot slower.

Language and library support for concurrency and parallelism seem like perfect
candidates for the term "leaky abstraction," but I've started to wonder whether
there's really any abstraction at all---when writing these kinds of programs you
are never shielded from any of the underlying systems and tools, even including
the CPU cache. Ultimately, if you've been very careful, what you create will
work in a particular situation, but it won't work in different situation.
Sometimes the difference is the way two different machines are configured, or
the estimated load for the program. This is not specific to Java per se---it is
the nature of concurrent and parallel programming.

You might argue that a pure functional language doesn't have these same
restrictions. Indeed, a pure functional language solves a large number of
problems. But ultimately, if you write a system that has, for example, a queue
somewhere, if things aren't tuned right and the input rate either isn't
estimated correctly or throttled (and throttling means different things and has
different impacts in different situations), that queue will either fill up and
block, or overflow. In the end, you must understand all the details, and any
issue can break your system. It's a very different kind of programming.

I'd like feedback on this; if I've made any obvious missteps please describe
them in the comments. Thanks!