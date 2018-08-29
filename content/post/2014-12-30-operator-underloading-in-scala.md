---
date: '2014-12-30'
published: true
title: Operator Underloading In Scala
url: /2014/12/30/operator-underloading-in-scala
---


Here's a place where Scala does some clever stuff which ultimately might produce a more complicated programming model than one would like. I discovered it while sorting out some issues with the first exercise in the *References & Mutability* atom in [Atomic Scala](http://www.atomicscala.com/).

I'll give you the examples directly out of the solution guide --- this includes the use of our tiny **AtomicScala** test framework, but if you don't want to include that you can just comment out the **import** and all the **is** statements and you'll still get the same results.

The default **Map** class is immutable. So if we try to change an existing element or add a new key-value pair, it won't let us, as expected:

```Scala
// Solution-1a.scala
// Solution to Exercise 1 in "References & Mutability"
import com.atomicscala.AtomicTest._

var m = Map("Foo" -> "Bar")

m("Goat") = "Calico" // Try to add a new pair

/* OUTPUT_SHOULD_CONTAIN
error: value update is not a member of scala.collection.immutable.Map[String,String]
m("Goat") = "Calico" // Try to add a new pair
^
one error found
*/
```

(The same error is produced when trying to change an existing element).

But now there is a surprise. The **+=** and **-=** operators, at first blush, appear to allow modification of **m**:

```Scala
// Solution-1c.scala
// Solution to Exercise 1 in "References & Mutability"
import com.atomicscala.AtomicTest._

var m = Map("Foo" -> "Bar")
val original = m
m is "Map(Foo -> Bar)"

// Surprise! The following appears to be modifying an existing
// immutable map! What's happening here?
m += ("Frog" -> "Green")
m += ("Cow" -> "Brown")
m is "Map(Foo -> Bar, Frog -> Green, Cow -> Brown)"
m -= "Cow"
m is "Map(Foo -> Bar, Frog -> Green)"

/* The '+' and '-' parts of '+=' and '-=' cause a new Map to be
created, and the '=' part assigns that new map to m, which works
because m is a var. Try changing it to a val and see what happens.
But the original Map object is not modified, as you can see here: */
original is "Map(Foo -> Bar)"

/* OUTPUT_SHOULD_BE
Map(Foo -> Bar)
Map(Foo -> Bar, Frog -> Green, Cow -> Brown)
Map(Foo -> Bar, Frog -> Green)
Map(Foo -> Bar)
*/

```

Once we realize what's happening, it does kind of make sense. And **Map**'s immutability is not violated, while still allowing what we want to accomplish with the **+=** and **-=**.

When you start thinking this way, that the reason this works is because **m** is a **var**, it then makes sense to think that if you change **m** to a **val**, the above code should stop working. But we're in for another surprise:

```Scala
// Solution-1d.scala
// Solution to Exercise 1 in "References & Mutability"
import com.atomicscala.AtomicTest._
import collection.mutable.Map

val m = Map("Foo" -> "Bar")
val original = m
m is "Map(Foo -> Bar)"
m("Foo") = "Zup"
m is "Map(Foo -> Zup)"
m("Goat") = "Calico" // Adds a new pair
m is "Map(Goat -> Calico, Foo -> Zup)"

// From our logic in Solution-1c.scala, this SHOULDN'T work. But it
// does! NOW what's going on?
m += ("Frog" -> "Green")
m += ("Cow" -> "Brown")
m is "Map(Goat -> Calico, Foo -> Zup, Frog -> Green, Cow -> Brown)"
m -= "Cow"
m is "Map(Goat -> Calico, Foo -> Zup, Frog -> Green)"

/* In Solution-1c.scala, the += wasn't overloaded for the immutable
Map, so Scala synthesized it by first applying '+' and then '='.
But there IS a += defined for the mutable Map, so that is called in
this case. */

// Note that here, the original IS being directly modified:
original is "Map(Goat -> Calico, Foo -> Zup, Frog -> Green)"

/* OUTPUT_SHOULD_BE
Map(Foo -> Bar)
Map(Foo -> Zup)
Map(Goat -> Calico, Foo -> Zup)
Map(Goat -> Calico, Foo -> Zup, Frog -> Green, Cow -> Brown)
Map(Goat -> Calico, Foo -> Zup, Frog -> Green)
Map(Goat -> Calico, Foo -> Zup, Frog -> Green)
*/

```

It works. It's clever and probably useful. But I worry about having to think this hard about something so apparently simple. It could be that I'm just not used to thinking "The Scala Way" yet. But it could also be that there are just a lot of special cases.

For example, now that we are thinking this way --- that if something is immutable, you just create a **val** reference and Scala will synthesize **+=** and **-=** --- we encounter **Vector**, and suddenly what we thought was consistent is not. Because **Vector** (which doesn't have a mutable counterpart) *does not* synthesize **+=** and **-=**. Instead, you must apparently explicitly perform the assignment part of those operations:

```Scala
// Solution-4.scala
// Solution to Exercise 4 in "References & Mutability"
import com.atomicscala.AtomicTest._

var shapes = Vector("Round", "Rectangular", "Oblong")
shapes = shapes :+ "Pointy" // Append at end
shapes = "Ovoid" +: shapes // Insert at beginning
shapes is "Vector(Ovoid, Round, Rectangular, Oblong, Pointy)"
shapes ++ "Sticky" is
  "Vector(Ovoid, Round, Rectangular, Oblong, Pointy, S, t, i, c, k, y)"
shapes ++ Vector("Sticky") is
  "Vector(Ovoid, Round, Rectangular, Oblong, Pointy, Sticky)"
// Works the other way around, as well:
Vector("Sticky") ++ shapes is
  "Vector(Sticky, Ovoid, Round, Rectangular, Oblong, Pointy)"

// Wait, there ARE assignment-combination operators. Pretend the ':'
// represents the collection (two dots represent two elements?) and
// the '+' then shows which side you're attaching the new element
// onto:
shapes +:= "Fat"
shapes :+= "Skinny"
shapes is "Vector(Fat, Ovoid, Round, Rectangular, Oblong, Pointy, Skinny)"

/* OUTPUT_SHOULD_BE
Vector(Ovoid, Round, Rectangular, Oblong, Pointy)
Vector(Ovoid, Round, Rectangular, Oblong, Pointy, S, t, i, c, k, y)
Vector(Ovoid, Round, Rectangular, Oblong, Pointy, Sticky)
Vector(Sticky, Ovoid, Round, Rectangular, Oblong, Pointy)
Vector(Fat, Ovoid, Round, Rectangular, Oblong, Pointy, Skinny)
*/

```
But wait, there IS an assignment-combination operator. It's just not shown in the docs for **Vector** or its base-class **AbstractSeq**. So it's one of the synthesized ones, apparently, and I'm supposed to remember that (1) assignment-combination operators get synthesized (2) they can be different for each class and (3) they don't show up in the docs.

It wouldn't be so bad if there was an alternative named method for **+:=**, **:+=** etc., which you could use instead (and would show up in the docs). But that this is the ONLY way to do it and it doesn't appear in the docs and nobody seems to think it's a problem --- that's a big problem.

There are numerous other examples of these issues (like **List** and **MutableList**) but I'll stop. From the standpoint of the programmer, I'm confused. I don't have a consistent way to think about collections. Which means I'm going to have to look things up fairly often. Except when they aren't there, when I'll have to remember them. In the different ways that they might happen.

Once, I could run circles around C++ operator overloading, which is complicated because you have to worry about storage allocation and release (garbage collectors eliminate those problems). I don't remember that like I once did because C++ must be backwards compatible with C, and that introduced arbitrary complications which are essential to the language implementation rather than being essential to what you're trying to accomplish with the language. That's what makes the details hard to remember. And I find that if I can't hold important issues in my head, it slows me down. So that's what concerns me.

I've learned a great deal from studying Scala, and am very thankful for that. Scala is clearly able to solve some very interesting and complex problems quite well, and because it's built on the JVM ecosystem, less complex languages can use and benefit from those solutions. But I'm seriously beginning to wonder whether Scala can reach beyond anyone but the niche elite --- despite the fact that I've worked hard so that [Atomic Scala](http://www.atomicscala.com/) presents the language as simple for the first-time user (sometimes I feel like I'm creating a dishonest view of the language, but I feel like if I don't, then even fewer people will get past the initial hurdles).

In many ways, Scala is a grand, ambitious experiment; a very valuable one at that. (Studying Scala has been very useful for me, and has significantly expanded my horizons). A big part of that experiment, though, could be to answer the question, "Is it possible to achieve perfect typing?" As [this article shows](http://yz.mit.edu/wp/true-scala-complexity/) (especially see the *On Acknowledging Problems* section at the end of the article, and the [Ycombinator discussion](https://news.ycombinator.com/item?id=3443436)), the answer might be a descent into an infinitely recursive rabbit hole.

