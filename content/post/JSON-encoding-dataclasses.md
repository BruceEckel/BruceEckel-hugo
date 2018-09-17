---
date: '2018-09-16'
published: false
title: JSON Encoding Python Dataclasses
url: /2018/09/16/JSON-encoding-python-dataclasses
author: "Bruce Eckel"
---




```python
# Python 3.7
import json
from dataclasses import dataclass
from pprint import pprint

@dataclass
class Person:
    first: str
    last: str
    id: int


class PersonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Person):
            return obj.__dict__
        # Base class default() raises TypeError:
        return json.JSONEncoder.default(self, obj)


people = [Person(n.split()[0], n.split()[1], i)
    for i, n in enumerate("""
        Kermit Frog
        Fozzie Bear
        Bunsen Honeydew
        Rowlf Dog
        Camilla Chicken
        """.strip().splitlines())]

pprint(people)
print(json.dumps(people, cls=PersonEncoder, indent=2))
```


Output:
```
[Person(first='Kermit', last='Frog', id=0),
 Person(first='Fozzie', last='Bear', id=1),
 Person(first='Bunsen', last='Honeydew', id=2),
 Person(first='Rowlf', last='Dog', id=3),
 Person(first='Camilla', last='Chicken', id=4)]
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
# Python 3.7
import json
from dataclasses import dataclass
from pprint import pprint

@dataclass
class Person:
    first: str
    last: str
    id: int

    class JSON(json.JSONEncoder):
        def default(self, obj):
            if isinstance(obj, Person):
                return obj.__dict__
            # Base class default() raises TypeError:
            return json.JSONEncoder.default(self, obj)


people = [Person(n[0], n[1], i)
    for i, n in enumerate(map(str.split, """
        Kermit Frog
        Fozzie Bear
        Bunsen Honeydew
        Rowlf Dog
        Camilla Chicken
        """.strip().splitlines()))]

pprint(people)
print(json.dumps(people, cls=Person.JSON, indent=2))
```
