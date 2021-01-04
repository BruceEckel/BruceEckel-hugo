---
date: '2021-01-02'
published: true
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

This was my background when I began looking at Gradle, and I had certain
expectations, primarily that the tool would have a straightforward configuration
and setup process, and that things would look passably familiar. This idea was
supported by what I'd read about Gradle, promising that most configurations
would be simple and that you'd normally never need to dip below the surface of
that configuration.

Instead, Gradle was very mysterious for me. It seemed to have innumerable cliffs
and I kept discovering these and falling off. Most importantly, I did not have
any kind of mental model that would guide me in making decisions and solving
problems.

When I began writing [On Java 8](https://www.onjava8.com/), my friend James Ward
declared that I couldn't use Ant and had to use Gradle, and that he would help.
He ended up creating the various Gradle build files for the book, and I could
read and even modify some parts, but the big picture remained baffling, even
after reading a couple of books on Gradle.

After that, I started work on [Atomic Kotlin](https://www.atomickotlin.com/),
for which we also used Gradle, but my coauthor Svetlana created and managed the
Gradle files. Partway through writing the book, Gradle was changed so it also
uses Kotlin, but I still didn't understand enough about Gradle with Groovy, so I
didn't want to risk breaking our system by trying to change to Kotlin.

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

Through internet searches I became more engaged with the Gradle docs. The
process required multiple dedicated days (on top of the attempts I had made in
the past), along with a lot of self-reasurance that it was OK to just take my
time and keep poking at it.

With patience and perserverance, Gradle slowly began giving up its mysteries. At
the same time, I started understanding why it had been so baffling to me and why
treating Gradle as an exercise in configuration just doesn't work. You can't go
at it with a quick-and-dirty attitude, and that's what had stymied me. This is
the problem I had with Gradle:

> ***To do anything you have to know everything***

Yes, it's hypothetically possible to create a simple `build.gradle` file for a
basic build. But usually by the time you get to the point of *needing* a Gradle
build, your problem is complicated enough that you must do more. And it turns
out that "doing more" translates to "knowing everything." Once you get past the
simple things you fall off a cliff.

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
more internal capabilities to meet these needs. For those of you that have
followed `make` to its edges, you might have had the same "aha!" moment that I
did: "THIS is the spot where the creators of `make` realized they were building
a programming language, and they stopped."

Creators of modern build systems understand that some level of programming
support is necessary in a build tool, and that it usually makes more sense to
utilize an existing language than to get lost creating a new one (that, after
all, is how we ended up with Java. They were supposed to be making a dedicated
device for televisions). The questions are:

1. *Which language*? The best choice seems like one the user is already familiar
   with, to lower the cognitive barrier against learning your build system.

2. *How intrusive*? How much does this language dominate the experience of using
   your build system? How much language expertise is required to use the build
   tool?

3. *How influencing*? My ideal would be a build system that looks like the
   existing language with a few minimal syntax additions to configure target
   rules. As you'll see, the design of Gradle was significantly influenced by
   its use of the Groovy language.

We are still in the early days of the "adding a build system atop an existing
language" paradigm. Gradle is an experiment in this paradigm, so we expect some
sub-optimal choices. However, by understanding its issues you might have less
frustration learning Gradle than I did.

## 1. You're not Configuring, You're Programming

Although Gradle attempts to look like it's just declaring configurations, each
of these configurations is actually a function call. Basically, everything
except for some of the language directives is either creating objects or calling
functions. I found it quite helpful to realize that, because now I look at the
configuration declarations and see they are actually calling functions, and this
makes it easier for me to understand.

## 2. Groovy is Not Java

You'll need to grasp a significant portion of the Groovy language in order to
create useful Gradle build files. I found it nearly impossible to understand
what was happening before I took a deep enough dive into Groovy.

Groovy is a significant improvement over Java, and several features in Groovy
influenced the language design for Kotlin. The more I learn about Groovy the
more I realize I never gave it fair consideration.

Groovy syntax is reminiscent of Java, but it's a different language and you need
to learn a new set of rules and tricks. The fact that Groovy has access to
existing Java libraries is primarily a benefit to the Gradle developers.

*Aside:* Understanding Kotlin allowed me to understand Groovy.

## 3. Gradle Uses a *Domain-Specific Language*

A *Domain-Specific Language* (DSL) is specialized to a particular application
domain. The goal of a so-called *internal* DSL (one that is built within an
existing language) is to narrow the focus to the problem at hand (e.g.
configuring a software build) so that, ideally, the user only needs to
understand the DSL in order to do the job.

For example, to tell Gradle where to find your Java source files, you can say:

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
function calls, and programmers already understand function calls.

Some people prefer to express their build files with function calls and ignore
the DSL syntax.

As I previously observed, you must know far more than the DSL syntax in order to
do anything but the most basic of builds, so the DSL completely fails its raison
d'etre. Unfortunately the DSL is not only part of the mix but generally the way
that Gradle is introduced to newcomers. It's basically just a noisier, and often
more confusing, way to make function calls. Which brings me to:

## 4. There are Many Ways to do the Same Thing

Groovy allows you to express things in numerous different ways and the Gradle
documentation seems to revel in this variety. When you're just trying to get
through it, adding the variations right away only makes it harder. Worse, people
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
when you're reading code examples you must understand all the variations. This
compounds the complexity of learning Gradle.

To quote the [Zen of Python](https://www.python.org/dev/peps/pep-0020/):

> *There should be one--and preferably only one--obvious way to do it.*

Being able to do something in many different ways is not a benefit.

## 5. Magic

Until you fully understand what's going on, there seem to be many magical things
that require special arcane knowledge.

Consider creating a `task`. You typically do this with a static declaration in
your `build.gradle`:

```groovy
task hello {
    doLast {
        println 'Hello world!'
    }
}
```

`doLast` lambdas are executed as the task is completing.

Now when you say `gradle hello` on the command line, the `hello` task will run.

It turns out you can also create tasks dynamically, inside functions. To do this
you must know about the `tasks` object, which is *just there*, automatically and
invisibly, inside every gradle build. If, in an empty `build.gradle` file, you
put:

```groovy
tasks.forEach { println it }
```

It will print all the tasks in the `tasks` list. And without creating any tasks
yourself, you will see:

```text
task ':buildEnvironment'
task ':components'
task ':dependencies'
task ':dependencyInsight'
task ':dependentComponents'
task ':help'
task ':init'
task ':model'
task ':outgoingVariants'
task ':prepareKotlinBuildScriptModel'
task ':projects'
task ':properties'
task ':tasks'
task ':wrapper'
```

The `tasks` object is where we find the `create()` method for dynamic test
creation. We pass the name of the task we wish to create as you see in `hello2`:

```groovy
task hello1 {
    doLast {
        println 'Hello 1!'
    }
}

tasks.create("hello2") {
    dependsOn hello1
    doLast {
        println 'Hello 2!'
    }
}

task("hello3") {
    dependsOn hello2
    doLast {
        println 'Hello 3!'
    }
}

task all {
    doLast {
        tasks.matching {
            it.name.startsWith("hello")
        }.forEach {
            println it.name
        }
    }
}
```

`hello3` shows yet another way to create a `task`, by simply calling the
`task()` function. Note that each of the `hello` tasks explicitly depends on the
previous one, so if you run `gradle hello3` you'll see `hello2` and `hello1`
executed as well.

`all` searches through the `tasks` list (which, as we saw before, includes many
other tasks), finds the tasks whose names start with `hello`, and displays them.

Normally if you want to set a project-level value for use by multiple pieces of
code, you use `ext`, another object that is *just there*. It not only holds
project-level values, it can collect values from other files and decide how to
overwrite them if there are collisions.

Sometimes you want a value defined and used at file scope. To define a value
with Groovy type inference, use `def`:

```groovy
def config = "Configuration"

task x {
    println config
}

String useConfig() {
    return config  // Fails: can't see 'config'
}
```

Functions are defined using `def` if they don't return anything, otherwise you
give the return type. Here, `useConfig()` returns a `String`.

While `config` is visible within `task x`, it is not visible inside the function
`useConfig()`. I'm not sure why this is, but to work around it you create a class
containing `static` properties, which will work in both tasks and functions:

```groovy
class Vals {
    static def config = "Configuration"
}

task x1 {
    doLast {
        println "x1: ${Vals.config}"
    }
}

String useConfig() {
    return Vals.config  // Succeeds
}

task x2 {
    doLast {
        println "x2: ${useConfig()}"
    }
}

task all {
    dependsOn tasks.matching { it.name.startsWith("x") }
}
```

Notice that `all` depends on all tasks with names beginning with `x`, so running
`all` will execute both `x1` and `x2`.

This has only scratched the surface of what's there but undiscovered.

## 5. The Lifecycle

It's easy to make mistakes if you don't understand the lifecycle. For example,
suppose you accidentally put code inside a `task` lambda like this:

```groovy
task a {
    println "task a"
}
```

Running it sort of seems to be OK:

```text
>gradle a

> Configure project :
task a
```

It displays `task a` like I told it to. There's that extraneous `> Configure
project :` but I do know that there's a project configuration phase so it's
probably that.

What it's trying to tell you is that the `println` is being called during that
configuration phase, and not when the `a` task is being executed. Unfortunately
this can actually achieve the desired effect some of the time.

To tell it to run the code *when the task executes* you can use either `doFirst` or
`doLast`, like this:

```groovy
task a {
    doFirst {
        println "task a doFirst"
    }
    println "task a initialization"
    doLast {
        println "task a doLast"
    }
}
```

Now the output shows initialization as well as the task executing:

```text
>gradle a

> Configure project :
task a initialization

> Task :a
task a doFirst
task a doLast
```

There are numerous things like this that you need to know or else you will
experience surprises.

## Other Issues

- The Gradle documentation assumes you already know a lot. It is not a tutorial
  as much as a core dump. I now understand why, because *to do anything you have
  to understand everything*. But this assumption makes it challenging for the
  newcomer.

- Slow startup times. Over the years they've worked to speed it up but if you
  run Gradle a lot, the startup time becomes annoying. In contrast, `make` is
  extremely fast. Even all the build tools I've created in Python are quick by
  comparison.

- It's not that easy to discover Gradle's abilities, and there are so many
  abilities that you often don't know what's possible or what might already
  exist to solve your problem. It can be easy to flounder for quite awhile
  before discovering there's already a solution (or there isn't).

## Now That I Get It

I can finally start to understand my existing scripts, which is one of the
things that kept me from considering the switch to Kotlin for Gradle scripts.
But now that I have the big picture it's clear that I can do it and that I want
to. In particular, IntelliJ IDEA support for Groovy often can't infer types,
which is necessary for the IDE to look up available properties and methods for
an object. This alone makes it worth moving to Kotlin (which, like Groovy, is
another language). I think it will certainly make it appealing to Kotlin
programmers using Gradle for builds.

If you've been struggling to formulate a mental model for Gradle, I hope this
post has provided some insights.

[Comment on Reddit](https://www.reddit.com/r/Kotlin/comments/kqcqqr/the_problem_with_gradle/)

- **I am the Author of [Atomic Kotlin](https://www.atomickotlin.com/)
(with Svetlana Isakova), [On Java 8](https://www.onjava8.com/), and other books.**
