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

(`f"{a.x = }"` is an f-string feature that eliminates the redundancy of
displaying a variable).

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
work that way. And, because a class attribute is a single variable that is
"global to the class," it can be mistaken for a default value.

## How Things Break

The worst thing about this is that code written with the assumption that class
attributes are just default initialization values seems to work most of the
time, especially for simple situations like the one I encountered. The code passes its tests, so how can I call it "wrong?"

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
    print(f"{A.x = }, {A.y = }")
    # A.x = 100, A.y = 200

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
itself contains two class attributes. `oops()` changes the class attribute `x`
of class `A`.

In the main code we again show how the class attributes of `A` appear to produce
"default value" behavior: `a.x` and `a.y` seem to be initialized to the "default
values" and when we change them the original "default values" are unaffected.

## Class Attributes

The source of the confusion is twofold:

1. Python's dynamic nature. Instance variables are not automatically created,
   not even in the constructor. They are created the first time they are assigned to, which can happen in many places.

2. Unlike C++ and Java, Python allows instance variables to shadow class
   variables (have the same name). This feature gets significant use in
   libraries that simplify configuration by using class variables to
   automatically generate constructors and other methods.

The two confusions compound, because if you ask for an uncreated instance
variable with the same name as a class attribute, Python quietly returns the
class attribute. If at some later point the instance variable is assigned to,
the object will from then on produce the instance variable instead of the class
attribute. The same behavior that makes a class attribute look like a default
value causes subtle bugs that will probably be very hard to track down.

To see this in action, we'll need a function to display the insides of classes
and objects:

```python
# look_inside.py

def attributes(d: object) -> str:
    return ", ".join(
        [f"{k}: {v}" for k, v in vars(d).items()
         if not k.startswith("__")]) or "Empty"

def show(klass: type, obj: object, obj_name: str) -> None:
    print(f"[Class {klass.__name__}] {attributes(klass)}")
    print(f"[Object {obj_name}] {attributes(obj)}\n")
```


Now we can use `show()` to see the details when using class attributes:

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
    show(A, a, "a")
    # [Class A] x: 100
    # [Object a] Empty
    a.x = 1
    show(A, a, "a")
    # [Class A] x: 100
    # [Object a] x: 1

    b = B(-99)
    show(B, b, "b")
    # [Class B] x: 100
    # [Object b] x: -99
```


Let's look at the first example again through the lens of this new knowledge:

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

In the first `print()`, the instance variable `x` has not yet been created, so
Python helpfully produces the class attribute of the same name. But the
assignment `a.x = -1` creates an instance variable, and so the second `print()`
sees that instance variable. When we create a new `A` for `a2`, we're back to a
new object without an instance variable so it once again produces the class
attribute, making it look like a default value. And if you never do anything
more complex than this, you won't know that there are lurking problems that
someone else might trip over.

## The Class Attribute Trick

It's not clear to me whether name shadowing is an intentional part of Python's
design, or an oversight. Either way, it has become an integral part of the way
some libraries provide easy class configuration. The first time I saw it was
in Django:

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

@dataclass
class B:
    a: A = A()
```

The use of class attributes as code-generation templates will likely increase.

## Recommendations

I hope that at this point you will cease attempting to make class attributes
look like default values and just write proper constructors with default
arguments, as you see in `class A`:

```python
# 6_choices.py
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
    show(A, a, "a")
    # [Class A] Empty
    # [Object a] x: 100, y: 200, z: 300
    a.x = -1
    a.y = -2
    a.z = -3
    show(A, a, "a")
    # [Class A] Empty
    # [Object a] x: -1, y: -2, z: -3

    aa = AA()
    print(aa)
    # AA(x=100, y=200, z=300)
    show(AA, aa, "aa")
    # [Class AA] x: 100, y: 200, z: 300
    # [Object aa] x: 100, y: 200, z: 300
    aa.x = -1
    aa.y = -2
    aa.z = -3
    show(AA, aa, "aa")
    # [Class AA] x: 100, y: 200, z: 300
    # [Object aa] x: -1, y: -2, z: -3
    aa2 = AA(-4, -5, -6)
    show(AA, aa2, "aa2")
    # [Class AA] x: 100, y: 200, z: 300
    # [Object aa2] x: -4, y: -5, z: -6

    # Even if we modify the class attributes, the
    # constructor default arguments stay the same:
    AA.x = 42
    AA.y = 74
    AA.z = 22
    aa3 = AA()
    show(AA, aa3, "aa3")
    # [Class AA] x: 42, y: 74, z: 22
    # [Object aa3] x: 100, y: 200, z: 300
```

There's a second option. If your class is just a holder for data, you can use a
`dataclass` as seen in `class AA`. Notice the result of `print(aa)` produces a
useful description of the object because the `dataclass` automatically generates
a `__repr__()`.

The `dataclass` decorator generates a constructor with default arguments that
match the class attributes. After that you can modify the class attributes and
it has no effect on the constructed objects.
