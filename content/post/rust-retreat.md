---
date: '2020-11-22'
published: true
title: Python Extensions with Rust and Go
url: /2020/11/22/rust-retreat
author: "Bruce Eckel"
---

The goal of a developer retreat is to stop what you are doing for awhile and
explore something new. This usually requires a shift in mindset, and the
biggest shift is to suspend the focus around productivity and urgency. It's
important to give up the idea that "we must accomplish something in an amount
of time." Only with the sigh of relief that comes from liberating yourself from
goals is your brain allowed to float to the most interesting places.

My friend Jeremy Cerise, who comes to most of these retreats, said that he had
become re-interested in the Rust language and wanted to explore it. We had
touched on Rust a couple of years before, but that retreat was invested with
urgency and goals and Rust ended up feeling too complicated and cumbersome. I
was skeptical, but I've found that if Jeremy is interested in something,
there's probably something there, so Rust was worth a second look.

We had both gotten Covid at the [Winter Tech
Forum](https://www.wintertechforum.com/) in March, so it seemed like we could
probably spend time together reasonably safely.

My initial plan was to break Rust up into small topics and create exercises
around those topics, as if it were a framework for a book. I don't want to
write a Rust book, but I thought it might be helpful for someone who does.

That idea went out the window as soon as I started reading the Rust
documentation/book, which you can find [here](https://doc.rust-lang.org/book).
Although it is definitely designed for experienced programmers, I found the
thinking and writing in this book incredibly clear and compelling, and whether
I ever do anything serious with Rust I want to read the book just for its
insights about programming.

Rust itself is a bit of a conundrum to describe. Chapter 4 of the book begins
by stating "Rust's central feature is ownership." Basically, this means that
Rust is designed around *not* having a garbage collector. To do that, it
provides as much language and compiler support as possible to guarantee that
you don't mis-manage your memory, because you're doing it all by hand.

This is what can seem weird at first about Rust. Garbage collectors do a lot of
valuable work for the programmer. They liberate programmers to focus on the
problem at hand rather than being forced to pay attention to low-level details.
There is runtime overhead, but that overhead almost universally pays off in the
form of greatly-reduced programmer effort. Giving up a garbage collector feels
like a significant step backward.

This focus on low-level efficiency pervades Rust. Any Rust code you look at
leaves a metallic taste in your mouth of being right next to the hardware. That
awareness of hardware is ever-present, and for that reason I've started calling
Rust a "very-high-level assembly language."

The "very-high-level" part is compelling. I don't *want* to write in assembly
language or anything like it (I spent the first several years of my career
writing assembly for embedded systems). But if I *must*, I'd rather have the
highest-level tools helping me. I don't think I've seen anything that comes
close to Rust for solving the problem of writing low-level code.

Both Jeremy and I have strong Python backgrounds, and we both became fascinated
with a problem that has plagued the Python community from its beginning:
low-level extensions. Python was designed to be able to call C components, but
this was always messy and complicated. Over the years there have been many
attempts to solve this problem, some better than others but none I have ever
looked at and felt no intimidation.

So we wondered whether Rust might be a good solution for speeding up slow parts
of a Python program. We started with [this
article](https://developers.redhat.com/blog/2017/11/16/speed-python-using-rust/),
but couldn't get it to work because of what turned out to be a simple renaming
problem that doesn't seem to be mentioned anywhere. Upon giving up, we
discovered [PyO3](https://github.com/PyO3), which beautifully solves most or
all of the setup for interfacing Python and Rust. If you want to write Rust
extensions for Python, PyO3 appears to be the nicest solution.

We then turned our attention to [Go](https://golang.org/), which also has nice
potential as an extension language for Python. When we looked for something
similar to PyO3 for Go, there appeared to be several abandoned projects. This
one looked the most promising:

- [gopy: Generate Python Extensions in Go](https://github.com/go-python/gopy)

However there were statements like *This is a newly-improved version that works
with current (e.g., 1.12) versions of Go.* (the current version of Go is
1.15&mdash;1.12 was about two years ago). Also: *Limitations: Windows
completely untested, likely needs something special*. (Windows dwarfs every
other platform out there. You've *got* to support it).

Has the Go community decided their language wasn't worth adapting to Python?
Maybe we didn't look hard enough? Then we remembered gRPC, Google's
super-performant *remote procedure call* (RPC) system, which they use virtually
everywhere and which apparently supports billions of calls per second across
Google.

- [Tutorial: Python and gRPC](https://grpc.io/docs/languages/python/basics/)

- [gRPC Python Docs](https://grpc.github.io/grpc/python/)

I've always been fascinated with getting different languages to interact with
each other. It seems very powerful to be able to use the best features of each
language. I first encountered the idea of RPCs when I was on the C++ standards
committee as the [CORBA](https://www.corba.org/) initiative began. A core part
of CORBA was the goal of making language-agnostic function calls across
networks.

In most RPC protocols you describe data and functions using an *interface
description language* (IDL). An IDL is like a restricted programming language
that can only describe data structures and function interfaces. You run the IDL
through a generator that produces code for your specific programming language.
You then add application-specific code and deploy the result. Using a common
format for interfacing greatly simplifies the process of making RPCs.

The Object Management Group that created CORBA was (at least at the time)
bogged down with bureacracy and was controlled predominantly by the larger
organizations that could pay the costs of being on that committee. The focus
was on the specification and you had to implement it by hand, which wasn't
easy. My first experience of creating a CORBA system didn't happen until it was
available (and easy) on Python. The specification-first,
design-by-special-interests approach floundered for a long time and never
gained traction, despite huge investments in creating and promoting it.

Other RPC systems learned from CORBA's mistakes; in particular the need for
implementations and supporting tools. We saw solutions like XML/RPC which
worked nicely but had limitations and enough performance overhead that you
needed to balance the cost of making calls over the wire to the benefits of the
remote call.

There's even a system being developed called ALPS that uses a meta-IDL to take
a spec and generate different IDLs for systems like GraphQL, gRPC and REST:

- [ALPS Spec](https://tools.ietf.org/html/draft-amundsen-richardson-foster-alps-04)

- [ALPS Example](https://github.com/alps-io/alps-contacts)

## Rust or Go?

Ideally, calling overhead should not be a factor in deciding whether to
use remote procedure calls. And consider Google's massive system: tiny amounts
of memory or delays could produce immense impacts. They were compelled to make
gRPC as efficient as humanly possible. If overhead is a non-issue, calling from
Python to another language becomes a much easier decision. But is this the
case?

This article shows that Rust is at least 30% faster than Go in all their
testing algorithms, and sometimes much faster than that:

- [When to use Rust and when to use Go](https://blog.logrocket.com/when-to-use-rust-and-when-to-use-golang/)

The gRPC approach is a little more complicated, as well, because you must start
a server in another process to provide the gRPC service in Go. However, if Go
has features you want, even with the speed differences with Rust, it could
still be so much faster than what you were trying to do in Python that it might
never be an issue. If you already understand Go and are comfortable with it and
don't have time to delve into Rust right now, then Go and gRPC will almost
certainly solve your problem. But if you know from the start that squeezing out
every drop of performance is essential, then you want Rust for your Python
extension.

- **I am the Author of [Atomic Kotlin](https://www.atomickotlin.com/)
(with Svetlana Isakova) and [On Java 8](https://www.onjava8.com/).**

[Comment on Reddit](https://www.reddit.com/r/Python/comments/jz6a0z/python_extensions_with_rust_and_go/)
