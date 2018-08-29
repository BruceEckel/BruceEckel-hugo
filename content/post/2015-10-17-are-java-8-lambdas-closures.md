---
date: '2015-10-17'
published: true
title: Are Java 8 Lambdas Closures?
url: /2015/10/17/are-java-8-lambdas-closures
---


(*Significantly rewritten 11/25/2015*)

Based on what I've heard, I was surprised to discover that the short answer is
"yes, with a caveat that, after explanation, isn't terrible." So, a qualified
yes.

For the longer answer, we must first explore the question of "why, again, are
we doing all this?"

## Abstraction over Behavior

The simplest way to look at the need for lambdas is that they describe *what*
computation should be performed, rather than *how* it should be performed.
Traditionally, we've used *external iteration*, where we specify exactly how to
step through a sequence and perform operations:

```java
// InternalVsExternalIteration.java
import java.util.*;

interface Pet {
    void speak();
}

class Rat implements Pet {
    public void speak() { System.out.println("Squeak!"); }
}

class Frog implements Pet {
    public void speak() { System.out.println("Ribbit!"); }
}

public class InternalVsExternalIteration {
    public static void main(String[] args) {
        List<Pet> pets = Arrays.asList(new Rat(), new Frog());
        for(Pet p : pets) // External iteration
            p.speak();
        pets.forEach(Pet::speak); // Internal iteration
    }
}
```

The `for` loop represents external iteration and specifies exactly how it is
done. This kind of code is redundant, and duplicated throughout our programs.
With the `forEach`, however, we tell it to call `speak` (here, using a method
reference, which is more succinct than a lambda) for each element, but we don't
have to specify how the loop works. The iteration is handled internally, inside
the `forEach`.

This "what not how" is the basic motivation for lambdas. But to understand
closures, we must look more deeply, into the motivation for functional
programming itself.

## Functional Programming

Lambdas/Closures are there to aid functional programming. Java 8 is not
suddenly a functional programming language, but (like Python) now has some
support for functional programming on top of its basic object-oriented
paradigm.

The core idea of functional programming is that you can create and manipulate
functions, including creating functions at runtime. Thus, functions become
another thing that your programs can manipulate (instead of just data). This
adds a lot of power to programming.

A *pure* functional programming language includes other restrictions, notably
data invariance. That is, you don't have variables, only unchangeable values.
This sounds overly constraining at first (how can you get anything done without
variables?) but it turns out that you can actually accomplish everything with
values that you can with variables (you can prove this to yourself using Scala,
which is itself *not* a pure functional language but has the option to use
values everywhere). Invariant functions take arguments and produce results
without modifying their environment, and thus are much easier to use for
parallel programming because an invariant function doesn't have to lock shared
resources.

Before Java 8, the only way to create functions at runtime was through bytecode
generation and loading (which is quite messy and complex).

Lambdas provide two basic features:

1. More succinct function-creation syntax.

2. The ability to create functions at runtime, which can then be
passed/manipulated by other code.

Closures concern this second issue.

## What is a Closure?

A closure uses variables that are outside of the function scope. This is not a
problem in traditional procedural programming -- you just use the variable --
but when you start producing functions at runtime it does become a problem. To
see the issue, I'll start with a Python example. Here, `make_fun()` is creating
and returning a function called `func_to_return`, which is then used by the
rest of the program:

```python
# Closures.py

def make_fun():
    # Outside the scope of the returned function:
    n = 0

    def func_to_return(arg):
        nonlocal n
        # Without 'nonlocal' n += arg produces:
        # local variable 'n' referenced before assignment
        print(n, arg, end=": ")
        arg += 1
        n += arg
        return n

    return func_to_return

x = make_fun()
y = make_fun()

for i in range(5):
    print(x(i))

print("=" * 10)

for i in range(10, 15):
    print(y(i))

""" Output:
0 0: 1
1 1: 3
3 2: 6
6 3: 10
10 4: 15
==========
0 10: 11
11 11: 23
23 12: 36
36 13: 50
50 14: 65
"""
```

Notice that `func_to_return` manipulates two fields that are outside its scope:
`n` and `arg` (depending on what it is, `arg` might be a copy, or it might
refer to something outside its scope). The `nonlocal` declaration is required
because of the way Python works: if you just start using a variable, it assumes
that variable is local. Here, the compiler (yes, Python has a compiler and yes,
it actually does some -- admittedly quite limited -- static type checking) sees
that `n += arg` uses `n` which, within the scope of `func_to_return`, hasn't
been initialized, and generates an error message. But if we say that `n` is
`nonlocal`, Python realizes that we're using the `n` that's defined outside the
function scope, and which *has* been initialized, so it's OK.

Now we encounter the problem: if we simply return `func_to_return`, what
happens to `n`, which is outside the scope of `func_to_return`? Ordinarily we'd
expect `n` to go out of scope and become unavailable, but if that happens then
`func_to_return` won't work. In order to support dynamic creation of functions,
`func_to_return` must "close over" and keep alive `n` when the function is
returned, and that's what happens -- thus the term *closure*.

To test `make_fun()`, we call it twice and capture the resulting function in
`x` and `y`. The fact that `x` and `y` produce completely different results
shows that each call to `make_fun()` produces a completely independent
`func_to_return` with completely independent closed-over storage for `n`.

## Java 8 Lambdas

Now let's see what the same example looks like with lambdas:

```java
// AreLambdasClosures.java
import java.util.function.*;

public class AreLambdasClosures {
    public Function<Integer, Integer> make_fun() {
        // Outside the scope of the returned function:
        int n = 0;
        return arg -> {
            System.out.print(n + " " + arg + ": ");
            arg += 1;
            // n += arg; // Produces error message
            return n + arg;
        };
    }
    public void try_it() {
        Function<Integer, Integer>
            x = make_fun(),
            y = make_fun();
        for(int i = 0; i < 5; i++)
            System.out.println(x.apply(i));
        for(int i = 10; i < 15; i++)
            System.out.println(y.apply(i));
    }
    public static void main(String[] args) {
        new AreLambdasClosures().try_it();
    }
}
/* Output:
0 0: 1
0 1: 2
0 2: 3
0 3: 4
0 4: 5
0 10: 11
0 11: 12
0 12: 13
0 13: 14
0 14: 15
*/
```

It's a mixed bag: we can indeed access `n`, but we immediately run into trouble
when we try to modify `n`. The error message is: `local variables referenced
from a lambda expression must be final or effectively final`.

It turns out that, in Java, lambdas only close over *values*, but not
variables. Java requires those values to be unchanging, as if they had been
declared `final`. So they must be `final` whether you declare them that way or
not. Thus, "effectively `final`." And thus, Java has "closures with
restrictions," which might not be "perfect" closures, but are nonetheless still
quite useful.

If we create heap-based objects, we can modify the object, because the compiler
only cares that the reference is not modified. For example:

```java
// AreLambdasClosures2.java
import java.util.function.*;

class myInt {
    int i = 0;
}

public class AreLambdasClosures2 {
    public Consumer<Integer> make_fun2() {
        myInt n = new myInt();
        return arg -> n.i += arg;
    }
}
```

This compiles without complaint, and you can test it by putting the `final`
keyword on the definition for `n`. Of course, if you use this with any kind of
concurrency, you have the problem of mutable shared state.

Lambda expressions accomplish -- at least partially -- the desired goal: it's
now possible to create functions dynamically. If you step outside the bounds,
you get an error message, but there's generally a way to solve the problem.
It's not as straightforward as the Python solution, but this is Java, after
all, and we've been trained to take what we are given. And ultimately the
end result, while somewhat constricted (face it, everything in Java is
somewhat constricted) is not too shabby.

I asked why the feature wasn't just called "closures" instead of "lambdas,"
since it has the characteristics of a closure? The answer I got was that
closure is a loaded and ill defined term, and was likely to create more
heat than light. When someone says "real closures," it too often means
"what closure meant in the first language I encountered with something
called closures."

I don't see an OO versus FP (functional programming) debate here; that is
not my intention. Indeed, I don't really see a "versus" issue. OO is good
for abstracting over data (and just because Java forces objects on you
doesn't mean that objects are the answer to every problem), while FP is
good for abstracting over behavior. Both paradigms are useful, and mixing
them together has been even more useful for me, both in Python and now in
Java 8. (I have also recently been using Pandoc, written in the pure FP
Haskell language, and I've been extremely impressed with that, so it
seems there is a valuable place for pure FP languages as well).