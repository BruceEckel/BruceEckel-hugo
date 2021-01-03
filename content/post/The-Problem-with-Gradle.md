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
tool I called `makebuilder` which analyzed the examples extracted from the book
and generated an appropriate makefile. `make` is a dedicated tool that only
cares about dependencies and actions, so it is reasonably approachable.

When I wrote *Thinking in Java*, I created a similar tool I called `antbuilder`,
which generated an appropriate Ant build file. Although Ant was created during
the collective insanity of XML being the future of everything, `ant` is
nonetheless a dedicated build tool so it is, like `make`, reasonably
approachable.

I brought with me this background in build tools when I began looking at Gradle,
and I had certain expectations, primarily that the tool would have a
straightforward configuration and setup process, and that things would look
passably familiar. This idea was supported by what I'd read about Gradle,
promising that most configurations would be simple and that you'd normally never
need to dip below the surface of that configuration.

Instead, Gradle was very mysterious for me. It seemed to have innumerable cliffs
and I kept discovering these and falling off. Most importantly, I did not have
any kind of mental model that would guide me in making decisions and solving
problems.

When I began writing [On Java 8](https://www.onjava8.com/), my friend James Ward
declared that I couldn't use Ant and had to use Gradle, and that he would help
me. He ended up basically creating the various Gradle build files for the book,
and I could read and even modify some parts, but the big picture remained
baffling, even after reading a couple of books on Gradle.

After that, I started work on [Atomic Kotlin](https://www.atomickotlin.com/),
for which we also used Gradle, but my coauthor Svetlana created and managed the
Gradle files. Partway through writing the book, Gradle was changed so that it
could also use Kotlin, but I still didn't understand enough about Gradle with
Groovy, so I didn't want to risk breaking our system by trying to change to
Kotlin.

More recently I saw a YouTube video about Gradle where they just did things but
never really explained. You know the kind of people who have memorized the
entire Unix command-line suite and use it effortlessly without every looking
anything up? That seemed to be what I was watching, and it wasn't reassuring.

I was stuck in this place for years, depending on others to help figure it out
and not understanding it when they did. This was very frustrating and I avoided
dealing with Gradle when I could. But underneath, it was bugging me to be so
stumped by a piece of software technology.

The Chinese publisher of *On Java 8* recently asked me to add a final chapter on
Java 11. As I began digging into that, I realized I would need to extract the
examples into a separate repository with its own Gradle build which required
Java 11. I really didn't want to ask for help this time (mostly because the
helpers nearest to hand have expressed significant distaste for working with
Gradle). So I decided to commit and take the time to figure it out and
understand it, at least far enough for me to handle the Java 11 chapter.

And ideally without throwing things (by which I mean not exceptions but physical
objects, out of frustration).

I started doing large quantities of internet searches and becoming more engaged
with the Gradle docs. The process required multiple dedicated days, and a lot of
self-reasurrance that it was OK to just take my time and keep poking at it.

With patience and perserverance, Gradle slowly began to give up its mysteries.
At the same time, I started understanding why it had been so baffling to me and
why treating Gradle as an exercise in configuration just doesn't work. You can't
go at it with a quick-and-dirty attitude, and that's what had stymied me. This
is the problem I had with Gradle:

> ***To do anything you have to know everything***

Yes, it's hypothetically possible to create a simple `build.gradle` for a basic
build. But usually by the time you get to the point of *needing* a Gradle build,
your problem is complicated enough that you must do more. And it turns out that
"doing more" translates to "knowing everything." Once you get past the simple
things you fall off a cliff.

Think of the grappling shoes in the very first episode of *Rick and Morty*. Rick
explains that the shoes allow you to walk on vertical surfaces, so Morty puts
them on and promptly falls down a cliff, after which Rick explains that "you
have to turn them on." Gradle is my grappling shoes.

My goal here is to give you perspective, so as you fall down the cliff face you
will understand what is happening, and what is necessary to climb back up.

## Basics

Virtually every build system has two essential ingredients:

1. **Tasks:** These comprise the menu of actions for your build. A build usually
   has multiple tasks and you typically invoke the desired task from the
   command-line, as in `gradle build`. Other build systems have different names
   for tasks; for example, `make` calls them *targets*.

2. **Dependencies:** A dependency says "this can't happen before that happens."
   Typically, this means "I can't compile/run this component before that
   component is available/updated," but a dependency can refer to any kind of
   ordering that says "do this first, then do that."

   Dependencies can be thought of as "internal" (relying on other components
   within the build) or "external" (updating components from external
   repositories, local or remote).

The build tool reads a script which is usually in a file with a standardized
name such as `build.gradle` or `Makefile`. Based on the instructions in the
script, the build tool performs the operations necessary to update the project.

Historically, build tools like `make` are configuration-focused, and relegate
actions to external programs. For example, a simple `Makefile` looks like this:

```lang-makefile
vip: vip.o
    cc vip.o -o vip

vip.o: vip.c
    cc -c vip.c -o vip.o
```

The non-indented lines establish the dependences: `vip` depends on `vip.o` and
`vip.o` depends on `vip.c`. If you modify `vip.c`, `make` will see that `vip.c`
is now newer than `vip.o`, so `vip.o` is out of date and `make` runs the command
`cc -c vip.c -o vip.o` to bring `vip.o` up to date. Now `vip` is older than
`vip.o` so `make` runs the command `cc vip.o -o vip`.

Commands are indented (horribly, by tabs, because `make` was created in the
early days of Unix when they were still obsessed with saving bytes), and those
commands are not part of `make` but simply shell command-line programs (in this
case, the C compiler `cc`). `make` doesn't know anything except that, according
to the `Makefile`, executing the commands will bring the target up to date.

The simplicity of `make` is elegant, and it is still in active use today. An
important limitation to `make` emerged over time, as people began relying on it
for larger and more complex programs. It became challenging to always rely on
outside programs as commands, so some versions of `make` began adding more and
more internal structure to meet these needs. For those of you that have followed
`make` to its edges, you might have had the same "aha!" moment that I did: "THIS
is the spot where the creators of `make` realized they were building a
programming language, and they stopped."

Creators of modern build systems understand that some level of programming
support is necessary in a build tool, and that it usually makes more sense to
utilize an existing language than to get lost creating a new one (that, after
all, is how we ended up with Java. They were supposed to be making a dedicated
device for televisions). The questions are:

1. *Which language*? It seems like the best choice is one the user is already
   familiar with, to lower the cognitive barrier against learning your build
   system.

2. *How intrusive*? How much will this language dominate the experience of using
   your build system? How expert does the user need to be in the language to use
   the build tool?

3. *How influencing*? My ideal would be to have a minimal number of additions to
   the existing language so that it would look like the existing language but
   with a few syntax additions to configure target rules for the build system.
   As you'll see, the design of Gradle was significantly influenced by the
   Groovy language it is implemented in.

We are still in the early days of the "adding a build system atop an existing
language" paradigm. Gradle is an experiment in this paradigm. Thus, we can
expect that it doesn't get things "right." However, by understanding its issues
you might have less frustration learning Gradle than I did.

## 1. You're not Configuring, You're Programming

Although Gradle attempts to look like it's just declaring configurations, each
of these configurations is actually a function call. Basically, everything
except for some of the language directives is either creating objects or calling
functions. I found it quite helpful to realize that, because then I could look
at many of the configuration declarations and realize they were actually calling
functions, and that made it easier for me to understand.

## 2. Groovy is Not Java

Groovy is a significant improvement over Java, and several features in Groovy
influenced the language design for Kotlin. The more I learn about Groovy the
more I realize I never gave it fair consideration.

Groovy syntax is reminiscent of Java, but it's a different language and you need
to learn a new set of rules and tricks. The fact that Groovy has access to
existing Java libraries is primarily a benefit to the Gradle developers.

You'll need to grasp a significant portion of the Groovy language in order to
create useful Gradle build files. I found it nearly impossible to understand
what was happening before I took a deep enough dive into Groovy.

## 3. Gradle Uses a *Domain-Specific Language*

A *Domain-Specific Language* (DSL) is specialized to a particular application
domain. The goal of a so-called *internal* DSL (one that is built within an
existing language) is to narrow the focus to the problem at hand (e.g.
configuring a software build) so that, ideally, the user only needs to
understand the DSL in order to do the job.

For example, to tell Gradle where to find the source files, you can say:

```groovy
sourceSets {
    main {
        java {
            srcDirs 'java11'
        }
    }
}
```

This is intended to create a *declarative* way to describe your builds, and it
relies on the syntax for Groovy's lambdas (which they unfortunately call
*closures*). If the last argument in a function call is a lambda, it can be
placed after the argument list. Here, `sourceSets`, `main` and `java` are all
functions that take a single lambda parameter, so no parenthesized list is
necessary, just the lambda. Thus, `sourceSets`, `main` and `java` are all
function calls, but the resulting syntax makes it look like ... something else.

How helpful is this DSL syntax, really? I have to translate it into function
calls in my head when I read it. So for me it's additional cognitive overhead
which is ultimately a hindrance. The DSL operations can all be done with
function calls, which programmers already understand. Some people prefer to
express their build files with function calls and ignore the DSL syntax.

And as I previously observed, you must know far more than the DSL syntax in
order to do anything but the most basic of builds, so the DSL completely fails
its raison d'etre. Unfortunately the DSL not only part of the mix but generally
the way that Gradle is introduced to newcomers. It's basically just a noisier,
and often more confusing, way to make function calls. Which brings me to:

## 4. There are Many Ways to do the Same Thing

Groovy allows you to express things in numerous different ways and the Gradle
documentation seems to revel in this variety. When you're just trying to get
through it, adding the variations right away just makes it harder. Worse, people
tend to casually use the different approaches, so you must recognize and unravel
the competing syntaxes.

For example, the previous `sourceSets` could also be configured using
function-call syntax by adding parentheses:

```groovy
sourceSets {
    main {
        java {
            srcDirs('java11')
        }
    }
}
```

Or you could choose to skip the DSL syntax and write it more compactly:

```groovy
sourceSets.main.java.srcDirs = ['java11']
```

Which is equivalent to:

```groovy
sourceSets.main.java.srcDirs('java11')
```

You're free to choose from among the different approaches, and people do, so
when you're reading various code examples you must understand all the
variations. This compounds the complexity of learning Gradle. Being able to do
things a bunch of different ways is not a feature.

{{INCOMPLETE SECTION}}

JavaExec pattern. Was I supposed to inherit from JavaExec. No.

A lot of magic and things that require extra knowledge. For example, different
ways to create a task, and then the `tasks`

## 5. The Framework and Lifecycle

Groovy silently imports and creates many things. This is not a problem in
itself, but you must somehow know these things are available. For example, the
`tasks` list is pre-created and globally available. There's also a `project`
object and probably numerous others that I haven't discovered yet.

`ext`, but it inherits. File-scope vs project scope. Variables that work in
tasks but not in functions.

(two ways to define functions?)

## Other issues

- The Gradle documentation assumes you already know a lot. It is not a tutorial
  as much as a core dump. I now understand why, because to do anything you have
  to understand everything. But this assumption makes it challenging for the
  newcomer.

- Slow startup times. Over the years they've worked to speed it up but if you
  run Gradle a lot, you will notice it and it can become annoying. In contrast,
  `make` is extremely fast. Even all the build tools I've created in Python are
  quick by comparison.

- It's not that easy to discover Gradle's abilities, and there are so many
  things that you often don't know what's possible or what might already exist
  to solve your problem. It can be easy to flounder for quite awhile before
  discovering there's already a solution.

## Now That I Get It

I can finally start to understand my existing scripts, which is one of the
things that kept me from considering the switch to Kotlin for `build.gradle`
scripts. But now that I have the big picture it's clear that I can do it and
that I want to. In particular, IntelliJ IDEA support for Groovy can't always
infer types, which is necessary so the IDE can look up the possible properties
and methods for an object. This alone would make it worth moving to Kotlin.

If you've been struggling to create a mental model for Gradle, I hope this post
has provided some insights.
