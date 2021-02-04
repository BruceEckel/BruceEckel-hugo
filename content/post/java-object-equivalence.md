---
date: '2021-02-04'
published: true
title: Java Object Equivalence
url: /2021/02/04/Java-Object-Equivalence
author: "Bruce Eckel"
---

> *This is an update to the subsection "Testing Object Equivalence" in the
> "Operators" chapter of [On Java 8](http://www.OnJava8.com). This will appear in
> the book in its next update.*

The relational operators `==` and `!=` work with all objects, but their results
can be confusing:

```java
// operators/Equivalence.java

public class Equivalence {
  static void show(String desc, Integer n1, Integer n2) {
    System.out.println(desc + ":");
    System.out.printf(
      "%d==%d %b %b%n", n1, n2, n1 == n2, n1.equals(n2));
  }
  @SuppressWarnings("deprecation")
  public static void test(int value) {
    Integer i1 = value;                             // [1]
    Integer i2 = value;
    show("Automatic", i1, i2);
    // Old way, deprecated in Java 9 and on:
    Integer r1 = new Integer(value);                // [2]
    Integer r2 = new Integer(value);
    show("new Integer()", r1, r2);
    // Preferred in Java 9 and on:
    Integer v1 = Integer.valueOf(value);            // [3]
    Integer v2 = Integer.valueOf(value);
    show("Integer.valueOf()", v1, v2);
    // Primitives can't use equals():
    int x = value;                                  // [4]
    int y = value;
    // x.equals(y); // Doesn't compile
    System.out.println("Primitive int:");
    System.out.printf("%d==%d %b%n", x, y, x == y);
  }
  public static void main(String[] args) {
    test(127);
    test(128);
  }
}
/* Output:
Automatic:
127==127 true true
new Integer():
127==127 false true
Integer.valueOf():
127==127 true true
Primitive int:
127==127 true
Automatic:
128==128 false true
new Integer():
128==128 false true
Integer.valueOf():
128==128 false true
Primitive int:
128==128 true
*/
```

The `show()` method compares the behavior of `==` to the method `equals()` that
exists for all objects. The `printf()` format argument uses the specifier `%d`
for `int` output, `%b` for Boolean output, and `%n` to produce a newline.

If you need a "not equal" comparison, use `n1 != n2` and  `!n1.equals(n2)`.

In `test()`, you see integer-valued objects created in four different ways:

- **[1]**: Automatic conversion to `Integer`.
- **[2]**: Using standard `new` object-creation syntax. This *was* the preferred
  way to create "wrapped" `Integer` objects.
- **[3]**: Starting with Java 9, `valueOf()` is preferred over **[2]**. If you
  try to use form **[2]** with Java 9, you'll get a warning and a suggestion to
  use **[3]** instead. It is difficult to determine whether **[3]** is preferred
  over **[1]**, and **[1]** seems much cleaner.
- **[4]**: As primitive `int`s.

The `@SuppressWarnings("deprecation")` is not necessary for Java 8, but is
included in case you compile the code with Java 9 or newer.

For a `value` of 127, the comparisons produce the results you expect, *except*
form **[2]** which produces `false` for `==` and `true` for `equals()`. Although
the *contents* of the objects are the same, the references point to different
objects in memory. The operators `==` and `!=` compare object references, and
have different behavior *depending on how the `Integer` objects are
created*---presumably, **[1]** and **[3]** yield `Integer`s that point to the
same storage in memory. `Integer` values from -128 through 127 produce this
behavior for `==` and `!=`, but outside that range they will not, as seen with
the call `test(128)`.

If you're using `Integer` you must only use `equals()`. If you accidentally use
`==` and `!=` for `Integer` and don't test it for values outside -128 through
127, your code will pass but will be quietly broken. If you're using primitive
`int`s then you *can't* use `equals()` and *must* use `==` and `!=`. This can
cause problems if you start by using `int`s and then later change to `Integer`s,
or vice-versa.

In Java 9 and on, the use of `new Integer()` is deprecated to eliminate this
issue. Think about that. Java has included this very odd behavior for *two
decades* before acknowledging it was a mistake.

When working with floating-point numbers, you encounter different equivalence
problems, not because of Java but because of the nature of floating-point
numbers:

```java
// operators/DoubleEquivalence.java

public class DoubleEquivalence {
  static void show(String desc, Double n1, Double n2) {
    System.out.println(desc + ":");
    System.out.printf(
      "%e==%e %b %b%n", n1, n2, n1 == n2, n1.equals(n2));
  }
  @SuppressWarnings("deprecation")
  public static void test(double x1, double x2) {
    // x1.equals(x2) // Won't compile
    System.out.printf("%e==%e %b%n", x1, x2, x1 == x2);
    Double d1 = x1;
    Double d2 = x2;
    show("Automatic", d1, d2);
    Double r1 = new Double(x1);
    Double r2 = new Double(x2);
    show("new Double()", r1, r2);
    Double v1 = Double.valueOf(x1);
    Double v2 = Double.valueOf(x2);
    show("Double.valueOf()", v1, v2);
  }
  public static void main(String[] args) {
    test(0, Double.MIN_VALUE);
    test(Double.MAX_VALUE,
      Double.MAX_VALUE - Double.MIN_VALUE * 1_000_000);
  }
}
/* Output:
0.000000e+00==4.900000e-324 false
Automatic:
0.000000e+00==4.900000e-324 false false
new Double():
0.000000e+00==4.900000e-324 false false
Double.valueOf():
0.000000e+00==4.900000e-324 false false
1.797693e+308==1.797693e+308 true
Automatic:
1.797693e+308==1.797693e+308 false true
new Double():
1.797693e+308==1.797693e+308 false true
Double.valueOf():
1.797693e+308==1.797693e+308 false true
*/
```

On paper, the comparison of floating point numbers should be very strict---a
number that is the tiniest fraction different from another number should still
be unequal. This works for the call to `test(0, Double.MIN_VALUE)`, where
`Double.MIN_VALUE` is the smallest representable value. (`%e` in the `printf()`
call presents the results in exponential notation).

However, it does not hold true for the second `test()` call, where the argument
`x2` is the value of `x1` minus one million times `Double.MIN_VALUE`. It seems
like `x2` should be significantly different than `x1`, but the two numbers still
compare as equal. You encounter this kind of problem in virtually every
programming language because when a variable holds a very large number,
subtracting a relatively small number won't make a significant difference. This
is called a *rounding error* and occurs because the machine cannot hold enough
information to represent a tiny change to a large number.

You might be fooled into thinking that using `==` produces a correct result in
this case, but it does not---it is simply comparing references.

Using `equals()` when you're not working with primitives seems like the
straightforward answer, but it's not as simple as that. Consider class `ValA`:

```java
// operators/EqualsMethod.java
// Default equals() does not compare contents

class ValA {
  int i;
}

class ValB {
  int i;
  // Works for this example, not a complete equals():
  public boolean equals(Object o) {
    ValB rval = (ValB)o;  // Cast o to be a ValB
    return i == rval.i;
  }
}

public class EqualsMethod {
  public static void main(String[] args) {
    ValA va1 = new ValA();
    ValA va2 = new ValA();
    va1.i = va2.i = 100;
    System.out.println(va1.equals(va2));
    ValB vb1 = new ValB();
    ValB vb2 = new ValB();
    vb1.i = vb2.i = 100;
    System.out.println(vb1.equals(vb2));
  }
}
/* Output:
false
true
*/
```

In `main()`, `va1` and `va2` contain identical values for `i`, but the result of
comparing them using `equals()` is `false`, which is confusing again. This
happens because the default behavior of `equals()` is to compare references. To
produce the desired behavior of comparing the contents, you must *override*
`equals()` as in class `ValB`. `ValB.equals()` contains only the minimum
necessary code to solve the problem for this example, but it is not a proper
`equals()`. Note that the standard argument for `equals()` is an `Object` (not a
`ValB`), so we must force `o` to be a `ValB` using a *cast*: `(ValB)o`
(ordinarily you must check the type first before casting, but we'll skip that
until a later chapter). Then we can compare the two values of `i`, using `==`
because they are primitives.

Most of the standard library classes override `equals()` to compare the contents
of objects instead of their references.

- I clearly don't get Reddit. I attempted to post this article to r/learnjava as
  a way for people to make comments, and got permanently banned for doing so.

- **I am the Author of [Atomic Kotlin](https://www.atomickotlin.com/)
(with Svetlana Isakova), [On Java 8](https://www.onjava8.com/), and other books.**
