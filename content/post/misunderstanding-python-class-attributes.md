---
date: '2022-05-08'
published: false
title: Misunderstanding Python Class Attributes
url: /2022/05/08/misunderstanding-python-class-attributes
author: "Bruce Eckel"
---

I was attempting to assist on an open-source project when was stopped short by
this (names have been changed):

```python
class DataPoint:
    measurement1 = None
    measurement2 = None
    measurement3 = None
```

Which was later used like this:

```python
d = DataPoint()
d.measurement1 = 100
d.measurement2 = 200
d.measurement3 = 300
```

Why give names and initialization values to **class** attributes, then when you
create an object, immediately create **object** attributes with the *same names*
as the class attributes? It occurred to me that there might be a
misunderstanding about the way attributes work.

I found one of the coaches of the project (who was not the original author) and
asked. It was explained to me that this was the way you provide default values
for Python objects. When I attempted to disagree, the effects were demonstrated
using a debugger. The argument looked something like this:

```python
# 1_like_default_values.py

class A:
    x: int = 100

if __name__ == '__main__':
    a = A()
    print(f"{a.x = }")
    # a.x = 100
    a.x = -1
    print(f"{a.x = }")
    # a.x = -1
    a2 = A()
    print(f"{a2.x = }")
    # a2.x = 100
```

Sure enough, if I create an `A` object called `a` and ask for `a.x`, it looks
like `x` has the "default value" of `100`. I can set `a.x` to `-1` and create a
second `A` object `a2` which once again is given the "default value" of
100---"obviously" separate storage has been created for `a1` and `a2`. This is
clearly how the feature works, and no further curiosity or exploration is
necessary.

My frustration (evidenced by the fact I never thought of bringing up the Python
docs for class attributes) at not being able to explain led to this article.

## Where Did This Idea Come From?

I eventually realized that someone who had used either C++ or Java would assume
that the form of writing a class using class attributes would work the way it
does in C++ or Java: Storage for those variables would be allocated and
initialized, *before* the constructor is called. Indeed, the first time I saw
class attributes used for automated constructor generation (a trick we shall
visit later in this article), I wondered if I had previously missed something
magical about class attributes.

Here's a Java example exploring the same ideas:

```java
// 2_DefaultValues.java
// Rename to DefaultValues.java
// Java automatically initializes from defaults

class A {
  int x = 100;
  public A() {
    // x is already initialized:
    System.out.println("In A constructor: " + this);
  }
  @Override
  public String toString() {
    return "x = " + x;
  }
}

class B {
  static int x = 100;
  @Override
  public String toString() {
    // Accessing static via instance:
    return "x = " + x;
    // Same as "x = " + this.x;
  }
  static public String statics() {
    return "B.statics(): B.x = " + B.x;
  }
  // Cannot shadow identifier names:
  // int x = -1;
  // Variable 'x' is already defined in the scope
}

public class DefaultValues {
  public static void main(String[] args) {
    A a = new A();
    // In A constructor: x = 100
    System.out.println("a: " + a);
    // a: x = 100
    a.x = -1;
    System.out.println("a: " + a);
    // a: x = -1
    // In A constructor: x = 100
    System.out.println("new A(): " + new A());
    // new A(): x = 100

    B b = new B();
    System.out.println("b: " + b);
    // b: x = 100
    System.out.println(B.statics());
    // B.statics(): B.x = 100
    // Accessing static via class:
    B.x = -1;
    System.out.println("b: " + b);
    // b: x = -1
    System.out.println(B.statics());
    // B.statics(): B.x = -1
    B b2 = new B();
    System.out.println("b2: " + b2);
    // b2: x = -1
  }
}
```

Inside the constructor `A()`, the storage for `x` has already been allocated and
initialized. Changing the value of `a.x` doesn't influence further new `A`
objects, which are initialized to `100`.

In `class B`, `x` is no longer a field, but is instead a `static` variable,
which means there is only a single piece of storage for `x` for the class (no
matter how many instances of that class you create), and `x` is associated with
the class `B` rather than with any particular `B` object. This is the same way
that class attributes work in Python---they are basically `static` variables
without using the `static` keyword.
