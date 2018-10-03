---
date: '2018-09-16'
published: true
title: JSON Encoding Python Dataclasses
url: /2018/09/16/JSON-encoding-python-dataclasses
---

The [Hugo](https://gohugo.io/) static-site generator can work with data files in
the form of JSON, yaml or toml. If you place these in the `data` directory you
can access them within Hugo templates (including Hugo shortcodes, which are called directly
from a Markdown file) by saying `.Site.Data.<filename>`, and then use the contents as
part of your static-site build.

This feature came in handy for the [AtomicKotlin.com](http://atomickotlin.com/)
site, because the ebook deployment service
I'm using (Stepik.org) uses numeric ids for each chapter, and I needed to generate links for
the [sample chapters](http://atomickotlin.com/sample/).
I decided to generate JSON from this list of ids, and thought it would
be interesting to see whether Python 3.7's `@dataclass` could be used for this.

The `@dataclass` decorator is only available in Python 3.7 and later. It follows the precedent
set by languages like Scala (case classes) and Kotlin (data classes). It creates what is sometimes
called a *data transfer object*, whose job is only to hold data. The problem is that you often
need to create proper behavior for such objects, which requires defining methods for equality
comparison, display, etc., and these methods are tedious to create and prone to mistakes. A
`@dataclass` generates all these methods for you, providing a succinct syntax for
data transfer classes.

I'll start by creating a `Person` class. Note that `@dataclass` is only possible because of the
addition of optional static typing to Python 3, as we need to declare types for the fields in
the class. Observe how simple it is to create a `@dataclass`:

```python
# person.py
# Requires Python 3.7
from dataclasses import dataclass
from pprint import pprint

@dataclass
class Person:
    first: str
    last: str
    id: int

def person_list(person_constructor, source: str):
    return [
        person_constructor(n[0], n[1], i)
        for i, n in enumerate(map(str.split,
            source.strip().splitlines()))
    ]

def muppets(person_constructor):
    return person_list(
        person_constructor,
        """
        Kermit Frog
        Fozzie Bear
        Bunsen Honeydew
        Rowlf Dog
        Camilla Chicken
        """)

if __name__ == "__main__":
    pprint(muppets(Person))
```

`person_list()` takes a `person_constructor` argument which it applies to create
each instance of a `Person` object. This allows us to use a different `Person` constructor
later in this post.

`person_list()` takes a block of text, splits it into lines, then maps `str.split()` to each
line, producing a first and last name. It uses `enumerate()` to generate id numbers, and
returns a `list` of `Person` objects for use in testing.

The output shows that the `@dataclass` decorator automatically generates a `__str__()` method
for `Person`:

```
[Person(first='Kermit', last='Frog', id=0),
 Person(first='Fozzie', last='Bear', id=1),
 Person(first='Bunsen', last='Honeydew', id=2),
 Person(first='Rowlf', last='Dog', id=3),
 Person(first='Camilla', last='Chicken', id=4)]
```

However, there is no support for JSON encoding&mdash;that's something
we must do ourselves by inheriting the `JSONEncoder` class and overriding
the `default()` method:

```python
# person_encoder.py
import json
from person import Person, muppets

class PersonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Person):
            return obj.__dict__
        # Base class default() raises TypeError:
        return json.JSONEncoder.default(self, obj)

if __name__ == "__main__":
    print(json.dumps(muppets(Person), cls=PersonEncoder, indent=2))
```

The basic `JSONEncoder` can only encode `dict`s, `list`s and primitive
types. If you create your own encoder, you must check for that type inside
your `default()` and produce a result that the basic encoder can handle.

Notice what I've done here: all I had to do was produce the internal object
dictionary by saying `return obj.__dict__`. Because the basic encoder knows
what to do with a `dict`, it can produce the keys and values from the
`__dict__` produced by the `@dataclass`.

When calling `json.dumps()`, you must provide the new `PersonEncoder` as the
`cls` argument. Now we get properly-formatted JSON as our output:

```
[
  {
    "first": "Kermit",
    "last": "Frog",
    "id": 0
  },
  {
    "first": "Fozzie",
    "last": "Bear",
    "id": 1
  },
  {
    "first": "Bunsen",
    "last": "Honeydew",
    "id": 2
  },
  {
    "first": "Rowlf",
    "last": "Dog",
    "id": 3
  },
  {
    "first": "Camilla",
    "last": "Chicken",
    "id": 4
  }
]
```

What's interesting is that I didn't hand it a `Person` object, but a `list`.
`json.dumps()` knew to take the `list` apart, then apply my `PersonEncoder` to each
element of the list.

To take the example a little further, let's see how hard it is to apply the
same technique to a `namedtuple`, which has much in common with a `@dataclass` except
that the fields of a `namedtuple` are immutable. It turns out that `PersonEncoder`
is identical:

```python
# namedtuple_encoder.py
import json
from person import muppets
from collections import namedtuple

Person = namedtuple("Person", "first last id")

class PersonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Person):
            return obj.__dict__
        return json.JSONEncoder.default(self, obj)

if __name__ == "__main__":
    print(json.dumps(muppets(Person), cls=PersonEncoder, indent=2))
```

Notice there's a slight difference in the resulting JSON:

```
[
  [
    "Kermit",
    "Frog",
    0
  ],
  [
    "Fozzie",
    "Bear",
    1
  ],
  [
    "Bunsen",
    "Honeydew",
    2
  ],
  [
    "Rowlf",
    "Dog",
    3
  ],
  [
    "Camilla",
    "Chicken",
    4
  ]
]
```

Instead of a `list` of `dict`s, the `namedtuple` produces a `list` of `list`s.
