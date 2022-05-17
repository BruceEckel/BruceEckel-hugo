---
date: '2022-05-11'
published: true
title: Misunderstanding Python Class Attributes
url: /2022/05/11/misunderstanding-python-class-attributes
author: "Bruce Eckel"
---


I was attempting to assist on an open-source project when I was stopped short by
this (names have been changed):

```python
class DataPoint:
    measurement1 = None
    measurement2 = None
    measurement3 = None
```

`DataPoint` was later used like this:

```python
d = DataPoint()
d.measurement1 = 100
d.measurement2 = 200
d.measurement3 = 300
```

Why give names and initialization values to `class` attributes, then when you
make an object, immediately create and initialize instance variables with the
*same names* as the class attributes? I began to suspect a misunderstanding
about class attributes.

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

(`f"{a.x = }"` is an f-string feature that eliminates the redundancy of
displaying a variable.)

Sure enough, if I create an `A` object called `a` and ask for `a.x`, it looks
like `x` has the "default value" of `100`. I can set `a.x` to `-1` and create a
second `A` object `a2` which once again is given the "default value" of
100---separate storage appears to have been created and initialized for the `x`
in both `a` and `a2`. Based on this simple example, Python class attributes
seem to produce default value behavior.

(The code for this article is on [GitHub](https://github.com/BruceEckel/PythonClassAttributes)).

## Where Did This Idea Come From?

Because of the way class attributes are defined, someone coming from either C++
or Java might assume they work the same as in C++ or Java: Storage for those
variables is allocated and initialized *before* the constructor[^1] is called.
Indeed, the first time I saw class attributes used for automated constructor
generation (a trick we shall visit later in this article), I wondered if I had
previously missed something magical about class attributes.

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
    System.out.println("new A(): " + new A());
    // In A constructor: x = 100
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

In `class B`, `x` is changed to a `static` variable, which means there is only a
single piece of `x` storage for the class---no matter how many instances of
that class you create. This is how Python class attributes work; they are `static` variables without using the `static` keyword.

In `B`'s `toString()`, notice that `B`'s `x` is accessed the same way it is in
`Class A`'s `toString()`: as if it were an ordinary object field rather than a
`static` field. When you do this, Java automatically uses the `static` `x`
even though you are syntactically treating it like the object's `x`.

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

Just like Java, storage is allocated and initialized for `x` by the time the
`A()` constructor is called.

In `class B`, the `static int x` definition only indicates that `x` exists for
`B`. To allocate and initialize static variable storage, the external definition
`int B::x = 100` is required. If, however, the `static` is `const`, the
initialization value is included in the definition as seen in `class C`. The
compiler is able to inline `const` values where they are used, so no storage is
required.

In `class B`, you see that, like Java, C++ also disallows name shadowing.
`main()` shows that `static x` can be accessed either through the class or using
an instance of the class.

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
`1_like_default_values.py`, a C++ or Java programmer might well conclude that
Python does indeed work that way. And, because a class attribute is a single
variable that is "global to the class," it can be mistaken for a default value.

## How Things Break

The worst thing about this is that code written with the assumption that class
attributes are just default initialization values seems to work most of the time
for simple situations like the one I encountered. The code passes its tests, so
how can I call it "wrong?"

The problem occurs when you're least expecting it. Here is just one
configuration that produces a surprise:

```python
# 4_it_all_goes_wrong.py

class A:
    x: int = 100
    y: int = 200
    @classmethod
    def change_x(cls):
        cls.x = 999
    @classmethod
    def change_y(cls):
        cls.y = 313

def reset():
    A.x = 100
    A.y = 200

if __name__ == '__main__':
    a1: A = None
    a2: A = None
    a3: A = None
    def display(counter: int):
        print(f"display({counter})")
        if a1:
            print(f"{a1.x = }, {a1.y = }")
        if a2:
            print(f"{a2.x = }, {a2.y = }")
        if a3:
            print(f"{a3.x = }, {a3.y = }")

    a1 = A()
    display(1)
    # a1.x = 100, a1.y = 200
    a1.x = -1
    a1.y = -2
    display(2)
    # a1.x = -1, a1.y = -2
    a1.change_x()
    display(3)
    # a1.x = -1, a1.y = -2
    a2 = A()
    display(4)
    # a1.x = -1, a1.y = -2
    # a2.x = 999, a2.y = 200
    a2.y = 17
    display(5)
    # a1.x = -1, a1.y = -2
    # a2.x = 999, a2.y = 17
    A.change_y()
    a3 = A()
    display(6)
    # a1.x = -1, a1.y = -2
    # a2.x = 999, a2.y = 17
    # a3.x = 999, a3.y = 313
    reset()
    display(7)
    # a1.x = -1, a1.y = -2
    # a2.x = 100, a2.y = 17
    # a3.x = 100, a3.y = 200
```

Every object instance has its own dictionary. When you assign to an instance
variable, you add a binding to the instance dictionary. But a class definition
creates a (class) object, which also has its own dictionary. When you
define a class attribute, you add a binding to the class dictionary.

When Python looks up an attribute, it (generally) starts at the instance and if
it doesn't find the attribute there, falls back to looking it up in the
associated class/type dictionary (the same way that C++ and Java do).

`class A` contains two class attributes. `change_x()` and `change_y()` are
"class methods," which mean they operate on the class object, and not a
particular instance of that class. The first parameter of a `classmethod` is
thus not `self` (the instance reference) but instead `cls` (the class
reference). `change_x()` and `change_y()` modify the class attributes, and
`reset()` sets both class attributes back to their original values.

The main code starts by creating three `A` references initialized to `None`, and
a `display()` function that shows the `x` and `y` values for each non-`None`
object.

Everything looks like it exhibits "default value" behavior until we call
`change_x()` and `change_y()`, then things get strange. The original `a1`
produces the same results as before, but `a2` is partially affected (`x` changes
but not `y`) and the new `a3` has different "default values." Calling `reset()`
modifies `a2` (partially) and `a3` (completely), but not `a1`.

`reset()` changes objects it has no direct connection with. The changes
themselves are inconsistent across the different objects. Imagine these kinds of
errors appearing in your code base, and trying to track them down based on the
varying behavior of these so-called "default values."

## Class Attributes

The source of confusion is twofold:

1. Python's dynamic nature. Instance variables are not automatically created,
   not even in the constructor. They are created the first time they are *assigned to*, which can happen just about anywhere.

2. Unlike C++ and Java, Python allows instance variables to shadow (have the
   same name as) class attributes. This feature gets significant use in
   libraries that simplify configuration by using class attributes to
   automatically generate constructors and other methods.

The two confusions compound, because if you ask for an uncreated instance
variable with the same name as a class attribute, Python quietly returns the
class attribute. If at some later point the instance variable of the same name
is created (by assigning something to its identifier), the object will from then
on produce the instance variable instead of the class attribute. The same
behavior that makes a class attribute look like a default value can cause subtle
bugs.

To see this in action, we need a function that displays the inside of classes
and objects:

```python
# look_inside.py

def attributes(d: object) -> str:
    return ", ".join(
        [f"{k}: {v}" for k, v in vars(d).items()
         if not k.startswith("__")]) or "Empty"

def show(obj: object, obj_name: str) -> None:
    klass: type = obj.__class__
    print(f"[Class {klass.__name__}] {attributes(klass)}")
    print(f"[Object {obj_name}] {attributes(obj)}")
```

`attributes()` can be applied to either a class or an object. It uses the
builtin `vars()` function to produce the dictionary, skips dunder functions, and
produces names and values or `"Empty"` if there are none. `attributes()` is used
in `show()` to display both the class and an object of that class. Now we can
see the details when using class attributes:

```python
# 5_class_attributes.py
from look_inside import show

class A:
    x: int = 100

class B:
    x: int = 100
    def __init__(self, x_init: int):
        # Shadows the class attribute name:
        self.x = x_init

if __name__ == '__main__':
    a = A()
    show(a, "a")
    # [Class A] x: 100
    # [Object a] Empty
    a.x = 1
    show(a, "a")
    # [Class A] x: 100
    # [Object a] x: 1

    b = B(-99)
    show(b, "b")
    # [Class B] x: 100
    # [Object b] x: -99
```

Creating an `A` requires no constructor arguments (because there is no
constructor). There are no instance variables for `a` until after the assignment
`a.x = 1`. `B`'s constructor requires an argument and uses it to assign to an
instance variable (thus creating it).

Let's look at the original example using `show()`:

```python
# 6_like_default_values_shown.py
from look_inside import show

class A:
    x: int = 100

if __name__ == '__main__':
    a = A()
    show(a, "a")
    # [Class A] x: 100
    # [Object a] Empty
    print(f"{a.x = }")
    # a.x = 100
    a.x = -1
    show(a, "a")
    # [Class A] x: 100
    # [Object a] x: -1
    print(f"{a.x = }")
    # a.x = -1
    a2 = A()
    show(a2, "a2")
    # [Class A] x: 100
    # [Object a2] Empty
    print(f"{a2.x = }")
    # a2.x = 100
```

In the first `print()`, the instance variable `x` has not yet been created, so
Python helpfully produces the class attribute of the same name. But the
assignment `a.x = -1` creates an instance variable, and so the second `print()`
sees that instance variable. When we create a new `A` for `a2`, we're back to a
new object without an instance variable so it once again produces the class
attribute, making it look like a default value.

If you never do anything more complex than this, you won't know there are
lurking problems.

## The Class Attribute Trick

Name shadowing is an intentional part of Python's design, and has become an
integral part of the way some libraries provide easy class configuration. The
first time I saw it was in Django:

```python
class Blog(models.Model):
    name = models.CharField(max_length=100)
    tagline = models.TextField()

    def __str__(self):
        return self.name
```

This seemed magical and confusing. There's no visible constructor but somehow
`__str__` can access `self.name`. Presumably the base-class constructor creates
the instance variables by using the class attributes as a template.

Python's `dataclasses` use a decorator to generate code for the constructor and
other methods using class attributes as a template. Simply adding `dataclasses` to `4_it_all_goes_wrong.py` fixes the problem:

```python
from dataclasses import dataclass

@dataclass
class A:
    x: int = 100
    y: int = 200
```

I suspect that the use of class attributes as code-generation templates will continue.

## Recommendations

The solution is to *not* make class attributes seem like default values.
Instead, write proper constructors with default arguments, as you see in
`class A`:

```python
# 7_choices.py
from look_inside import show
from dataclasses import dataclass

class A:
    def __init__(self, x: int = 100, y: int = 200, z: int = 300):
        self.x = x
        self.y = y
        self.z = z

# OR:

@dataclass
class AA:
    x: int = 100
    y: int = 200
    z: int = 300

if __name__ == '__main__':
    a = A()
    show(a, "a")
    # [Class A] Empty
    # [Object a] x: 100, y: 200, z: 300
    a.x = -1
    a.y = -2
    a.z = -3
    show(a, "a")
    # [Class A] Empty
    # [Object a] x: -1, y: -2, z: -3

    aa = AA()
    print(aa)
    # AA(x=100, y=200, z=300)
    show(aa, "aa")
    # [Class AA] x: 100, y: 200, z: 300
    # [Object aa] x: 100, y: 200, z: 300
    aa.x = -1
    aa.y = -2
    aa.z = -3
    show(aa, "aa")
    # [Class AA] x: 100, y: 200, z: 300
    # [Object aa] x: -1, y: -2, z: -3
    aa2 = AA(-4, -5, -6)
    show(aa2, "aa2")
    # [Class AA] x: 100, y: 200, z: 300
    # [Object aa2] x: -4, y: -5, z: -6

    # Even if we modify the class attributes, the
    # constructor default arguments stay the same:
    AA.x = 42
    AA.y = 74
    AA.z = 22
    aa3 = AA()
    show(aa3, "aa3")
    # [Class AA] x: 42, y: 74, z: 22
    # [Object aa3] x: 100, y: 200, z: 300
```

You can also use a `dataclass` as seen in `class AA`. Notice the result of
`print(aa)` produces a useful description of the object because the `dataclass`
automatically generates a `__repr__()`.

The `dataclass` decorator generates a constructor with default arguments that
match the class attributes. After that you can modify the class attributes and
it has no effect on the constructed objects. It seems like `dataclasses` are
what the original author of the code I encountered was hoping for.

Although Python's syntax can make it look like other languages, its dynamic
nature strongly influences the language's semantics. Assumptions that
it works like C++ or Java will generally produce incorrect results.

You can learn more about `dataclasses` from my Pycon 2022 presentation *Making
Dataclasses Work for You*, on YouTube (not yet available at this writing).

Thanks to Barry Warsaw for reviewing and giving feedback.

[^1]: Languages like C++ and Java use *constructor* to mean "activities performed after storage allocation and basic initialization." C++ also has a `new()` for controlling memory allocation, calling it "operator new" rather than "constructor." In contrast, Python's constructor is usually defined as the `__new__()` function, and `__init__()` is called the initializer. C++'s operator `new()` and Python's `__new__()` are almost never overridden, and are rarely even mentioned (The common usage for Python's `__new__()` seems to be to create *Factory* functions). To keep things simple I just say "constructor" when referring to `__init__()`.
