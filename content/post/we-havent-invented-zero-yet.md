---
title: "We Haven't Invented Zero Yet"
date: '2020-07-30'
published: true
url: /2020/07/30/we-havent-invented-zero-yet
author: "Bruce Eckel"
---

I suspect most people currently alive were introduced to the concept of zero
quite early in their development&mdash;early enough that they internalized it
as a foundational principle and don't ask questions about it. In addition, many
people probably know that zero was invented after the original number systems.

The ancient Greeks didn't have a zero, and it puzzled them: "How can nothing be
something?"

If you start thinking about it, zero is pretty weird. Nonzero numbers are busy
telling you how many of something there is, while zero is telling you that a
thing doesn't exist. It has a different job. And it behaves differently than
all the other numbers when you use it in calculations. It is the singularity of
numbers. Still, it behaves enough like the other numbers to be useful and it
solves important problems like "what is the value of `a - a`"?

This brings us to the problem of `null`, which is definitely not zero. `null`
is "Nothing of any kind." `null` is the question that must never be asked. And
in some languages like C and C++, `null` means staring into the face of the
chaotic void that underlies reality&mdash;if you dereference a `null` pointer,
that reality dissolves into nothingness.

If my program asks, "How many chickens are there here?", it can count them. But
if there are no chickens, I don't get told there are zero chickens, I find out
instead that there is nothing of any kind, which is not what I asked.

This becomes especially problematic when designing generic containers. If we
create (in Kotlin) a `Yard` that can contain a chicken or a goat or an old car,
we must deal with the problem of an empty `Yard`. One way to sidestep this is
to force the user to provide an initial value in the constructor:

```kotlin
class Yard<T>(private var resident: T){
  fun add(item: T) { resident = item }
  fun get() = resident
}

class Chicken

fun main() {
  val chickenYard = Yard(Chicken())
}
```

But if I want to represent an empty `Yard`, I'm suddenly plunged into
`null`-world:

```kotlin
class Yard<T> {
  private var resident: T? = null
  fun add(item: T) { resident = item }
  fun get(): T? = resident
}

class Chicken {
  fun layEgg() {}
}

fun main() {
  val chickenYard = Yard<Chicken>()
  chickenYard.add(Chicken())
  val chicken: Chicken? = chickenYard.get()
  chicken?.layEgg()
}
```

If there is no chicken in the yard, I must not ask it to lay an egg or
everything collapses. Fortunately, Kotlin provides extra safety syntax for this
but I still have to dance around the issue.

When you add zero to a number system, that zero pervades throughout everything
you can do with that number system. So now instead of saying there are one,
two, or many chickens vs. nothing of any kind, we can say that there are zero
chickens, zero goats, or zero old cars. Zero has a type.

`null` has no type. You can't have `null` chickens, you just have `null`.
Computer science hasn't invented the equivalent of zero yet.

What would this "zero object" look like? If I create a `Yard<Chicken>` and
there is no `Chicken` in that `Yard`, instead of `null` I need a "zero
`Chicken`"&mdash;something with the *shape* of a `Chicken`, that I can perform
`Chicken` operations upon without asking (at least, in most cases) whether it
is a zero `Chicken` or not.

And just like zero in a number system allows you to say that there can be zero
of a thing, the concept of a zero object must pervade the entire system (it
must be built into the language). So if I ask a zero `Chicken` to `layEgg()`,
it will hand me a zero `Egg`. Every time you create a new type, its
zero-analogue must be created by the language.

Computer programming needs to invent its own zero to free us from the tyranny
of `null`.

(Roman Elizarov discusses some aspects of this issue
[here](https://medium.com/@elizarov/null-is-your-friend-not-a-mistake-b63ff1751dd5)
and [here](https://medium.com/@elizarov/dealing-with-absence-of-value-307b80534903)).

[Comment on Reddit](https://www.reddit.com/r/Kotlin/comments/i0rzam/computer_science_needs_the_equivalent_of_zero/)

*I am the author, with Svetlana Isakova, of [Atomic Kotlin](https://www.atomickotlin.com/)*
