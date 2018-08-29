---
date: '2015-11-20'
published: false
title: The Next Big Things
url: /2015/11/20/the-next-big-things
---


I gave the opening keynote at the JET conference in Minsk, Belarus. Despite
being sick the whole trip, I really enjoyed it all. The people were
especially friendly and appreciative---I heard from many conference
attendees that *Thinking in Java* was their very first programming book.

I spoke about the importance of the ecosystems and culture around
programming languages, and that evaluating a programming language involved
more than just looking at its technology. Because of this, one question
kept coming up during my time there: "What will be the next big thing in
programming?" I didn't have the answer then but I've been thinking about
it since.

The hard part about predicting the future is getting stuck in thinking that
it will be more of the same. This is legitimate: we tend to see incremental
developments in areas that are successful. But when you're looking for sea
changes, you have to step back and look for the big pain points---points
that often require so much effort on our parts that we end up so immersed
that we can't recognize that we need to fundamentally shift the world.

Here are three big ideas that I've come up with to answer the questions
from the Bela Russians, and why I think they might happen.

1. Integrated Dynamic Security

2. A model for parallelism

3. **Java++**

Java 7 and 8 have added some great features -- even I, noted Java cynic,
think so. The features have actually improved the programming experience,
something I had given up on.

Despite that, Java is shackled with terrible design decisions, which hold
the language back and drag down the programmers with it. Yes, I know, it's
the number one programming language by all measures. But that just means
that the majority of programmers are programming with manacles on.

Just two big ones: primitive types and type erasure in generics. Both of
these designs had their reasons: primitive types were added at the time
because of efficiency concerns (always a tricky choice), and type erasure
because generics hadn't been incorporated at the beginning, so it was
an adaptation. While we're on the subject, it would have been great to
include more complete closures from the beginning as well---it would have
made a much cleaner programming experience.

Primitive types became obsolete fairly early in Java's history, but we are
now saddled with them forever---imagine what programming would be like if
you didn't have to constantly think of special cases. Look at all the
special primitive cases for the Java 8 functional interfaces, for example.
All of those would just go away, resulting in much simpler programs.

I've talked about the problems of type erasure elsewhere, and I could go
on about other design problems. The point is that all of these add up to
a language that drags the programmer down. Yes, it's number one and that
has its advantages, but ultimately the impact on productivity is going to
force a change, and that's what I want to explore.

How can this change happen? How can we unseat the number one programming
language? In the past this has meant inventing a new language and making
it attractive enough for people to go through the pain of change, but
with Java's momentum people are more likely to say "yes, Java has its
problems, but people know how to use it and there are lots of libraries."
In fact, people do say that very thing right now.

So I foresee the transition happening this way: some cleaned-up Java-like
language arises, which solves things like parallel programming (let's say
everything is immutable), takes care of all my gripes and more, but at the
same time it's Java-like enough that Java programmers look at it and want
to change. But to solve all the problems it will have to be a different
language, running on a different VM, so all the code and libraries would
have to be rewritten, and that's too expensive.

But would they have to be rewritten by people? The best test of this new
language would be a translator that takes existing Java code and converts
it into Java++. If all your libraries were available on the new language
platform, it would be that much harder to resist. So that's what I think
will happen: a new language and VM that translates Java code into itself.