---
date: '2020-10-04'
published: false
title: The Rust Developer Retreat
url: /2020/10/04/rust-retreat
author: "Bruce Eckel"
---

The goal of a developer retreat is to stop what you are doing for awhile and
explore something new. This usually requires a shift in mindset, and the
biggest shift is to suspend the focus around productivity and urgency. It's
important to give up the idea that "we must accomplish something in an amount
of time." Only with the sigh of relief that comes from liberating yourself from
goals is your brain allowed to float to the most interesting places.

My friend Jeremy Cerise, who comes to most of these retreats, had said that he
had become re-interested in the Rust language again and wanted to explore it.
We had touched on Rust a couple of years before, but that retreat was invested
with urgency and goals and Rust ended up feeling too complicated and
cumbersome. I was skeptical, but I've found that if Jeremy is interested in
something, there's probably something there, so Rust was worth a second look.

We had both gotten Covid at the [Winter Tech
Forum](https://www.wintertechforum.com/) in March, so it seemed like we could
probably spend time together reasonably safely.

My initial plan was to break Rust up into small topics and create exercises
around those topics, as if it were a framework for a book. I don't want to
write a Rust book, but I thought it might be helpful for someone who does.

That idea immediately went out the window as soon as I started reading the Rust
documentation/book, which you can find [here](https://doc.rust-lang.org/book).
Although it is definitely designed for experienced programmers, I found the
thinking and writing in this book incredibly clear and compelling, and whether
I ever do anything serious with Rust I want to read the book just for its
insights about programming.

Rust itself is a bit of a conundrum to describe. Chapter 4 of the book begins
by stating "Rust’s central feature is ownership." Basically, this means that
Rust is designed around *not* having a garbage collector. To do that, it
provides as much language and compiler support as possible to guarantee that
you don't mis-manage your memory, because you're doing it all by hand.

This is what can seem weird at first about Rust. Garbage collectors do a lot of
valuable work for the programmer. They librate programmers to focus on the
problem at hand rather than being forced to pay attention to low-level details.
There is some overhead, but that overhead almost universally pays off in the
form of programmer overhead. The compromise of giving up the garbage collector
feels like a significant step backward.

And this focus on low-level efficiency pervades Rust. Any Rust code you look at
leaves a metallic taste in your mouth of being right next to the hardware. That
awareness of hardware is ever-present, and for that reason I've started calling
Rust a "very-high-level assembly language."

It's the "very-high-level" part that becomes compelling, however. I don't
*want* to write in assembly language or anything like it (I spent the first
several years of my career writing assembly for embedded systems). But if I
*must*, I'd rather have the highest-level tools helping me. I don't think I've
seen anything that comes close to Rust for solving the problem of writing
low-level code.

Both Jeremy and I have strong Python backgrounds, and we both became fascinated
with a problem that has plagued the Python community from its beginning: when
you need to do something low-level, what do you do. Python was designed to be
able to call C components, but this was always messy and complicated. Over the
years there have been many attempts to solve this problem, some better than
others but none I have ever looked at and felt no intimidation.

So we wondered whether Rust might be a good solution for speeding up slow parts
of a Python program. We started with [this
article](https://developers.redhat.com/blog/2017/11/16/speed-python-using-rust/),
but couldn't get it to work because of what turned out to be a simple renaming
problem that doesn't seem to be mentioned anywhere. Upon giving up, we
discovered [PyO3](https://github.com/PyO3), which really beautifully solves most
(all?) of the setup for interfacing Python and Rust. If you want to write Rust
extensions for Python, this appears to be the nicest solution.

We then turned our attention to [Go](https://golang.org/), which also has some
nice potential as an extension language for Python. When we looked for
something similar to PyO3 for Go, there appeared to be several abandoned
projects. Had the Go community decided their language wasn't worth adapting to
Python? Then gRPC appeared&mdash;this is Google's super-performant remote
procedure call system, which they use virtually everywhere and which apparently
supports billions of calls per second across Google.

I first encountered this concept when I was on the C++ standards committee and
the [CORBA](https://www.corba.org/) initiative began. A core part of CORBA was
the goal of making language-agnostic function calls across networks. The Object
Management Group was (at least at the time) bogged down with bureacracy and
was controlled predominantly by the larger organizations that could pay the
costs of being on that committee. The focus was on the specification and you
had to implement it by hand, which wasn't easy. My first experience of creating
a CORBA system didn't happen until it was available (and easy) on Python.


