---
title: "We Haven't Invented Zero Yet"
date: '2020-07-30'
published: false
url: /2020/07/30/we-havent-invented-zero-yet
author: "Bruce Eckel"
---

I think most people currently alive were introduced to the concept of zero
quite early in their development&mdash;early enough that they internalized it
as a foundational principle and don't ask questions about it. In addition, many
people probably know that zero was invented after the original number systems.

The ancient Greeks didn't have a zero, and it puzzled them: "How can nothing be
something?"

If you start thinking about it, zero is pretty weird. Nonzero numbers are busy
telling you how many of something there is, while zero is telling you that
thing doesn't exist. It has a different job. And it behaves differently than
all the other numbers when you use it in calculations. It is the singularity of
numbers. Still, it behaves enough like the other numbers to be useful and
solves important problems like "what is the value of `a - a`"?

This brings us to the problem of `null`, which is definitely not zero. `null`
is "Nothing of any kind." `null` is the question that must never be asked. And
in some languages like C and C++, `null` means staring into the face of the
chaotic void that underlies reality (If you dereference a `null` pointer, that
reality dissolves into nothingness).

If my program asks, "How many chickens are there here?", it can count them. But
if there are no chickens, I don't get told there are zero chickens, I find out
instead that there is nothing of any kind, which is not what I asked.

This becomes especially problematic when designing generic containers. If we
create (in Kotlin) a `Yard`
