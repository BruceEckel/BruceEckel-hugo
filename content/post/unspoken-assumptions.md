---
title: "Unspoken Assumptions Underlying OO Design Maxims"
date: '2019-12-24'
published: true
author: "Bruce Eckel"
---

For [Atomic Kotlin](https://www.atomickotlin.com/), I've been struggling with
an "atom" (very small chapter) during the last couple of months. It's on
object-oriented design, and it brought up a lot of feelings I've had for quite
awhile about some of the various maxims and design guidelines that have
appeared in recent decades, since OO became mainstream.

I couldn't quite put my finger on what bothered me about these design ideas.
Then @codingunicorn did it for me by writing a post called
[Flexible code considered harmful](https://dev.to/codingunicorn/flexible-code-is-considered-harmful-13nm).

Thank you, Julia, for your insights. It is so easy in this field to fall into
oversimplified thought patterns, and I feel dismayed when I see comments that
dismiss your ideas. What your post revealed to me is one of the reflexive
assumptions we make without questioning their validity.

I now see that one problem I have with many of the accumulated design ideas is
their unspoken assumption that:

> We somehow know how a system will change.

We don't, but we want to think we do. Thus, adding the extra complexity is
worth it. The very assumption that part of our job is *knowing* how a system
will change influences our attitude and approach to solving problems. It's
a lie, so it compromises our integrity and leads us down that slippery slope.
Imagine what it could be like if we didn't have to carry that lie, and could
be transparent about that and probably dozens of other things.

Julia's example was the "open-closed principle," which unfortunately she
didn't look up before quoting it---her version: "we should be able to extend
the behavior of a system without having to modify that system." It's actually
about *components* of a system: "Software entities (classes, modules,
functions, etc.) should be open for extension, but closed for modification."
OOP's built-in way to do this is polymorphyism: inherit a new class, put your
changes in that class, and the rest of the system can now use that class. Note
that we *DO* change the system in this case, but by isolating the changes to
the new class, the system change is minimized.

The underlying question remains the same: if you don't know for sure that
change will happen in a particular direction, why are you adding complexity to
your system by enabling that change?

This is complicated by modern languages, because approaches that produce
effortless ways to solve the problem at hand might coincidentally make the
code more flexible, whereas previous languages or versions of a language
required significant effort, and you would only do something a particular way
if you really wanted to allow flexibility in that direction.

I find it interesting that Kotlin---a language which has made a point of
studying features that do and don't work in other languages before
incorporating them---requires you to explicitly use the `open` keyword on a
base class before allowing you to inherit from it. So in Kotlin, all classes
are closed for extension by default.

A second example is the idea that we should "Program to an interface, not an
implementation" which came from the book *Design Patterns* in 1994. What they
*meant* was basically, "Assume as little as possible about how the underlying
implementation," and this is excellent general advice. It's basically a comment
about coupling.

However, when the `interface` keyword was added to Java, some programmers
decided that it meant, "use the `interface` keyword everywhere." This produced
designs with lots of interfaces scattered about, and I found myself asking "I
wonder what the designer meant by this abstraction" and in most cases it meant
nothing. The ambient `interface` noise level made it even harder to discover
the legitimate use of interfaces when it happened.

This made me think of a second unspoken assumption:

> Abstractions are always worth their cost

There are times when an abstraction helps make something clearer, at which point
I feel good about using it. Yes, it might also enable future change, but I don't
need to justify that if the design is clearer.

So I propose an over-arching principle, which is:

> Question your abstractions. If you can't justify it (without quoting a maxim), take it out.

