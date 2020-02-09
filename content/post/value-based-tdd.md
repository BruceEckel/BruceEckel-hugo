---
title: "Value-Based Pricing and TDD"
date: '2020-02-09'
published: true
author: "Bruce Eckel"
---

I first heard about value-based pricing from an accountant who was creating a
startup based on the idea. He tells a story about consulting for a family who
inherited an estate. Because  of the accountant's extensive knowledge, he was
able to give advice that saved the family a million or more. However, he only
charged for his time, a couple of hours. To save that amount, the story goes,
the family would have been happy to pay more, an amount based on the value of
the work rather than the time it took.

I've since subscribed to a newsletter from someone who specializes in teaching
and consulting about value-based pricing. His tagline is "Hourly Billing is
Nuts," and you can subscribe to the newsletter
[here](https://www.jonathanstark.com/list).

In one of his recent (very frequent) newsletters, he said this:

> When you're billing for your time there is no financial incentive to create
> systems or design processes or invest in tools that will allow you to finish
> your work more quickly.
>
> Without that incentive, the leverage-creation part of your brain atrophies.
> You stop thinking about clever ways to deliver the same results in fewer
> hours.

The leap here was that the financial incentive is the only one that counts.
Most programmers have numerous non-financial incentives. Making things faster
reduces boredom and tedium. We get a sense of satisfaction from making things
better, and that tends to drive us a lot more than the financial incentive
(this is why [Atomic Kotlin](https://www.atomickotlin.com/) is taking so
long).

I sent him a request for clarification:

> This assumes that the financial incentive is the only thing that stimulates
> clever thinking. Is that what you meant?

He replied:

> Clever thinking can be inspired by a lot of things. In a business context, I
> think being financially rewarded for clever thinking will lead to more clever
> thinking than being punished for it.

That softens it a bit, but I still resist the apparent emphasis that incentive
comes from money. Money is certainly a factor, but one among many. At
[Tribeworks](https://tribeworks.software/), we are experimenting with the idea
that quality of life is the big picture, and money is only one piece of that.

I've been pondering value-based pricing for awhile, and this is how I'll get
to TDD (Test-Driven Development). I certainly use a value-based approach for
consulting clients, although I charge by the day rather than the hour.
However, the fee factors in preparations, travel, and recovery time, so it
seems to me that it is at least *more* value-based than strictly charging for
time.

I have also had great experiences using TDD. I'm probably not doing *strict*
TDD, but the tests are created in lockstep with the development of the code.
My friend Luciano Ramalho (author of *Fluent Python*) likes to coach people in
TDD during any kind of group coding experiences, starting with "write a test
for the next step of what you want to do."

And therein lies the fundamental unspoken assumption for both value-based
pricing and TDD: you can accurately predict the future. If it's a task you
have done before and/or have a strong understanding of, then these are great
strategies.

But so much of what I do is exploratory. This is certainly true of my own
programming exploits, but it also applies to the work we do at
[Tribeworks](https://tribeworks.software/). For the consulting firm, many
tasks are new, and it's difficult to know enough about the team's learning
curve to be able to set a fixed price. I tend to be fiscally conservative, so
if I'm asked for a fixed price I am going to factor in the uncertainties and
the customer will probably end up paying significantly more in order to cover
those uncertainties.

One of my best experiences with TDD is
[here](https://github.com/BruceEckel/TeamUp). This had clear and precise
needs: to team people up using a round-robin algorithm. So I knew exactly what
I was doing and could easily use TDD, and the results were great. I can be
certain that I've implemented that algorithm correctly.

But if, as in many cases, I'm making it up as I go, there are two issues:

1.  I can't be sure ahead of time what, exactly, I'm trying to achieve, so I don't
    know what I'm testing for.

2.  When I'm exploring, test-first isn't a good use of my time. I'm trying to
    rapidly discover where I want to go, and applying TDD to code that I don't
    even know whether I'm going to keep is a hard sell for me.

Once I know I'm keeping code, then testing it becomes more compelling. I'll
note, however, that this knowledge isn't necessarily a sudden realization, but
comes over time as the code proves its viability. Unfortunately, by the time
that "proof" happens, the code may have slid into being not-as-easily-testable
as it should be.

I feel like there might be a middle ground for TDD. The more conscious you are
about testing, the more you're likely to write testable code, even when you're
exploring and not testing. I also find that the more I move into the functional
programming mindset, the more I tend to naturally write testable code.

The unspoken foundational idea beneath both TDD and value-based pricing that
you can predict the future is an expression of what I am calling "The
Simplicity Bias." This is our tendency as humans to really, really want things
to be simple and to push those things into a box of simplicity because it
feels good. It's the Simplicity Bias that allows people comfortably say things
like "Only use TDD" and "Hourly Billing is Nuts," while there are plenty of
situations where TDD isn't appropriate and when you just don't know how much
effort a project will take.

My father built custom homes, and despite the fact that the construction
industry is one of the biggest and slowest-to-evolve businesses out there,
that relative stability did not make it particularly easy for him to estimate
a project. When I've had remodels done, I've used someone I really trust and
then said "just charge me time and material." Even though they've done lots of
building projects, the relief is palpable when they know they don't have to
guess and estimate and possibly lose money on the project.

*(I'm trying a new experiment and cross-posting on [Reddit](), which is where you
can discuss this article.)*
