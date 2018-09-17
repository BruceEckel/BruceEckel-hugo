---
date: '2018-09-16'
published: false
title: JSON Encoding Python Dataclasses
url: /2018/09/16/JSON-encoding-python-dataclasses
author: "Bruce Eckel"
---




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


def person_list(constructor, source: str):
    return [
        constructor(n[0], n[1], i)
        for i, n in enumerate(map(str.split, source.strip().splitlines()))
    ]


def muppets(constructor):
    return person_list(
        constructor,
        """
        Kermit Frog
        Fozzie Bear
        Bunsen Honeydew
        Rowlf Dog
        Camilla Chicken
    """,
    )


if __name__ == "__main__":

    pprint(muppets(Person))
```


**Output:**

```
[Person(first='Kermit', last='Frog', id=0),
 Person(first='Fozzie', last='Bear', id=1),
 Person(first='Bunsen', last='Honeydew', id=2),
 Person(first='Rowlf', last='Dog', id=3),
 Person(first='Camilla', last='Chicken', id=4)]
```



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

**Output:**

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
        # Base class default() raises TypeError:
        return json.JSONEncoder.default(self, obj)


if __name__ == "__main__":

    print(json.dumps(muppets(Person), cls=PersonEncoder, indent=2))
```

**Output:**

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


