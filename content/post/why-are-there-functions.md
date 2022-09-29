---
date: '2022-09-29'
published: true
title: Why Are There Functions?
url: /2022/09/29/why-are-there-functions
author: "Bruce Eckel"
---

Returning from giving my _Polymorphism Unbound_ presentation at StrangeLoop (not yet available on YouTube, but all the examples and presentation slides are [on Github](https://github.com/BruceEckel/PolymorphismUnbound)), I found myself dissatisfied. Part of this was certainly my failure to cram a 2-hour presentation into 40 minutes (after cutting it down from a day-long, workshop-length size). The bigger issue was my inability to answer the essential question at the end of the presentation: _why are we writing polymorphic functions_?

On my trip back from the conference, I began listening to a podcast where the interviewee dismissed recursion as an academic exercise that had little practical value. This got me wondering about the value of functions at all. Why do we write functions?

I should be able to answer this question. I began writing assembly language for embedded systems, and in that scenario there is a clear reason to create a function: You do it any time you discover repeated code, which:

1. Wastes space. Especially in the early days of programming, memory was scarce and expensive.

2. Requires duplicate debugging effort. This wastes programmer time and produces less-reliable systems. It also distributes bugs, so if you find a bug in one portion of some code you won't necessarily know that it needs fixing in other parts.

There's also the chance that if you create a useful, debugged function, it might be reusable by others on your project or in your organization, amplifying the value of that function. In my assembly-language days reusable code was a holy grail for the organization—management could easily see a direct relationship to cost savings.

The effort required to create a function in assembly language was significant. The caller had to correctly push arguments on the machine stack, then jump into the function which had to pull the arguments off, perform the calculation, then put the result on the stack. After jumping back to the call site, the caller was required to extract the result. When C came along it was literally a "higher-level assembly language" because it did these things for you and saved much programmer time.

Thus, functions were purely pragmatic: they were about programmer time, code size and safety/reliability. There was no concern about "side effects," that is, about whether it was a good idea for a function to manipulate the state of the system outside of that function. Indeed, many functions had the explicit goal of manipulating that state—changing an I/O pin, for example, in order to affect a display. Or incorporating state from outside the function by reading an analog-to-digital converter.

There was a significant amount of assembly-language programming going on in the early days, but we also had more sophisticated languages; initially the three only-languages-we'll-ever-need: FORTRAN for scientific programming, COBOL for business programming, and LISP for computer-science research (LISP required special hardware and thus couldn't be used as a practical mainstream language). FORTRAN and COBOL both had support for subroutines but these languages were used for batch programming to solve specific problems, and the programmers were preoccupied with getting the program to compile and run. Adding functions or making library calls increased the complexity of the programming process. To test your program you had to submit your punch cards and often wait overnight for the results, so any extra activity that could increase debugging time was seriously impactful.

In other words, most programmers were doing what we would today call "scripting" and were not preoccupied with functions. When higher-level languages like Pascal and C came along that made functions easy to write and use, no one had experience in designing programs around functions.

At this point, the "Structured Programming" movement is all but forgotten, but when I was getting started it was a big deal. In hindsight I can see that it was addressed to those "scripting programmers" who—understandably—tended to just write inline code rather than going to the not-insignificant effort of writing functions, since they often didn't know whether it would be worth it. Structured Programming was supposed to be a process for discovering and designing the functions in your system. Even if those programmers were using a higher-level language like C or Pascal, they had little experience writing functions (or using functions that others had written) so they tended to continue writing inline code.

The motivation behind Structured Analysis & Design was a business one: the problem should be broken into pieces that are distributed to individual programmers. It was a way for managers to partition work. This made Structured Analysis & Design easy to sell to the managers who were paying the consultants, but the end result did not take into account readability & understandability (Structured Analysis & Design paid lip service to maintainability, claiming without much evidence that it would be better). I read books and took several workshops on Structured Analysis & Design and still remember the moment when I thought "this all seems made up."

The logic of Structured Analysis & Design was understandably lost on mainstream programmers who were simply trying to get a job done. My first magazine editor (on the wonderful, long-ago lost-in-time Micro Cornucopia) was trained as a writer but self-taught as a programmer. His programs tended to be a stream of consciousness wrapped in a single "main." When I tried explaining the value of breaking it into functions it seemed arbitrary to him, since he was effectively writing scripts. He understood his own code and could fix it, so functions seemed superfluous. He wasn't the only programmer I encountered who wrote code that way. It was common for such programmers to ignore the existence of standard library functions and just write the code themselves unless absolutely forced to (for example, to do I/O).

Now consider the mathematical approach to functions. Here, functions package a concept. I want, for example, to know how fast an object is moving when it impacts the ground after falling for a certain time. This can be represented as:

```c
    v = g * t
```

(Velocity is gravity multiplied by time). This is only a simplified model because physical bodies act on each other. This equation assumes that the falling object is dramatically smaller than the planet it falls towards, so the gravitational effect of the falling object can be ignored.

More importantly for our case, mathematicians are driven by another optimization which we can call "chalk time." If they wrote functions the way we programmers do, it would have a greater impact on their hands, so they simplify it as much as possible. We programmers are more explicit—we include the function parameter list:

```c
    v(g, t) = g * t
```

We try to be as general as possible so we don't even require that we're on earth and make **g** one of the arguments to the function. On the mathematician's chalkboard, the arguments are assumed.

In math, the need for a function is clear: we want a particular output calculated using a set of inputs. In addition, there is no "surrounding context" that we can manipulate; no side-door where we can sneak in extra inputs or send outputs. In programming we call this a _pure function_ whereas in math it's just called "a function" because mathematicians simply have no other options.

Mathematical functions, then, are driven by and organized around the desired result. If I want to know how fast something is going, I write a function that captures all the factors that contribute to the resulting speed. Mathematical functions capture a _concept_ implemented through a _model_. For more complicated problems mathematicians use a system of interrelated equations, but the equation is the fundamental unit.

When programming, we usually start with a big problem and break it into smaller, more-manageable pieces. We don't often have the clear goals of the mathematician or physicist. Instead, the reusable/debuggable pieces of our problems only begin to appear _after_ we've built a working system and then step back and look at what we've done. At that point, we begin to see duplication and opportunities to break things into functions.

Functions in early languages were painful to create so programmers only wrote them to avoid repetition. With the advent of higher-level languages such as C and Pascal, the pain of creating functions went away. Now a new question arose: when does it make sense to write functions, beyond repetition elimination?

We were evolving from the straightforward creation of functions as units of reuse to the significantly more complex creation of functions as units of meaning. It's relatively easy to spot code repetition, but much harder to break a program into units of meaning that might only be called once. It's an extension or variation of one of the hard problems in programming: naming identifiers. You must rely on your own experience and intuition to decide what a function should be.

I love Daniel North's description of programming as surgery (you don't want to do it, you want as little of it as possible, and you want the most expert person doing it), but that's from the customer's standpoint. My definition is from the programmer's standpoint: _writing code is like writing prose_. Programmers are writers. It's a practice, you get better with experience, and the more feedback you incorporate about how understandable your code is, the better your code becomes.

So, as we move further from the constraints of hardware, my hypothesis is this: Functions are _both_ units of code reuse and units of meaning, together. Ideally the units of code reuse are pre-existing, so the application programmer should choose meaning first. Because of our history, this may require some re-education.

Take for example the functional programming concept of **fold**. This means "perform some operation on a sequence of elements to produce a combined result." Traditionally we've written a **for** loop to achieve this, but this involves repeated code, and that repeated code is known to produce various kinds of repeated errors (such as off-by-one). The **fold** captures the repetitive parts of a **for** loop so that you only write the code applied to each element (usually as a lambda), thus eliminating common **for**-loop code and associated errors. But for most programmers, the **for** loop is their first exposure to repetition and so there's significant resistance to rewiring their brains to replace **for** with **fold** (it's certainly taking me some time). And it doesn't stop there; all the standard functional concepts like **map**, **filter**, etc. require a shift in mindset to internalize them.

The application programmer should not be thinking about code reuse, but instead about functions as units of meaning. Structured Analysis & Design had a good concept, but got perverted by the need to find a paying customer. The true customer is the programmer, whose functions convey meaning to the other programmers who must understand and maintain that code.

If this is true, then the primary reason for a polymorphic function is to convey meaning. The concept of that polymorphic function happens to be expressed over multiple types instead of a single type. Consider some examples:

1. Ad-hoc polymorphism (overloading) seems like the most basic form of polymorphism. Different functions happen to use the same function name but take different parameter types, so clearly there is no code reuse going on—it is strictly conceptual.

2. Subtype polymorphism (inheritance and dynamic binding) requires up-front planning, extra code, and a little bit of runtime overhead. Sometimes there can be code reuse by defining default behaviors in the base class, but pure interface-implementation languages like Rust and Go don't allow that. It seems like subtype polymorphism is also predominantly conceptual.

3. Functions in languages that support ad-hoc protocols can accept any type that conforms to the protocol _without the type explicitly implementing an interface_. Luciano Ramalho calls this _static duck typing_—like dynamic duck typing, you only care that the argument supports the operation you perform within the function. With ad-hoc protocols, however, the type checking happens at compile time. We see this in languages like Rust and Go, and in C++ templates. The benefit of ad-hoc protocols is that you eliminate the need for the programmer to explicitly adapt a type (e.g. forcing it into an inheritance hierarchy) in order to use it within an existing "framework" (using a very loose definition of that term).

4. Parametric polymorphism (type parameters; for example generics in Java and templates in C++) are arguably a form of code reuse. A Java **Set&lt;T>** adapts the same piece of code for different types of **T**, and a **set** template in C++ reuses the same code by copying it for each different **class T** (a template can also be thought of as an "automatic overload generator"). But the _concept_ of "set" seems to be the most important issue here.

The other types of polymorphism I discussed in _Polymorphism Unbound_ can be considered in a similar way, and it seems that polymorphic functions all end up expressing concepts.

Earlier, I avoided giving an exact definition of "framework." We are used to thinking of that term as a big architectural decision involving a lot of code: a web framework or machine-learning framework, for example. But perhaps we should think in much smaller terms, such as: "a framework applies a set of logical operations to concepts." In this definition, each different concept is represented by a type, and the logical operations are packaged within a polymorphic function. If this argument holds, then the reason to write a polymorphic function is to create a (small, granular) framework. The design question then becomes: are you creating a closed framework for your own purposes (in which case, adding more types requires changing the framework code) or an open framework whereby another user can easily add new types without the need to change the framework code? (There are benefits to both).
