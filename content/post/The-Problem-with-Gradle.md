---
date: '2021-01-02'
published: false
title: The Problem with Gradle
url: /2021/01/02/The-Problem-with-Gradle
author: "Bruce Eckel"
---

> (With apologies to Hans Dockter)

To do anything you have to know everything

How to Remain Sane when Approaching Groovy

## 1. You're Programming in a Different Language



A new language which has a lot of similarities with Java but also a lot of new
things to understand.

## 2. Groovy Uses a *Domain-Specific Language*

How helpful is DSL syntax, really? I have to translate it into function calls in
my head when I read it. So for me it's more cognitive overhead and I'm not sure
if it's ultimately not a hindrance.

## 3. The Framework and Lifecycle

Groovy silently imports a ton of things which you have to know about in order to
use

## 3. There are Many Ways to do the Same Thing

Groovy allows you to express things in numerous different ways and the Gradle
documentation immediately seems to revel in all the different ways that you can
express the same thing. This compounds the complexity of learning cradle. Being
able to do things a bunch of different ways is not a feature.

## 4. The Documentation Assumes You

The Gradle documentation is not a tutorial as much as a core dump. I now
understand why, because to do anything you have to understand everything. But
learning cradle becomes overwhelming and people saying that it's simple
certainly doesn't help

# Now That I Get It

I can finally start to understand my existing scripts, which is what kept me
from, for example, considering switching to Kotlin for Gradle. But now that I
have the big picture, and can not only start to imagine how to do it, but
understand why I want to -- IntelliJ IDEA support for Groovy often cannot do
completion because it can't always infer types. Completion alone would make it
worth trying Kotlin.
