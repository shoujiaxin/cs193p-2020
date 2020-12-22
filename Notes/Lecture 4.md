# Lecture 4: Grid enum Optionals

- [1. Varieties of Types](#1-varieties-of-types)
  - [1.1. `enum`](#11-enum)
- [2. `Optional`](#2-optional)

## 1. Varieties of Types

### 1.1. `enum`

- Another variety of data structure in addition to `struct` and `class`

- It can only have discrete states

- An `enum` is a _value type_, so it is copied as it is passed around

- Each state can (but does not have to) have its own "associated data"

  ```swift
  enum FastFoodMenuItem {
      case hamburger(numberOfPatties: Int)
      case fries(size: FryOrderSize)
      case drink(String, ounces: Int)
      case cookie
  }
  ```

- Setting the value of an `enum`

  ```swift
  let menuItem: FastFoodMenuItem = FastFoodMenuItem.hamburger(patties: 2)
  var otherItem: FastFoodMenuItem = FastFoodMenuItem.cookie
  ```

- Checking an `enum`'s state with a `switch` statement

  ```swift
  switch menuItem {
      case .hamburger: print("burger")
      case .fries: print("fries")
      case .drink: print("drink")
      case .cookie: print("cookie")
  }
  ```

  A `switch` must handle _ALL POSSIBLE CASES_, you can use `default` uninteresting cases.

- Associated data is accessed through a `switch` statement using this `let` syntax

  ```swift
  switch menuItem {
      case .hamburger(let pattyCount): print("a burger with \(pattyCount) patties!")
      case .fries(let size): print("a \(size) order of fries!")
      case .drink(let brand, let ounces): print("a \(ounces)oz \(brand)")
      case .cookie: print("a cookie!")
  }
  ```

- Methods & computed properties YES, (stored) properties NO

  ```swift
  enum FastFoodMenuItem {
      case hamburger(numberOfPatties: Int)
      case fries(size: FryOrderSize)
      case drink(String, ounces: Int)
      case cookie

      func isIncludedInSpecialOrder(number: Int) -> Bool {
          switch self {
              case .hamburger(let pattyCount): return pattyCount == number
              case .fries, .cookie: return true
              case .drink(_, let ounces): return ounces == 16
          }
      }
      var calories: Int { // switch on self and calculate caloric value here }
  }
  ```

  A `enum`'s state is entirely which case it is in and that case's associated data, nothing more.

- Getting all the cases of an enumeration

  ```swift
  enum TeslaModel: CaseIterable {
      case X
      case S
      case Three
      case Y
  }
  ```

  Now this `enum` will have a `static` var `allCases` that you can iterate over

  ```swift
  for model in TeslaModel.allCases {
      switch model { ... }
  }
  ```

## 2. `Optional`

- An `Optional` is just an `enum`. It essentially looks like

  ```swift
  enum Optional<T> {
      case none
      case some(T) // the case has associated value of type T
  }
  ```

  It can only has two value: _is set_ (`some`) or _not set_ (`none`)

- Where do we use `Optional`?

  Any time we have a value that can sometimes be "not set" or "unspecified" or "undetermined".

- Declaring `Optional`

  ```swift
  var hello: String?              var hello: Optional<String> = .none
  var hello: String? = "hello"    var hello: Optional<String> = .some("hello")
  var hello: String? = nil        var hello: Optional<String> = .none
  ```

  `Optional`s always start out with an implicit `= nil`.

- Force unwrapping with `!` or "safely" using `if let` and then using the safely-gotten associated value in `{ }` (`else` allowed too).

  ```swift
  print(hello!)
  if let safeHello = hello {
      print(safeHello)
  } else {
      // do something else
  }
  ```

- `??` does "Optional defaulting", it's called the "nil-coalescing operator"

  ```swift
  let y = hello ?? "foo"
  ```

---

←Previous: [Lecture 3: Reactive UI Protocols Layout](Lecture%203.md)
