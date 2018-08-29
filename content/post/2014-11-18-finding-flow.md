---
comments: true
date: '2014-11-18'
subtitle: Balancing Uncertainty via Concrete Projects
title: Finding Flow
url: /2014/11/18/finding-flow
---

![Silvrback blog image sb_float](https://silvrback.s3.amazonaws.com/uploads/8fc6d334-3a73-4099-aea0-468792efd997/Painting2_medium.png)

**(*This post is an experiment to test a new blogging platform.* This version is just straight out of MarkdownPad into Github pages, with no other software on my local machine)**

## Balancing Uncertainty via Concrete Projects ##

The [Reinventing Business](http://www.reinventing-business.com/) project is my "own personal Everest to climb," my project that, once I saw it, I couldn't unsee. It's also very unclear whether I will ever make any significant breakthroughs in that area. 

Although I do OK with uncertainty, I can't function with that much uncertainty *all* the time (or perhaps it's something one learns through experience). I need to balance the thing where I don't know much of anything, with something where I have a pretty good grasp, and way to figure things out. One person observed that the latter suggests I am "looking for flow."

I've come full circle to realize that I find flow in computer programming, and in writing about programming. I've also been able to promote, and at least partially finance my writing through the world of programming. Thus it makes sense that in my search for "balancing flow" I turn back to projects like *Thinking in Java*. Is there some way I can reuse *Thinking in Java* to create both flow and income?

The first obvious thing to look at is upgrading to the new, open-sourced version 8 of Java. There are other opportunities here: replacing Ant with Gradle, for example, and choosing better libraries rather than the standard libraries --- ultimately creating an improved hybrid of Java by picking and choosing best-of-breed tools and libraries.

This sounded good but I immediately encountered a problem when I started researching the Java 8 language itself. Here's a set of articles that give an overview of what's new and different in Java 8:

* [http://blog.paralleluniverse.co/2014/05/01/modern-java/](http://blog.paralleluniverse.co/2014/05/01/modern-java/)
* [http://blog.paralleluniverse.co/2014/05/08/modern-java-pt2/](http://blog.paralleluniverse.co/2014/05/08/modern-java-pt2/)
* [http://blog.paralleluniverse.co/2014/05/15/modern-java-pt3/](http://blog.paralleluniverse.co/2014/05/15/modern-java-pt3/)
* [http://java.dzone.com/articles/why-we-need-lambda-expressions](http://java.dzone.com/articles/why-we-need-lambda-expressions)

The above articles are full of hope and promise, and made me feel that yes, I was on the right track here. But then I found these:

* [http://java.dzone.com/articles/whats-wrong-java-8-currying-vs](http://java.dzone.com/articles/whats-wrong-java-8-currying-vs)
* [http://java.dzone.com/articles/whats-wrong-java-8-part-ii](http://java.dzone.com/articles/whats-wrong-java-8-part-ii)
* [http://java.dzone.com/articles/whats-wrong-java-8-part-iii](http://java.dzone.com/articles/whats-wrong-java-8-part-iii)
* [http://java.dzone.com/articles/whats-wrong-java-8-part-iv](http://java.dzone.com/articles/whats-wrong-java-8-part-iv)
* [http://java.dzone.com/articles/java-8-optional-whats-point](http://java.dzone.com/articles/java-8-optional-whats-point)

Consider, for example, some code from the last article in the above list (a test of code listings and syntax highlighting in github-flavored markdown):

```java
public static void main(String[] args) {
  OptionalTest optionalTest=new OptionalTest();
  String nullString=optionalTest.getNullString();
try {
  System.out.println(nullString.toString());
} catch(NullPointerException x) {
  System.out.println("Oh the humanity, a NullPointerException!");
}
```

After being away from code like this, the thought of trying to make sense of even more Java language decisions --- considering how much hair I've lost over this in the past --- made me nauseous. I don't want to go down that rabbit hole again. It just seems like an *awful* prospect.

An intermediate approach would be to select the features that I think produce a positive cost-benefit for Java 8. That is, the pain of learning/using those new features is low and the benefits are useful enough. Teach those, and then say "if you want/need to go beyond this, you should consider just switching to [Scala](http://www.AtomicScala.com)." On top of that, as a build system, use Gradle instead of Ant or Maven, and find the simplest testing framework and in general use the best available libraries rather than just using what comes "in the box" when you install the JDK.

Although this intermediate approach sounds significantly less painful (and ultimately more useful for the reader) than just repeating the "Thinking in Java" approach, it still feels like the bottom of my list of interesting things to do. I think a lot of that comes from the fact that Java has *not* fulfilled its original goal of being the universal language, but has instead settled into the server-side niche. Which is great; something needs to be in that niche, but I personally don't find the server side to be that exciting anymore. For me, the interesting aspect of Java could be ...

## Android ##

During last couple of years at the at the [Java Posse Roundup](http://www.mindviewinc.com/Conferences/JavaPosseRoundup/), Java Posse member Tor Norbye (who works in Google's Android group) has suggested that I re-target *Thinking in Java* for Android. This has significant appeal because Android's version of Java is basically identical to the version in *Thinking in Java, 4th edition*. Gradle is now the official build system for Android, and I could choose an optimal test framework and libraries. Add to that the move towards handheld programming, and the large percentage of  programmers writing for Android, and for several days I was certain that my next project would be *Thinking in Android*.

Also, the upcoming version of Android [looks very interesting](http://developer.android.com/preview/index.html). Android does seem to be pushing device programming forward more than anyone (although I'm definitely a fan of [Apple's new Swift language](http://www.artima.com/weblogs/viewpost.jsp?thread=361253)).

But then James Ward pointed out that the recent loss of the Oracle lawsuit could throw quite a wrench in Android, perhaps even stimulating Google to change development languages, possibly even to Google's own (open-source) Go language. I read one post that claimed this would be too big a project, but of any company, Google seems the most likely to undertake such a project, especially considering the money they'd otherwise be handing over to Oracle --- why not spend that money on changing languages instead?

I need more data before considering that road, and Google isn't talking.

## What about Python? ##

Every time someone asks me what my favorite language is, assuming I'll say C++ or Java or perhaps Scala (since I've written books on those topics), I always observe that whenever I need to solve any real problems of my own, I always reach for Python. I've solved problems using Python that would have been difficult, time-wasting and/or impossible in other languages. I've been involved with the Python community for over 15 years; I've given keynotes at two different Pycons. My favorite consulting customer turned out to need shifting to Python, which was great fun and very satisfying.

And in terms of the ratio of programming power per lines of code, Python is right up there at the top, while retaining strong readability. That certainly fits with my mission of greater leverage.

Years ago I started working on [a Python book](http://www.mindviewinc.com/Books/Python3Patterns/Index.php), which was to be an open-source project with group participation --- an experiment. After several different (failing, but informative) attempts at using participation systems, I got sidetracked. Would this book be a useful contribution to the Python community? Is a book even the best pursuit?

I also need to (in the spirit of [Start with Why](https://startwithwhy.com)) revisit why writing a book is even a thing to do. My original motivation for writing books about programming was to market myself as a consultant, and then books became a thing of their own. If I was to do programming work, my first choice would be working in Python, and if that's what I'd like to do, perhaps there's a more expedient way to get that kind of work.

## Rust ##

Another language that's caught my interest is [Rust](http://www.rust-lang.org/). I visited the Mozilla headquarters 1.5 years ago to talk about their organizational structure but ended up spending most of the time talking about Rust. Because it's natively compiled and has built-in *communicating-sequential process* (CSP) support, Rust could be thought of as a competitor in the C++/Go space. However, it pushes the boundaries in most areas, and is strongly influenced by Haskell.

Here's a nice in-depth [article on Rust](http://eev.ee/blog/2012/11/17/a-little-bit-rusty/).

My take on Rust is that it was being developed in order to create the next version of Firefox. Which makes sense, since Rust is designed from the ground up to prevent crashes and make bulletproof parallelism easy. Mozilla has had [some recent shakeups](http://eev.ee/blog/2014/04/05/mozilla-and-free-speech/), however, and the new CEO seems to be reallocating resources to focus on the FireFox OS. This makes a lot of sense to me --- the Chrome browser keeps getting better and better, and gaining more users. Microsoft is finally behaving well in the internet community with Internet Explorer. Spending resources on a second open-source web browser is not really the best investment.

The goal of FireFox OS is first to create a handheld OS for low-cost, low-CPU-power devices, targeted in particular to developing countries who often have to share a single expensive device among numerous people, often an entire village. Secondly, it seeks to standardize handheld app development on web-standard technologies: Javascript, HTML5 (this requires some extensions) and CSS, to make handheld programming transparently cross-platform and to reduce the onboarding effort for new programmers.

I think these are both very important goals. The risk in targeting low-cost, low-power platforms, of course, is seen in [One Laptop Per Child](http://one.laptop.org/), where by the time the systems were gaining traction, commercial (Android) systems had fallen so far in cost that the program's impact (while not negligible) was minimized. This would only really affect the first goal; cross-platform programming with web-standard technologies will continue to be beneficial.

Rust is an open-source project so I don't expect it to go away, and will continue to keep an eye on it. But with Mozilla refocusing on Firefox OS, I am concerned that Rust will lose resources.

Back in C++ days before the STL, I would create various libraries, like **vector** and **list** and **map**, and include them in my early C++ books and articles. I ended up building these from scratch, again and again, and each time I saw them differently, and better, precisely because I was starting over again. I think this is happening with languages now, because the tools and foundations have gotten better, and we've gotten better at designing and implementing them. As a result, we are moving away from being stuck in old language paradigms and instead shaking them off, and moving towards languages that are not mired in compromise. Someday programmers will look back at this time and see what we struggled with, and what held us back.

[Nim](http://nimrod-lang.org/) is another new language which, like Rust, compiles to native and appears to learn from its predecessors. There are bindings to other languages, including Python, in the standard distribution.

## Kotlin ##

Another attractive possibility is [Kotlin](http://kotlinlang.org/), an open-source language being created with support by JetBrains, a company with an excellent track record of paying attention to the needs of the mainstream programmer.

A major reason Kotlin is appealing is that it has much in common, syntactically, with Scala, but without the dark corners --- nay, dark pits ("fly, you fools!") --- which may ultimately isolate Scala to the world of *experts only*. So it looks like I could do a translation of *Atomic Scala* to *Atomic Kotlin* which "might not require too much effort" (words I have regretted numerous times in my career). And then see what happens, before committing a major effort to the language.

During the [Scala Summit](http://www.scalasummit.com) a group of us explored Kotlin; my goal was to see if anything jumped out at me arguing against writing about the language --- nothing did. At the recent [Geecon conference in Prague](http://geecon.cz/), I met with some of the Jebrains folks to find out what kind of support they might offer for such a project --- they seem enthusiastic, so this is a very promising avenue I will continue to pursue.

## A Build System ##

Here's something I keep coming back to: I've been using --- and been kind of fascinated with (because of their productivity potential) --- build tools since pretty much the beginning of my professional career. Not that I can say I ever felt like I mastered any of them, but some, like **make** and **ant**, I used enough to see where they started dropping the ball.

I've also created my own build systems. The most recent one was for *Atomic Scala*, built in Python, to be reasonably simple. And it worked OK.

But now that I'm going back to fix up Atomic Scala, I'm reminded of an issue that comes up again and again, which is what happens when you wade back into a build system and have to start re-learning what it does and how it does it. I don't know that I've ever encountered a build system that is designed to make the build files easy to understand. Sure, some have gotten better. But if I ever created another build system, my first priority would be to make the build files readable/understandable.

I could see going in two directions: either starting with a well-designed scripting language like Python and extending that, or taking a systems language like Go and designing a build system from the ground up. But ultimately, the challenge is in figuring out the psychology of build systems in order to produce build scripts that are maximally readable.

## Smaller Projects that Cull the Past ##

Something easier and more mechanical is taking material that I've produced in the past and repurposing it. Two examples are:

### Collection of Blog Posts ###

Especially now that I'm moving my programming blog away from [Artima](http://www.artima.com/weblogs/index.jsp?blogger=beckel), perhaps it's time to go through and find all the best-of my old blog posts and turn those into an ebook. That would definitely involve editing and rewriting but would be relatively straightforward and likely to produce "flow."

### Computer Interfacing with Pascal & C ###

This was my [very first book](http://mindview.net/Books/books.html#ComputerInterfacingwithPascalAndC), published right when I turned 30 (for some reason that seemed like an important milestone). I self-published it because I knew nothing about the publishing industry at the time and just assumed they wouldn't want to be bothered with my work. Life would have been different if I had continued to follow that path.

The press run was about 1100 copies, and they sold well at first (primarily through Micro Cornucopia), and then have trickled out ever since, to the point where I'm down to about a dozen copies. The computers referred to in the book are shockingly old, starting with Kaypros and moving on to the original IBM PC clones. However, the book's description of electronics is still mostly valid and useful (I'm pretty sure you can still get most or all of the chips described), and you can use the programs as prototypes for whatever language you're using now.

There were a few more articles that were published in Micro Cornucopia since the book came out, and I could incorporate those and produce an e-book without too much effort. So that would be another reasonably flow-ish project that would produce satisfaction without excessive work. 

## In the Short Term: Atomic Scala ##

[Atomic Scala](http://www.atomicscala.com/) has been out long enough that there's a new Scala point release that has produced some small changes to the book, along with the numerous accumulated edits that accumulate once you've "put the manuscript in a drawer" for awhile --- you read it again and a lot of corrections and rewrites jump out at you. I've had a number of people report bugs, mostly in the exercises and solutions.

In addition, I've started getting requests for foreign-language translation rights, and I'd like the project to be tuned up before someone goes to the effort of a translation.

So, regardless of what the next-next project is, I've started on a second edition of *Atomic Scala.* It's probably a bit of a stretch to call it a second edition but I feel like there's just enough to do it.

Now that I've started the project, I've found that it really *is* satisfying to have my hands on something concrete. And it's an important realization that with most/all languages I've written about, there are significant design decisions that made me grit my teeth and grumble etc. Now that I'm looking at programming activities as a vacation from struggling with the vast vagaries of Reinventing Business, I realize I don't want to be working with something that I'm griping about; I'm getting more interested in languages that are designed to make things easier for the average programmer.

**Note:** If you get the current [Atomic Scala eBook](http://www.atomicscala.com/ebook), you'll automatically get the update. Alas, the print books are too expensive to do this with, so if you really want the [print book](http://www.atomicscala.com/order-book) right now, you can come back when the second edition is ready and download the changes as an HTML page.

## Let's Think About This ##

Although Atomic Scala is the obvious first choice, after that I'd really like to consider whether a choice is *right* before just diving in. Making money is nice and it helps support my other endeavors (mostly *Reinventing Business* at this point), but if something is not inspiring, or worse, an energy suck, then I'd rather make a different choice, because unless these things truly support my "why" in multiple ways, then I'm backsliding.

Thanks for listening.
