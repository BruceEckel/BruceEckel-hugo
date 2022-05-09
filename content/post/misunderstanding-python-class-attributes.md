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
create an object, immediately create and initialize **object** attributes with
the *same names* as the class attributes? It occurred to me that there might be
a misunderstanding about the way attributes work.

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
100---"obviously" separate storage has been created for `a1` and `a2`. "This is
clearly how the feature works, and no further curiosity or exploration is
necessary."

My frustration at not being able to explain (evidenced by the fact I never
thought of bringing up the Python docs for class attributes) led to this
article.

(The code for this article is on [GitHub](https://github.com/BruceEckel/PythonClassAttributes)).

## Where Did This Idea Come From?

I eventually realized that someone who had used either C++ or Java might assume
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

In `class B`, `x` has been changed to a `static` variable, which means there is
only a single piece of storage for `x` for the class (no matter how many
instances of that class you create), and `x` is associated with the class `B`
rather than with any particular `B` object. This is the same way that class
attributes work in Python---they are basically `static` variables without using
the `static` keyword.

In `toString()`, notice that `x` is accessed in the same way it is in
`Class A`'s `toString()`: as if it were an ordinary object field rather than a
`static` field. When you do this, Java automatically goes to the `static` `x`
even though you are syntactically treating it like an object `x`.

In `statics()`, `x` is accessed *through the class* by saying `B.x`. If `x` were
*not* a `static` you couldn't do this.

At the end of `class B`, notice that we cannot "shadow" an identifier name like
we can in Python: we cannot have both an ordinary and a `static` variable of the
same name. `main()` demonstrates that the `static x` in `B` is indeed associated
with the class, and there's only one piece of storage shared by all objects of
`class B`.

C++ has virtually identical behavior, although `static` initialization syntax is different for variables:

```cpp
// 3_default_values.cpp
// C++ automatically initializes from defaults
// Tested on http://cpp.sh
#include <iostream>

class A {
    public:
    int x = 100;
    A() { // x is already initialized:
        std::cout << "constructor: " << x << std::endl;
    }
};

class B {
    public:
    static int x;
    B() { // x has been initialized:
        std::cout << "constructor: " << x << std::endl;
    }
    // Cannot shadow identifier name:
    // int x = 1;
    // 'int B::x' conflicts with a previous declaration
};

// Static variables must be initialized outside the class:
int B::x = 100;

// Static consts are initialized inline:
class C {
    public:
    static const int x = 100;
};

int main() {
    A a;
    // constructor: 100
    std::cout << a.x << std::endl;
    // 100
    a.x = -1;
    std::cout << a.x << std::endl;
    // -1

    B b;
    // constructor: 100
    std::cout << b.x << std::endl;
    // 100
    // Accessing static via instance:
    b.x = -1;
    std::cout << b.x << std::endl;
    // -1
    // Accessing static via class:
    B::x = -99;
    std::cout << b.x << std::endl;
    // -99

    C c;
    std::cout << c.x << std::endl;
    // 100
    // Cannot assign to const:
    // c.x = -1;
}
```

Just like Java, storage has been allocated for `x` and it has been initialized by the time the `A()` constructor is called.

In `class B`, the `static int x;` definition only indicates that `x` exists in
`B`. To allocate storage and initialize it, the external definition
`int B::x = 100;` is required. If, however, the `static` value is `const`, it
can be folded into the definition as seen in `class C`. The compiler is able to
fold `const` values into where they are used, so no storage is required.

In `class B`, you see that, like Java, C++ also disallows name shadowing.
`main()` shows that the `static x` can be accessed either through the class or
using an instance of the class.

Notice that both Java and C++ have explicit `static` keywords, whereas Python
does not. This adds to the confusion, so when a Java or C++ programmer (who has not learned about class attributes) sees something of the form:

```python
Class X:
    a = 1
    b = 2
    c = 3
```

It is quite reasonable to expect the same results as from similar-looking C++ or
Java code. After doing a few simple experiments as in
`1_like_default_values.py`, they could easily conclude that Python does indeed
work that way.

## How Things Break

The worst thing about this is that code written with the assumption that class
attributes are just default initialization values seems to work most of the
time, especially for simple situations like the one I encountered. This code passes its tests, so how can I call it "wrong?"

The problem occurs when you're least expecting it. Here is just one
configuration that produces a surprise:

```python
# 4_it_all_goes_wrong.py

class A:
    x: int = 100
    y: int = 200

class B:
    a: A = A()

def oops(): A.x = 999999

if __name__ == '__main__':
    a = A()
    print(f"{a.x = }, {a.y = }")
    # a.x = 100, a.y = 200
    a.x = -1
    a.y = -2
    print(f"{a.x = }, {a.y = }")
    # a.x = -1, a.y = -2
    b = B()
    b.a.y = 22
    print(f"{b.a.x = }, {b.a.y = }")
    # b.a.x = 100, b.a.y = 22
    oops()  # Has no reference to object 'b'
    print(f"{b.a.x = }, {b.a.y = }")
    # b.a.x = 999999, b.a.y = 22
    print(f"{a.x = }, {a.y = }")
    # a.x = -1, a.y = -2
```

`class B` contains a class attribute that's an instance of `class A` which
itself contains two class attributes.
