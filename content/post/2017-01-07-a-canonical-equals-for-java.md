---
date: '2017-01-07'
published: true
title: A Canonical equals() For Java
url: /2017/01/07/a-canonical-equals-for-java
---


> Even with the help of Java 7's `Objects.equals()`, the `equals()` method is often
> written in a verbose and messy fashion. This article shows how you can
> write a succinct `equals()` in a format that allows easy checking with visual
> inspection.

When you create a new class, it automatically inherits class `Object`. If you
don't override `equals()`, you'll get `Object`s `equals()` method. By default
this compares addresses, so only if you are comparing the *exact same* objects
will you get `true`. The default case is the "most discriminating."

```java
// DefaultComparison.java

class DefaultComparison {
  private int i, j, k;
  public DefaultComparison(int i, int j, int k) {
    this.i = i;
    this.j = j;
    this.k = k;
  }
  public static void main(String[] args) {
    DefaultComparison
      a = new DefaultComparison(1, 2, 3),
      b = new DefaultComparison(1, 2, 3);
    System.out.println(a == a);
    System.out.println(a == b);
  }
}
/* Output:
true
false
*/
```

Normally you'll want to relax this restriction. Typically, if two objects are
the same type and have fields with identical values, you'll consider those
objects equal, but there may also be fields that you don't want to include in
the `equals()` comparison. This is part of the class design process.

A proper `equals()` must satisfy the following five conditions:

1.  Reflexive: For any `x`, `x.equals(x)` should return `true`.

2.  Symmetric: For any `x` and `y`, `x.equals(y)` should return `true` if and
    only if `y.equals(x)` returns `true`.

3.  Transitive: For any `x`, `y`, and `z`, if `x.equals(y)` returns `true`
    and `y.equals(z)` returns `true`, then `x.equals(z)` should return `true`.

4.  Consistent: For any `x` and `y`, multiple invocations of `x.equals(y)`
    consistently return `true` or consistently return `false`, provided no
    information used in equals comparisons on the object is modified.

5.  For any non-`null x`, `x.equals(null)` should return `false`.

Here are the tests that satisfy those conditions and determine whether the
object you're comparing yourself to (which we'll call here the **rval**) is
equal to this object:

1.  If the **rval** is `null`, it's not equal.

2.  If the **rval** is `this` (you're comparing yourself to yourself),
    the two objects are equal.

3.  If the **rval** is not the same class or subclass, the two objects are not
    equal.

4.  If all the above checks pass, then you must decide which fields in the
    **rval** are important (and consistent), and compare those.

Java 7 introduced the `Objects` class to help with this process, which we use
to write a better `equals()`.

The following examples compare different versions of the `Equality` class. To
prevent duplicate code we'll build the examples using the *Factory Method*. The
`EqualityFactory` interface simply provides a `make()` method to produce an
`Equality` object, so a different `EqualityFactory` can produce a different
subtype of `Equality`:

```java
// EqualityFactory.java
import java.util.*;

interface EqualityFactory {
  Equality make(int i, String s, double d);
}
```

Now we'll define `Equality` containing three fields (all of which we consider
important during comparison) and an `equals()` method that fulfills the four
checks described above. The constructor displays its type name to ensure we are
performing the tests we think we are:

```java
// Equality.java
import java.util.*;

public class Equality {
  protected int i;
  protected String s;
  protected double d;
  public Equality(int i, String s, double d) {
    this.i = i;
    this.s = s;
    this.d = d;
    System.out.println("made 'Equality'");
  }
  @Override
  public boolean equals(Object rval) {
    if(rval == null)
      return false;
    if(rval == this)
      return true;
    if(!(rval instanceof Equality))
      return false;
    Equality other = (Equality)rval;
    if(!Objects.equals(i, other.i))
      return false;
    if(!Objects.equals(s, other.s))
      return false;
    if(!Objects.equals(d, other.d))
      return false;
    return true;
  }
  public void
  test(String descr, String expected, Object rval) {
    System.out.format("-- Testing %s --%n" +
      "%s instanceof Equality: %s%n" +
      "Expected %s, got %s%n",
      descr, descr, rval instanceof Equality,
      expected, equals(rval));
  }
  public static void testAll(EqualityFactory eqf) {
    Equality
      e = eqf.make(1, "Monty", 3.14),
      eq = eqf.make(1, "Monty", 3.14),
      neq = eqf.make(99, "Bob", 1.618);
    e.test("null", "false", null);
    e.test("same object", "true", e);
    e.test("different type", "false", new Integer(99));
    e.test("same values", "true", eq);
    e.test("different values", "false", neq);
  }
  public static void main(String[] args) {
    testAll( (i, s, d) -> new Equality(i, s, d));
  }
}
/* Output:
made 'Equality'
made 'Equality'
made 'Equality'
-- Testing null --
null instanceof Equality: false
Expected false, got false
-- Testing same object --
same object instanceof Equality: true
Expected true, got true
-- Testing different type --
different type instanceof Equality: false
Expected false, got false
-- Testing same values --
same values instanceof Equality: true
Expected true, got true
-- Testing different values --
different values instanceof Equality: true
Expected false, got false
*/
```

`testAll()` performs comparisons with all different types of objects we ever
expect to encounter. It creates `Equality` objects using the factory.

In `main()`, notice the simplicity of the call to `testAll()`. Because
`EqualityFactory` has a single method, it can be used with a lambda expression
as the `make()` method.

The above `equals()` method is annoyingly verbose, and it turns out we can
simplify it into a canonical form. Observe:

1.  The `instanceof` check eliminates the need to test for `null`

2.  The comparison to `this` is redundant. A correctly-written `equals()` will
    work properly with self comparison.

Because `&&` is a short-circuiting comparison, it quits and produces `false`
the first time it encounters a failure. So, by chaining the checks together
with `&&`, we can write `equals()` much more succinctly:

```java
// SuccinctEquality.java
import java.util.*;

public class SuccinctEquality extends Equality {
  public SuccinctEquality(int i, String s, double d) {
    super(i, s, d);
    System.out.println("made 'SuccinctEquality'");
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof SuccinctEquality &&
      Objects.equals(i, ((SuccinctEquality)rval).i) &&
      Objects.equals(s, ((SuccinctEquality)rval).s) &&
      Objects.equals(d, ((SuccinctEquality)rval).d);
  }
  public static void main(String[] args) {
    Equality.testAll( (i, s, d) ->
      new SuccinctEquality(i, s, d));
  }
}
/* Output:
made 'Equality'
made 'SuccinctEquality'
made 'Equality'
made 'SuccinctEquality'
made 'Equality'
made 'SuccinctEquality'
-- Testing null --
null instanceof Equality: false
Expected false, got false
-- Testing same object --
same object instanceof Equality: true
Expected true, got true
-- Testing different type --
different type instanceof Equality: false
Expected false, got false
-- Testing same values --
same values instanceof Equality: true
Expected true, got true
-- Testing different values --
different values instanceof Equality: true
Expected false, got false
*/
```

For each `SuccinctEquality`, the base-class constructor is called before the
derived-class constructor. The output shows that we still get the correct
result. You can tell that short-circuiting happens because both the `null`
test and the "different type" test would otherwise throw exceptions during
the casts that occur further down the list of comparisons in `equals()`.

`Objects.equals()` shines when you compose your new class using another class:

```java
// ComposedEquality.java
import java.util.*;

class Part {
  String ss;
  double dd;
  public Part(String ss, double dd) {
    this.ss = ss;
    this.dd = dd;
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof Part &&
      Objects.equals(ss, ((Part)rval).ss) &&
      Objects.equals(dd, ((Part)rval).dd);
  }
}

public class ComposedEquality extends SuccinctEquality {
  Part part;
  public ComposedEquality(int i, String s, double d) {
    super(i, s, d);
    part = new Part(s, d);
    System.out.println("made 'ComposedEquality'");
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof ComposedEquality &&
      super.equals(rval) &&
      Objects.equals(part, ((ComposedEquality)rval).part);
  }
  public static void main(String[] args) {
    Equality.testAll( (i, s, d) ->
      new ComposedEquality(i, s, d));
  }
}
/* Output:
made 'Equality'
made 'SuccinctEquality'
made 'ComposedEquality'
made 'Equality'
made 'SuccinctEquality'
made 'ComposedEquality'
made 'Equality'
made 'SuccinctEquality'
made 'ComposedEquality'
-- Testing null --
null instanceof Equality: false
Expected false, got false
-- Testing same object --
same object instanceof Equality: true
Expected true, got true
-- Testing different type --
different type instanceof Equality: false
Expected false, got false
-- Testing same values --
same values instanceof Equality: true
Expected true, got true
-- Testing different values --
different values instanceof Equality: true
Expected false, got false
*/
```

Notice the call to `super.equals()`---no need to reinvent it (plus you don't
always have access to all necessary parts of a base class).

### Equality Across Subtypes

Inheritance suggests that objects of two different subtypes can be "the same"
when they are upcast. Suppose you have a collection of `Pet` objects. This
collection will naturally accept subtypes of `Pet`: In this example, `Dog`s and
`Pig`s. Each `Pet` has a `name` and a `size`, as well as a unique internal `id`
number.

We define `equals()` and `hashCode()` using the canonical form via the
`Objects` class, but we only define them in the base class `Pet`, and we do not
include the unique `id` number in either one. From the standpoint of
`equals()`, this means we only care if something is a `Pet`, not whether it is
a specific type of `Pet`:

```java
// SubtypeEquality.java
import java.util.*;

enum Size { SMALL, MEDIUM, LARGE }

class Pet {
  private static int counter = 0;
  private final int id = counter++;
  private final String name;
  private final Size size;
  public Pet(String name, Size size) {
    this.name = name;
    this.size = size;
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof Pet &&
      // Objects.equals(id, ((Pet)rval).id) && // [1]
      Objects.equals(name, ((Pet)rval).name) &&
      Objects.equals(size, ((Pet)rval).size);
  }
  @Override
  public int hashCode() {
    return Objects.hash(name, size);
    // return Objects.hash(name, size, id);  // [2]
  }
  @Override
  public String toString() {
    return String.format("%s[%d]: %s %s %x",
      getClass().getSimpleName(), id,
      name, size, hashCode());
  }
}

class Dog extends Pet {
  public Dog(String name, Size size) {
    super(name, size);
  }
}

class Pig extends Pet {
  public Pig(String name, Size size) {
    super(name, size);
  }
}

public class SubtypeEquality {
  public static void main(String[] args) {
    Set<Pet> pets = new HashSet<>();
    pets.add(new Dog("Ralph", Size.MEDIUM));
    pets.add(new Pig("Ralph", Size.MEDIUM));
    pets.forEach(System.out::println);
  }
}
/* Output:
Dog[0]: Ralph MEDIUM a752aeee
*/
```

If we are just thinking about types, it does make sense---sometimes---to only
consider the classes from the standpoint of their base type, which is the
foundation of the *Liskov Substitution Principle*. This code fits nicely with
that principle because the derived types don't add any extra functionality
(methods) that isn't in the base class. The derived types only differ in
behavior, not in interface (which of course is not the general case).

But when we provide two different object types with identical data and place
them in a `HashSet<Pet>`, only one of these objects survives. This emphasizes
that `equals()` is not a perfectly mathematical concept but (at least
partially) a mechanical one. `hashCode()` and `equals()` must be defined
hand-in-hand in order to allow types to work properly in a hashed data
structure.

In the example, both the `Dog` and `Pig` hash to the same bucket in the
`HashSet`. At this point, the `HashSet` falls back to `equals()` to
differentiate the objects, but `equals()` also declares the objects to be the
same. The  `HashSet` doesn't add the `Pig` because it's already got an
identical object.

We can still make the example work by forcing uniqueness on otherwise identical
objects. Here, each `Pet` already has a unique `id` so you can either uncomment
line **[1]** in `equals()` or switch to line **[2]** in `hashCode()`. In the
canonical form you would do both, to involve all "unchanging" fields in both
operations ("unchanging" so that the `equals()` and `hashCode()` don't produce
different values between storing and retrieving in a hashed data structure. I
put "unchanging" in quotes because you must evaluate whether modification might
happen).

**Side note**: in `hashCode()`, if you are only working with a single field, use
`Objects.hashCode()` and if you are using multiple fields use `Objects.hash()`.

We can also solve the issue by following the standard form and defining
`equals()` in the subclasses (but still not including the unique `id`):

```java
// SubtypeEquality2.java
import java.util.*;

class Dog2 extends Pet {
  public Dog2(String name, Size size) {
    super(name, size);
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof Dog2 &&
      super.equals(rval);
  }
}

class Pig2 extends Pet {
  public Pig2(String name, Size size) {
    super(name, size);
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof Pig2 &&
      super.equals(rval);
  }
}

public class SubtypeEquality2 {
  public static void main(String[] args) {
    Set<Pet> pets = new HashSet<>();
    pets.add(new Dog2("Ralph", Size.MEDIUM));
    pets.add(new Pig2("Ralph", Size.MEDIUM));
    pets.forEach(System.out::println);
  }
}
/* Output:
Dog2[0]: Ralph MEDIUM a752aeee
Pig2[1]: Ralph MEDIUM a752aeee
*/
```

Notice that the `hashCode()`s are identical, but because the objects are no
longer `equals()`, both now appear in the `HashSet`. Also, `super.equals()`
means we don't need access to the `private` fields in the base class.

One way to look at this is to say that Java separates substitutability from the
definition of `equals()` and `hashCode()`. We can still place `Dog`s and `Pig`s
into a `Set<Pet>` regardless of how `equals()` and `hashCode()` are defined,
but the objects won't behave correctly in hashed data structures unless those
methods are defined with hashed structures in mind. Unfortunately, `equals()`
is not only used in conjunction with `hashCode()`. This complicates things when
you try to avoid defining it for specific classes, and it's why it's worth
following the canonical form. However, this is further complicated because
there are times when you don't need to define either method.