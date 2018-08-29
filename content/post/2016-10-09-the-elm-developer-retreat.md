---
date: '2016-10-09'
published: true
title: Notes from The Elm Developer Retreat
url: /2016/10/09/the-elm-developer-retreat
---

This [Developer Retreat](http://developer-retreat.com) was held Oct 6-9, 2016.
So far the consensus seems to be that Thursday-Sunday is best, because Monday
is often a big meeting day at companies (and taking two days at the end of the
week is within tolerability). At peak, we had six attendees including myself; on
the weekend we had two students from Colorado Mesa University in Grand Junction.

There will be another retreat directly following the [Winter Tech
Forum](http://www.WinterTechForum.com).

1. We all agreed that developer retreats are great, and we will continue doing
them and evolving the format.

    A. For one thing, it's much, much easier to figure things out in a group.

1. This is the second themed retreat (versus the very first un-themed retreat
after the last Winter Tech Forum), and the themed approach is definitely a
winner.

1. We all agreed that Elm is amazing and none of us ever want to write
Javascript again (to be honest we already didn't want to write Javascript
anymore).

1. On the first day we went through [The Pragmatic Studio Elm
Videos](https://pragmaticstudio.com/elm), which are out of date from 0.17 (he's
working on an updated version which I will happily get), and we found this an
excellent way to get everyone up to speed. When we ran into problems we stopped
the video and figured them out. We also stopped and fixed the example code to
make it work with 0.17, and that was a great exercise as well.

1. For support, the [Elm site](http://elm-lang.org) directs you to the [Elm
Slack Channel](http://elmlang.herokuapp.com/) and this was indeed very helpful.
One person there even gave me a starting point for my "grid of squares" problem.

1. The slack channel directs you to the [FAQ](http://faq.elm-community.org/).

1. Chromecast is a great way to work in groups to go through and explain code.

1. There are a lot of useful resources for learning Elm. I've captured a number
of them, along with the link to our Github repository, at the bottom of this
post.

1. We tried Google Spaces. It's nice and easy but has a number of drawbacks
compared to Slack that were show-stoppers for us. So at the Winter Tech Forum
we'll continue using Slack, unless something better shows up in the meantime.

    A. Messages can only be 170 characters.

    B. You can't do code snippets like you can in Slack.

1. Someone on the Elm Slack channel suggested that there be some way to allow
remote participation, even if it's just to set up a dedicated Slack channel. In
the past I've also had requests to set up a web cam. This merits investigation.

Resources
---------

- The [Getting Started Guide](https://guide.elm-lang.org/get_started.html).

- [The official Elm website](http://elm-lang.org/). Go here to install Elm, or you
can just try it directly [on the web](http://elm-lang.org/try).

- [Our Github repository](https://github.com/swoogles/ElmRetreat). Most of the subdirectories represent one person.

- [Richard Feldman's Elm book](https://www.manning.com/books/elm-in-action) is a
  very good introduction, even though only the first three chapters are complete
  so far. Richard works side-by-side with Evan Czaplicki (the creator of Elm) so
  the accuracy of this book seems like it should be very reliable.

- [package.elm-lang.org](http://package.elm-lang.org/): Lots of examples that
  other people have created. You will discover here features that you don't see
  in other literature.

- [Elm-format](https://github.com/avh4/elm-format) to impose standard formatting on your code.

- [99 problems solved using Elm](https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/)

- [Learn Elm in one small lesson per day](https://www.dailydrip.com/topics/elm)

- [One way to structure Elm apps](http://blog.jenkster.com/2016/04/how-i-structure-elm-apps.html)

- [Introduction to Websockets in Elm](https://medium.com/@zenitram.oiram/a-beginners-guide-to-websockets-in-elm-and-crystal-8f510c28eb61#.9fza1v5e)

- [A Grid Component](https://github.com/etaque/elm-hexagons/blob/master/src/Hexagons/Grid.elm)