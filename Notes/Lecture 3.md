# Lecture 3: Reactive UI Protocols Layout

- [1. Varieties of Types](#1-varieties-of-types)
  - [1.1. `protocol`](#11-protocol)
  - [1.2. `protocol extension`](#12-protocol-extension)
  - [1.3. `extension`](#13-extension)
  - [1.4. Generics and Protocols](#14-generics-and-protocols)
  - [1.5. Enum](#15-enum)
- [2. Layout](#2-layout)
  - [2.1. `HStack` and `VStack`](#21-hstack-and-vstack)
  - [2.2. Modifiers](#22-modifiers)
  - [2.3. `GeometryReader`](#23-geometryreader)
  - [2.4. Safe Area](#24-safe-area)

## 1. Varieties of Types

### 1.1. `protocol`

- A `protocol` is sort of a "stripped-down" `struct` / `class`

  It has `func`tions and `var`s, but _no implementation_ (or storage)!

  ```swift
  protocol Moveable {
      func move(by: Int)
      var hasMoved: Bool { get }
      var distanceFromStart: Int { get set }
  }
  ```

  now any other type can _claim to implement_ `Moveable`

  ```swift
  struct PortableThing: Moveable {
      // must implement move(by:), hasMoved and distanceFromStart here
  }
  ```

  or inherited by another `protocol` (this is called "protocol inheritance")

  ```swift
  protocol Vehicle: Moveable {
      var passengerCount: Int { get set }
  }
  ```

  and you can claim to implement multiple `protocol`s

  ```swift
  class Car: Vehicle, Impoundable, Leasable {
      // must implement move(by:), hasMoved, distanceFromStart and passengerCount here
      // and must implement any funs/vars in Impoundable and Leasable too
  }
  ```

- A `protocol` is a type

  Most `protocol`s can be used anywhere any other can be used

- Why `protocol`s?

  - It is a way for types to _say what they are capable of_.
  - For other code to _demand certain behavior_ out of another type.
  - Functional programming

### 1.2. `protocol extension`

- Adding `protocol` implementation

  You can add implementations to a `protocol` using an `extension` to the `protocol`

  ```swift
  extension Vehicle {
      func registerWithDMV() { /* implementation here */ }
  }
  ```

  or even add "default implementations" of the `protocol`'s own `func`s/`var`s

  ```swift
  extension Moveable {
      var hasMoved: Bool { return distanceFromStart > 0 }
  }
  ```

### 1.3. `extension`

- Adding code to a `struct` or `class` via an `extension`

  ```swift
  struct Boat {
      ...
  }
  extension Boat {
      func sailAroundTheWorld() { /* implementation */ }
  }
  ```

- Make something conform to a `protocol` via an `extension`

  ```swift
  extension Boat: Moveable {
      // implement move(by:) and distanceFromStart here
  }
  ```

### 1.4. Generics and Protocols

```swift
protocol Greatness {
    func isGreaterThan(other: Self) -> Bool
}
extension Array where Element: Greatness {
    var greatest: Element {
        // return the greatest by calling isGreaterThan on each Element
    }
}
```

### 1.5. Enum

- A type that holds a "discrete value"

## 2. Layout

- How is the space on-screen apportioned to the views?

  1. Container views "offer" space to the views inside them
  2. views then choose what size they want to be
  3. Container views then position the views inside of them

- Container views

  - The "stacks" (`HStack`, `VStack`) divide up the space offered to them amongst their subviews
  - `ForEach` defers to _its_ container to lay out the views inside of it
  - Modifiers (e.g. `.padding()`) essentially "contain" the view they modify

### 2.1. `HStack` and `VStack`

- Divide up the space that is offered to them and then offer that to the views inside

- Offers space to its "least flexible" (with respect to sizing) subviews first

- There are a couple of really valuable views for layout that are commonly put in stacks:

  - `Spacer(minLength: CGFloat)`

    - Always takes all the space offered to it
    - Draws nothing
    - The `minLength` defaults to the most likely spacing you'd want to a given platform

  - `Divider()`

    - Draws a dividing line cross-wise to the way the stack is laying out
    - Takes the minimum space needed to fit the line in the direction the stack is going

- Stack's choice of who to offer space to next can be overridden with `.layoutPriority(Double)`.

  ```swift
  HStack {
      Text("Important").layoutPriority(100)  // any floating point number is okay
      Image(systemName: "arrow.up")          // the default layout priority is 0
      Text("Unimportant")
  }
  ```

- Another crucial aspect of the way stacks lay out the views they contain is _alignment_

  ```swift
  VStack(alignment: .leading) { ... }
  HStack(alignment: .firstTextBaseline) { ... }
  ```

  Stacks automatically adjust for environments where text is right-to-left (e.g. Arabic or Hebrew). The `.leading` alignment lines the things in the `VStack` up to the edge where text starts from.

### 2.2. Modifiers

- View modifier functions (like `.padding`) themselves return a view, which "contains" the view it's modifying.

- Many of them just pass the size offered to them along (like `.font` or `.foregroundColor`). But it is possible for a modifier to be involved in the layout process itself.

### 2.3. `GeometryReader`

Wrap this `GeometryReader` view around what would normally appear in your view's body

```swift
var body: some View {
    GeometryReader { geometry in
        ...
    }
}
```

The `geometry` parameter is a `GeometryProxy`

```swift
struct GeometryProxy {
    var size: CGSize
    func frame(in: CoordinateSpace) -> CGRect
    var safeAreaInsets: EdgeInsets
}
```

`GeometryReader` itself _is just a view and always accepts all the space offered to it._

### 2.4. Safe Area

- Generally, when a view is offered space, that space does not include "safe areas".

- It is possible to ignore this and draw in those areas anyway on specified edges

  ```swift
  ZStack { ... }.edgesIgnoringSafeArea([.top])  // draw in "safe area" on top edge
  ```
