---
date: '2021-01-02'
published: false
title: The Problem with Gradle
url: /2021/01/02/The-Problem-with-Gradle
author: "Bruce Eckel"
---

> Or: *How to Remain Sane when Approaching Gradle* (with apologies to Hans
> Dockter).

I started using `make` in the 80's. When I wrote *Thinking in C++*, I created a
tool I called `makebuilder`, in C++, which would analyze the examples extracted
from the book and create an appropriate makefile. `make` is a dedicated tool
that only cares about dependencies and actions, so it is reasonably
approachable.

When I wrote *Thinking in Java*, I created a similar tool I called `antbuilder`,
which produced an appropriate Ant build file. Although Ant was created during
the collective insanity of XML being the future of everything, `ant` is
nonetheless a dedicated build tool so it is, like `make`, reasonably
approachable.

So I'd had a fair background with build tools when I began looking at Gradle,
and I had certain expectations, primarily that the tool would have a fairly
straightforward configuration and setup process, and that things would look
passably familiar. This idea was support by what I'd read about Gradle,
promising that most configurations would be simple and that you'd commonly never
need to dip below the surface of that configuration.

Instead, Gradle was very mysterious for me. It seemed to have innumerable cliffs
and I kept discovering these and falling off. Most importantly, I did not have
any kind of mental model that would guide me in making decisions and solving
problems.

When I began working on [On Java 8](https://www.onjava8.com/), my friend James
Ward declared that I couldn't use Ant and had to use Gradle, and that he would
help me. He ended up basically creating the various Gradle build files for the
book, and I could read and even modify some parts, but the big picture remained
baffling, even after reading a couple of books on Gradle.

After that, I started work on [Atomic Kotlin](https://www.atomickotlin.com/),
for which we also used Gradle, but my coauthor Svetlana created and managed the
Gradle files. Partway through the writing the book, Gradle was changed so that
it could also use Kotlin, but I still didn't understand enough about Gradle with
Groovy, so I didn't want to risk breaking our system by trying to change to
Kotlin.

I was stuck in this place for years, depending on others to help figure it out
and not understanding it when they did. This was very frustrating and I
generally avoided dealing with Gradle and crossed my fingers when I did. But
underneath, it was bugging me to be so stumped by a piece of software
technology.

More recently I saw a YouTube video about Gradle where they just did things but
never really explained. You know the kind of people who have memorized the
entire unix command-line suite and use it effortlessly without every looking
anything up? That seemed to be what I was watching, and it wasn't reassuring.

Finally the Chinese publisher of *On Java 8* asked me to add a final chapter on
Java 11. As I began digging into that, I realized I would need to extract the
examples into a separate repository with its own Gradle build. I really didn't
want to ask for help this time (mostly because the helpers nearest to hand have
expressed significant distaste for working with Gradle). So I decided to commit
and take the time to figure it out and understand it, at least far enough for me
to handle the Java 11 chapter.

Ideally without throwing things.

It required multiple days, and a lot of self-reasurrance that it was OK to just
take my time and keep poking at it. I started becoming more engaged with the
Gradle docs, and of course doing large quantities of internet searches.

With patience and perserverance, Gradle slowly began to give up its mysteries.
At the same time, I began to understand why it had been so baffling to me and
why treating Gradle as an exercise in configuration just doesn't work. You can't
go at it with a quick-and-dirty attitude, and that's what had stymied me. This
is the problem I had with Gradle:

> ***To do anything you have to know everything***

Yes, it's hypothetically possible to create a simple `build.gradle` for a simple
build. But usually by the time you get to the point of *needing* a Gradle build,
your problem is complicated enough that you must do more. And it turns out that
"doing more" translates to "knowing everything." Basically, once you get past the
simple builds you fall off a cliff.

Think of the grappling shoes in Season 1, Episode 1 of *Rick and Morty*. Rick
explains how they allow you to walk on vertical surfaces, so Morty puts them on
and promptly falls down a cliff, after which Rick explains that "you have to
turn them on." Gradle is my grappling shoes.

My goal here is to give you perspective, so as you fall down the cliff face you
will understand what is happening, and what is necessary to climb back up the
cliff.

tasks and dependencies
internal and external dependencies

## 1. You're not Configuring, You're Programming

## 2. Groovy is Not Java



A new language which has a lot of similarities with Java but also a lot of new
things to understand.

## 3. Groovy Uses a *Domain-Specific Language*

How helpful is DSL syntax, really? I have to translate it into function calls in
my head when I read it. So for me it's more cognitive overhead and I'm not sure
if it's ultimately not a hindrance.

## 4. The Framework and Lifecycle

Groovy silently imports a ton of things which you have to know about in order to
use

## 5. There are Many Ways to do the Same Thing

Groovy allows you to express things in numerous different ways and the Gradle
documentation immediately seems to revel in all the different ways that you can
express the same thing. This compounds the complexity of learning cradle. Being
able to do things a bunch of different ways is not a feature.

## 6. The Documentation Assumes You

The Gradle documentation is not a tutorial as much as a core dump. I now
understand why, because to do anything you have to understand everything. But
learning cradle becomes overwhelming and people saying that it's simple
certainly doesn't help

## Now That I Get It

I can finally start to understand my existing scripts, which is what kept me
from, for example, considering switching to Kotlin for Gradle. But now that I
have the big picture, and can not only start to imagine how to do it, but
understand why I want to -- IntelliJ IDEA support for Groovy often cannot do
completion because it can't always infer types. Completion alone would make it
worth trying Kotlin.
