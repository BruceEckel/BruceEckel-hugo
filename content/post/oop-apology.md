---
date: '2026-06-06'
published: false
title: An Object-Oriented Apology
url: /2026/06/06/oop-apology
author: "Bruce Eckel"
---

C++ was my first really interesting high-level language.
My first useful language was BASIC, my first "serious job" was assembly language and C.
I learned Pascal on my own.
In C++, though, you could make your own types with constructors and destructors and operator overloading.
I still remember what it felt like when I first heard Bjarne Stroustrup say the phrase "user defined data types."
It sounded like possibility.

But of course there was more.
There was inheritance.

I was working as a research assistant at the University of Washington School of Oceanography.
Tom Keffer had a grant to make computing easier for scientists and engineers.
The idea of overloading operators to do matrix manipulation seemed perfect.
The constructors and destructors would allocate and clean up the matrices.
Our target audience could focus on the equations and not the coding.

We were using Sun workstations (this was 198x).
To get the code for the C++ compiler we had to ask Bell labs to mail us a magnetic tape.
I think Stroustrup or Andy Koenig might have personally mailed it.
The tape contained the source code for `cfront` which compiled C++ code into C code;
this was actually a common subset of C because there was still no standard for the C language.
Every machine had its own custom version of C, so the `cfront` source code had to be written in the common C subset,
*and* the resulting `cfront` program also had to emit this common subset of C.
It was a brilliant way to adapt C++ to all the different architectures, as everyone had a C compiler.
Even if the variants of C disagreed with each other on more esoteric features, they all had a common foundation.
