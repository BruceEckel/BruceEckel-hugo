---
date: '2021-01-02'
published: false
title: The Problem with Gradle
url: /2021/01/02/The-Problem-with-Gradle
author: "Bruce Eckel"
---

> Or: *How to remain sane when approaching Gradle*
> (With apologies to Hans Dockter).

I started using `make` in the 80's. When I wrote *Thinking in C++*, I created a
tool I called `makebuilder`, in C++, which would analyze the examples extracted
from the book and create an appropriate makefile. `make` is a dedicated tool
that only cares about dependencies and actions, so it is reasonably
approachable.

When I wrote *Thinking in Java*, I created a similar tool I called `antbuilder`,
which produced an appropriate Ant build file. Although it was created when for
some reason everyone seemed to think XML was the future of everything, `ant` is
nonetheless a dedicated build tool so it is, like `make`, reasonably
approachable.

So I'd had a fair background with build tools when I began looking at Gradle,
and I had certain expectations, primarily that the tool would have a fairly
straightforward configuration and setup process, and that things would look
passably familiar.

This idea was support by what I'd read about Gradle, promising that most
configurations would be simple and that you'd commonly never need to dip below
the surface of that configuration.

Stuck for years, depending on others to help figure it out. Very frustrated,
avoided dealing with it and crossed my fingers. I think I even felt some shame
around it, especially when I kept hearing how great Gradle is, how easy, etc.

Watched Youtube video where they just did things but never really explained. You
know the kind of people who have memorized the entire unix command-line suite? I
realized that's what I was seeing.

> To do anything you have to know everything

internal and external dependencies

## 1. You're Programming in a Different Language



A new language which has a lot of similarities with Java but also a lot of new
things to understand.

## 2. Groovy Uses a *Domain-Specific Language*

How helpful is DSL syntax, really? I have to translate it into function calls in
my head when I read it. So for me it's more cognitive overhead and I'm not sure
if it's ultimately not a hindrance.

## 3. The Framework and Lifecycle

Groovy silently imports a ton of things which you have to know about in order to
use

## 3. There are Many Ways to do the Same Thing

Groovy allows you to express things in numerous different ways and the Gradle
documentation immediately seems to revel in all the different ways that you can
express the same thing. This compounds the complexity of learning cradle. Being
able to do things a bunch of different ways is not a feature.

## 4. The Documentation Assumes You

The Gradle documentation is not a tutorial as much as a core dump. I now
understand why, because to do anything you have to understand everything. But
learning cradle becomes overwhelming and people saying that it's simple
certainly doesn't help

# Now That I Get It

I can finally start to understand my existing scripts, which is what kept me
from, for example, considering switching to Kotlin for Gradle. But now that I
have the big picture, and can not only start to imagine how to do it, but
understand why I want to -- IntelliJ IDEA support for Groovy often cannot do
completion because it can't always infer types. Completion alone would make it
worth trying Kotlin.
