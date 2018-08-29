---
date: '2017-07-19'
published: true
title: Gophercon And The Concurrent Python Developer Retreat
url: /2017/07/19/gophercon-and-the-concurrent-python-developer-retreat
---


I found Gophercon to be valuable and it restarted my interest in the Go language.
I'm currently working my way through [The Go Programming Language
Phrasebook](https://play.google.com/store/books/details?id=scyH562VXZUC) and
plan to explore ways to call Go from Python (described later in this post).

If I hadn't been attending with my friend [Luciano
Ramalho](http://www.oreilly.com/pub/au/5939) it would have been a different
experience. The conference is clearly commercial and I had a strong sense of
having my experience decided for me. Most of the time there was only one
activity going on, perhaps a selection of talks (often too crowded to get into),
but a number of times only a single keynote or something happening that was
intended to force the attendees to hang out around the vendor booths. This
served the conference organizers and the vendors, but it wasn't all that
valuable for the attendees.

I would strongly recommend that the Gophercon organizers attend and study
[Pycon](https://us.pycon.org) to experience an attendee-centered conference. At
Pycon, there's always a multitude of things to do and experience. With
Gophercon, what you see on the resulting online videos is not that different
from what you get by attending. Sure, there are the occasional opportunities
for meeting new folks. Meals are probably the best for this, because you need to
sit somewhere and that tends to produce new connections. The conference parties
are intended to achieve this, but these basically throw you into a big noisy
space with food and possibly games, and rely on you to start conversations. A few
thoughtful (and free) touches would catalyze the connections that people at the
conference clearly want to make.

Here's an example. I mentioned my observations to Luciano, and before I knew it
he had spontaneously created an open-spaces conference at one of the tables,
simply by making a sign on that table reading "Pythonistas who love Go" and
tweeting about it. The people who showed up were hungry for this conversation
and I think there could have been a lot more of this. Instead, if people weren't
interested in what was going on or the talk they wanted to see was too crowded,
they ended up working on their own at one of the tables. I loved Luciano's
tactic and will try something like that myself if I end up in a similar
situation -- I'll call it *guerilla open spaces*.

We stayed for part of the "community day," an optional post-conference event
when everyone really started to connect. This was, to my perception, the
highest-energy and most collaborative day of the conference, and showed what
kind of potential this conference really has. It was also an opportunity for
open-source project sprinting, but as was discovered long ago at Pycon, one day
doesn't do it. In fact, you're lucky if you get people up to speed with tools
and the project on the first day, which is why Pycon has four post-conference
sprint days (I only sprinted for a couple of days last year, three days this
year, and next year I will stay the whole four days -- the experience and learnings
I've gotten from sprinting has just been fantastic).

A lot of people had either completely come over from Python or were programming
in both Python and Go. A number of speakers told this story. My impression was
that the Python-Go crossover was the most common one, but that's probably
because I was particularly interested in it. I did find it a little unfortunate
that several of the speakers said mildly deprecating things about Python,
especially since I'd like to explore using Python everywhere possible, for the
power and development speed, and to see if Go can be used to solve many of
Python's concurrency issues.

Indeed, I went to Gophercon not just because Luciano asked me to, but because I
hoped to understand more about Go's concurrency model. I came away with a much
better but far-from-perfect understanding. Everything I've learned so far
continues to support the idea that Go can be used in conjunction with Python, at
least for some set of concurrency problems. So I want to continue that
experiment.

I had a very interesting discussion with one person who is a big fan of both
Python and Go, and had a strong understanding of concurrency. He made a
fascinating observation, which is that there are areas where Go is "more
Pythonic" than Python, as per Tim Peters' [The Zen of
Python](https://www.python.org/dev/peps/pep-0020/). In particular, "There
should be one--and preferably only one--obvious way to do it." When it comes
to concurrency, there are many competing ways to solve that problem, and
the main fork happens between asynch (when you're waiting around for something
external to happen) and parallelism (when your problem takes lots of processing
power). The basic solutions in Python are `async/await` and `multiprocessing`.
But in Go, you don't have to think about the type of concurrency problem
you're solving; you just use goroutines for everything. Thus, more Pythonic:
one obvious way to do it.

I was especially interested in the [grpc](https://grpc.io/) cross-language
bridge. There was a presentation that used this, and the grpc intro pages have
working examples, one of which is Python to Go, which I tested on my Windows
10 machine. The `grpc` unboxing experience was seamless and exceptionally
good, which means I'll probably explore it further when I need high-speed
foreign-function calls. There's a certain attraction to using something
supported by Google.

However, during the developer retreat, Jim Fulton told us about
[MessagePack](http://msgpack.org/) which has a [cross-language RPC
implementation](https://github.com/msgpack-rpc/msgpack-rpc). This also seems
worthy of exploration.

The conference made Go a particularly interesting way to offload concurrency
problems from Python. Using Go is the one solution we didn't get to during the
developer retreat, but I see a lot of possibility here for [Concurrent
Python](http://www.concurrentpython.com) and I intend to explore this avenue
further.

The Conconcurrent Python Developer Retreat
------------------------------------------

I'll say that the "core" members of the event were myself, Luciano and [Jim
Fulton](http://jimfulton.info/) of Zope fame. We had others who were attending
and contributing while still remotely working at their jobs (un-named in case
that's an issue) and one intern from the local college who was attempting to
drink from the firehose.

In this retreat, we were too ambitious. I've had plenty of experiences trying
to do too much, but the topic was interesting and we had some good minds
working on it so I got drawn into the enthusiasm.

We were too ambitious but we learned a great deal. We usually take more breaks
and do more outside activities, but our ambition drove us more this time so we
exhausted ourselves on a couple of occasions. I need to pay more attention to
this in the future and perhaps even add a little structure around breaks and
activities.

We did manage to get one walk in on the third day, after we had all gotten
mentally exhausted.

At Gophercon, Luciano and I talked to the folks at the **Twitch.tv** booth,
who convinced us that Twitch is about more than gaming, and that it would be a
good way to livestream programming events. This idea was interesting enough
that after Luciano told me Thoughtworks' choice for streaming camera and
microphone, I ordered them from Amazon so we could use them for part of the
conference. Alas, Amazon failed: the days kept passing and I kept hearing
about delays in delivery, so it never happened. Next time we'll give it a try.

As an experiment I bought a Google Chromecast perhaps a year ago. I've hardly
used it for anything, but during workshops like this it's priceless to be able
to have anyone in the room quickly and easily cast their desktop to the TV. We
used it almost constantly during this developer retreat.

## The Projects

> All these projects reside in the [Concurrent Python Github
Repository](https://github.com/ConcurrentPython).

As previously mentioned, Python tends to partition concurrency into async and
parallel, so we came up with projects to test those approaches.

The first was based on something I've been thinking of for awhile. I enjoy
webcomics but the reading tools require too much mousing-and-clicking. In
addition, while they originally might open the comic directly in the reader,
it turns out that the artists often only get paid if you open the page (and
the associated ads) on the supporting site.

So the first project used asynch calls to open a list of pages, opening each
in a tab when it became available. In
[WebComicReader](https://github.com/ConcurrentPython/WebComicReader) you'll
see multiple Python files, each containing the different approaches we tried,
including basic async/await, concurrent futures, and gevent. Not everything
worked, or worked easily, or produced the results we expected (Remember we
were in full exploration mode; pull requests welcome).

To explore parallelism, Luciano came up with the idea of grabbing some images
and performing CPU-intensive image processing on them -- we chose the
application of a blur filter. Various solutions are in the [Parallel Image
Processing](https://github.com/ConcurrentPython/Parallel_Image_Processing)
repository. `linear.py` just does them one at a time, to show the longest
possible processing duration, while the other two experiment with parallel
versions.

One of the more illuminating days was the last one. As we implemented the
photo-blurring problem using various techniques, Jim kept mentioning Rust. Jim
had implemented a ZODB server in Rust a year before, so it seemed like an
ideal opportunity to learn more about this language. Lots of people seem to
use the refrain "I don't know much about Rust but it sounds interesting and
I'd like to explore it more." So I asked Jim if he'd be willing to work
through the photo-blurring problem in Rust and he agreed.

The first interesting thing was setup. Jim worked on this for awhile before
he just built the environment in a Docker container. This showed that Rust
is still in flux; there seemed to be language feature error messages that
popped up around libraries unless you had exactly the right combination
of compiler and tools; I think we ended up using the nightly build. It seems
like just getting set up could be quite daunting for a novice.

Jim hadn't done much with Rust in the past year, but before that he had built a
fairly complex piece of software. In the intervening year, many of the details
of Rust had slipped away from him and he had to recover them. I've had this same
experience with C++. When you have so many facets you need to keep in your head,
and when the features in question are not language-intuitive but rather are
low-level details necessary to satisfy some other need, then it's easy to lose
track of those details.

In the case of C++, the extra mental baggage came from both the requirement of
backwards compatibility with C, and performance. This threw in lots of special
cases you had to remember. In the cast of Rust, there's no
backwards-compatibility issue, which was a relief, but that simplification was
far more than overwhelmed by all the performance issues.

From my limited exposure to the language, I feel safe in saying that the entire
*raison d'etre* of Rust is performance. You'd choose this language if you are
solving a problem fundamentally driven by performance. One oft-repeated use case
is rewriting [Firefox](https://mozilla.org/en-US/firefox/new) in Rust. Considering
how many people use web browsers, something like this could, for example,
significantly reduce electric power usage while at the same time increasing the
responsiveness of the browser. For that kind of problem it makes a lot of sense.

But the mental overhead and the amount of work necessary is enormous. In Rust
you must constantly pay attention to memory management. When you call a
function, you must also understand how your memory management is going to
interact with that function, and make decisions about it. This is on top of the
complexity of the language. My perception is that if you decide to create a
project in Rust, you must live and breathe that language and it will completely
occupy your brain, with no room for any other language.

Before committing to Rust for a project, you must be very clear that the costs
are worth the benefits. Rewriting FireFox, for sure. But for a problem like ours
it wasn't clear that the performance was faster than the other approaches. This
might well be due to a poor implementation of the Rust image processing library
we used, but after all the work it would be pretty disappointing to discover
that a solution in Go or even Python was around the same speed or even faster.

You can find the Rust implementation of the image processor
[here](https://github.com/ConcurrentPython/rust-image). Jim put this up a few
days after the conference, and it now looks deceptively much simpler than
what we were seeing during development.

Rust is not the language I'm seeking because it's not a rapid-development
solution, so I'm putting it on the back shelf for the time being. I can
definitely imagine projects where it could be a good solution, but I doubt I'd
want to work on those projects.

Once I get far enough through the Go book, I want to try implementing the
image-processing problem in Go and see what kind of performance comes from that.

Keep in mind that I have always had a particular orientation towards achieving
desired results while minimizing development effort. If you have different
objectives and needs, you will probably come to different conclusions than I do.