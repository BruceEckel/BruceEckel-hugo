# Creating Read-Only Maps

Consider the problem of initializing a read-only `Map`. To demonstrate, we
create a `Map` with keys that are `Pair`s, to include all possible combinations
of `color1 to color2`. We want to correlate each key to its value produced by
mixing those colors together.

We start by creating an `enum` of `Color`:

```kotlin
// BuildingMaps/PaintColors.kt
package buildingmaps

enum class Color {
  Red, Blue, Yellow, Purple,
  Green, Orange, Brown
}
```

Next, `blend()` takes two colors, mixes them, and produces the resulting color.
The final `else` clause is inaccurate but it keeps the example simple:

```kotlin
// BuildingMaps/ColorBlend.kt
package buildingmaps
import atomictest.eq
import buildingmaps.Color.*

fun blend(a: Color, b: Color): Color = when {
  a == b -> a
  a == Brown || b == Brown -> Brown
  else -> when (a to b) {
    Red to Blue, Blue to Red -> Purple
    Red to Yellow, Yellow to Red -> Orange
    Blue to Yellow, Yellow to Blue -> Green
    else -> {
      // Interesting but not accurate:
      val values = values()
      values[
        (a.ordinal + b.ordinal) % values.size]
    }
  }
}

fun colorBlendTest(
  mix: (a: Color, b: Color) -> Color
) {
  mix(Red, Red) eq Red
  mix(Purple, Brown) eq Brown
  mix(Red, Yellow) eq Orange
  mix(Yellow, Blue) eq Green
  mix(Purple, Orange) eq Blue // Not accurate
}

fun main() {
  colorBlendTest(::blend)
}
```

This also demonstrates more a complex `when` expression. We take care of the
basics first and the `else` handles the remaining cases.

The tests are placed in `colorBlendTest()` for later reuse.

To produce a read-only `Map` of all possible color blendings, use `buildMap()`
from the standard library:

```kotlin
// BuildingMaps/ReadOnlyBlendMap.kt
@file:OptIn(ExperimentalStdlibApi::class)
package buildingmaps

class BlendMap {
  val map: Map<Pair<Color, Color>, Color> =
    buildMap {
      for (a in Color.values()) {
        for (b in Color.values()) {
          this[a to b] =
            buildingmaps.blend(a, b)
        }
      }
    }
  fun blend(a: Color, b: Color): Color =
    map.getOrDefault(a to b, Color.Brown)
}

fun main() {
  colorBlendTest(BlendMap()::blend)
}
```

To create a mutable `Map`, move the initialization code from `buildMap` into an
`init` clause.

There are standard library functions similar to `buildString()` that use
extension lambdas to produce initialized, read-only `List`s and `Map`s:

```kotlin
// ExtensionLambdas/ListsAndMaps.kt
@file:OptIn(ExperimentalStdlibApi::class)
package extensionlambdas
import atomictest.eq

val characters: List<String> = buildList {
  add("Chars:")
  ('a'..'d').forEach { add("$it") }
}

val charmap: Map<Char, Int> = buildMap {
  ('A'..'F').forEachIndexed { n, ch ->
    put(ch, n)
  }
}

fun main() {
  characters eq "[Chars:, a, b, c, d]"
  //  characters eq characters2
  charmap eq "{A=0, B=1, C=2, D=3, E=4, F=5}"
}
```

Inside the extension lambdas, the `List` and `Map` are mutable, but the results
of `buildList` and `buildMap` are read-only `List`s and `Map`s.
