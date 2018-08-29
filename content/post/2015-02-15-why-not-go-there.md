---
date: '2015-02-15'
published: true
title: Why Not Go (Golang) There?
url: /2015/02/15/why-not-go-there
---


While there are a LOT of things I really like about [the Go language](http://golang.org/), the bottom line is that I don't use it (mostly because when I studied it the libraries were kind of scarce, something that's apparently changed a lot). It attracted me, but not enough for me to change over from Python.

Go has made some brilliant design decisions. I especially like the built-in features that in most other languages you must go figure out for yourself --- like the build tool, standard formatting (enforced with **go fmt**) a test framework (which you run with **go test**), and natively-supported concurrency/parallelism. Other languages (especially new ones) should take note and follow this example. Like Ruby on Rails, make the standard decisions and allow the user to trap-door out if they want, but don't just force everyone to go through the same basic decision exercises when they pick up the language. (One thing that really bugs me, though, is the use of tabs. I thought we had finally shaken that ancient artifact from mechanical typewriters.)

If Go had come out much earlier, I think it might have blown C++ out of the water. But the programming culture has evolved since then, and now things like classes and generics are understood and expected. And perhaps that's one of the issues: Go seems to be competing with C++ for the C crowd. Java already tried to move on from C++ (Gosling made it clear that their only choice for the never-built set-top box was C++ and that was such a heinous thought that they ended up creating a new language instead). 

The article [Everyday Hassles in Go](http://crufter.com/2014/12/01/everyday-hassles-in-go/) drills down into what's lacking in the language, in particular the need for generics.

I asked my favorite client (So far --- I hope for even better ones in the future) for an update in the year+ since he told me they were moving to Go:

> Well, a lot of interesting things have happened along that path. Almost nothing I thought would happen has come to pass. About the time everyone hit maximum frustration with Pythons (plural intentional) we decided to have extended weekend retreat to figure out where everything fit. And try as many different types of tequila and chile con quesos as we could. We wanted two paths: a great platform for prototyping that everyone could use and love, a high-performance platform for the few things that really needed to evolve beyond prototype, and a C-something library that could be used by both. If you're going to fantasize it might as well be no-holds-barred, right?

> The problem with Go is that it didn't really fit either one of those well. The prototypers (engineers and scientists) are into R, Mathematica, and Python. It might be fair to say that they were moving from R to the other two. Then along came Hadley Wickham on a one-man crusade to drag R into the 21st century. Things like dplyr, ggplot2, data.table, and a few other new packages have completely changed the face of R, much to the chagrin of the old guard and delight of users. So momentum has now swung back towards R, although there is considerable excitement about Mathematica and the new Wolfram language.

> On the high-performance side we've used a combination of C++ and Qt to build apps, although C#'s multicore stuff and new Microsoft approach to open source parts of it have changed perceptions. Younger programmers are more excited about C# than C++, so maybe there is something there. I thought that a language that supported concurrency natively like Go would appeal to the crowd, but the lack of scientific library support has turned them off. There seems to be consensus that native concurrency is highly desired, but that sustained investment and momentum are equally important. Google seems unable or unwilling to put resources into Go to compete with other frameworks. Or at least that’s the perception.

> We probably talked about other stuff as well, but by that time we were largely incoherent, so I'm not sure what else was decided. Since then we've started moving slowly to C# for heavy stuff. But with each passing year we leave more and more things in prototypes, in large part because they do everything we need with acceptable performance, so C# is becoming less and less relevant. Some people still play with Go, but not enough converts to sustain interest in it. My sense is that in a decade we’ll all be using Wolfram, but it’s a big enough change that old-timers like me can best facilitate it by retiring and making way for those who truly get it. To me it [Wolfram] seems so vast that I’m having a hard time getting my head around the core essentials.

> I’m in same boat as you are: I like Go, yet there is nothing particularly compelling about it. It seemed to better fit as replacement for the OO platforms we were using, and we liked the apparent efficiency of the language. And minimal is great as a design philosophy. But most of us felt that it was minimal because only a few zealots were working on it and they could only accomplish so much that way, making it more of an excuse than a bold statement. I wish it would succeed, but if it is going to elbow out the OO big dogs it needs more momentum than it has right now.

> I guess another factor that I forgot about was data frames. We use them in R, and Python has them as well (via pandas, which seems like a godsend compared to PyTables for the stuff we do). There was little enthusiasm for building comparable functionality in Go, or even looking into adapting pandas for it (as I had suggested). When we broached the topic with the Go dev team they offered embedded SQL as the answer for working with dynamic tables. Telling that to a bunch of simulation modelers like us is sort of akin to us to suggesting to them that they ought to be using Fortran to improve array processing.

> Maybe it will succeed, maybe won’t. But we’ll be watching from the sidelines rather than middle of the pack, which is where our initial enthusiasm led us to believe we’d be by now. 

What might change my own perspective to make me start using Go as-is? The biggest draw would be a really simple & transparent interface between Python and Go, so that if I need to do low-level hardware things or parallel programming (for more than can be accomplished with the [multiprocessing library](https://docs.python.org/3.4/library/multiprocessing.html)), I could easily drop into Go for that. The next-most-compelling factor would be a library that I couldn't find anywhere else --- an excellent example of this in Python is the [BeautifulSoup library](http://www.crummy.com/software/BeautifulSoup/) for manipulating HTML, the likes of which I've never seen anywhere.



