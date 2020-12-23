# Lecture 5: ViewBuilder Shape ViewModifier

- [1. `@ViewBuilder`](#1-viewbuilder)
- [2. `Shape`](#2-shape)

## 1. `@ViewBuilder`

- Based on a general technology added to Swift to support "list-oriented syntax". It's a simple mechanism for supporting a more convenient syntax for _lists_ of Views.

- Can be applied to any of functions that return something that conforms to View. If applied, the function will return something that conforms to View by interpreting the contents as a list of Views and combine them into _one_.

- That _one_ View that it combines it into might be:

  - a `TupleView` (for 2 to 10 Views)
  - or a `_ConditionalContent` View (when there's an `if-else` in there)
  - or an `EmptyView` (if there's nothing at all in there)
  - or _any combination_ of the above (if's inside other if's)

- Any `func` or read-only computed `var` can be marked with `@ViewBuilder`. If so marked, the contents of that `func` or `var` will be interpreted as a list of Views.

- `@ViewBuilder` can also be used to mark a _parameter that returns a View_.

  ```swift
  struct GeometryReader<Content> where Content: View {
      init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) { ... }
  }
  ```

## 2. `Shape`

- A `protocol` that inherits from View.

- By default, Shapes draw themselves by filling with the current foreground color.

---

←Previous: [Lecture 4: Grid enum Optionals](Lecture%204.md)
