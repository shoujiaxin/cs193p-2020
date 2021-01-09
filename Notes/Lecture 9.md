# Lecture 9: Data Flow

- [1. Property Wrappers](#1-property-wrappers)
  - [1.1. `@Binding`](#11-binding)
  - [1.2. `@EnvironmentObject`](#12-environmentobject)
  - [1.3. `@Environment`](#13-environment)
- [2. Publisher](#2-publisher)

## 1. Property Wrappers

- All of those `@Something` statements are property wrappers.

- A property wrapper is actually a `struct`, which encapsulates some "template" behavior applied to the vars thew wrap.

- Examples:

  - `@State`: making a var live in the heap.
  - `@Published`: making a var publish its changes.
  - `@ObservedObject`: causing a View to redraw when a published change is detected.

- Syntactic Sugar: `@Published var emojiArt: EmojiArt = EmojiArt()` is actually

  ```swift
  struct Published {
      var wrappedValue: EmojiArt
      var projectedValue: Publisher<EmojiArt, Never>
  }
  ```

  Swift makes these vars available

  ```swift
  var _emojiArt: Published = Published(wrappedValue: EmojiArt())
  var emojiArt: EmojiArt {
      get { _emojiArt.wrappedValue }
      set { _emojiArt.wrappedValue = newValue }
  }
  ```

  and `projectedValue` can be accessed with `$`, e.g. `$emojiArt`. Its type is up to the property wrapper. `Published`'s is a `Publisher<EmojiArt, Never>`.

- The wrapper struct does something on set/get of the `wrappedValue`:

  - `@Published`

    - It publishes the change through its `projectedValue` (`$emojiArt`) which is a Publisher.
    - It invokes `objectWillChange.send()` in its enclosing `ObservableObject`.

  - `@State`:

    - The `wrappedValue` is anything (but almost certainly a value type).
    - It stores the `wrappedValue` in the heap; when it changes, invalidates the View.
    - Its `projectedValue` (i.e. `$`) is a `Binding` (to that value in the heap).

  - `@ObservedObject`

    - The `wrappedValue` is anything that implements the `ObservableObject` protocol (ViewModels).
    - It invalidates the View when `wrappedValue` does `objectWillChange.send()`.
    - Its `projectedValue` (i.e. `$`) is a `Binding` (to the vars of the `wrappedValue` (a ViewModel)).

  - `@Binding`

    - The `wrappedValue` is a value that is bound to something else.
    - It gets/sets the value of the `wrappedValue` from some other source. And when the bound-to value changes, it invalidates the View.
    - Its `projectedValue` (i.e. `$`) is a `Binding` (self; i.e. the `Binding` itself)

  - `@EnvironmentObject`

    - The `wrappedValue` is `ObservableObject` obtained via `.environmentObject()` sent to the View.
    - It invalidates the View when `wrappedValue` does `objectWillChange.send()`.
    - Its `projectedValue` (i.e. `$`) is a `Binding` (to the vars of the `wrappedValue` (a ViewModel)).

  - `@Environment`

    - The `wrappedValue` is the value of some var in `EnvironmentValues`.
    - It gets/sets a value of some var in `EnvironmentValues`.
    - It does not have `projectedValue` (i.e. `$`).

### 1.1. `@Binding`

- Where do we use `Binding`s?

  - Getting text out of a `TextField`, the choice out of a `Picker`, etc.
  - Using a Toggle or other state-modifying UI element.
  - Finding out which item in a `NavigationView` was chosen.
  - Finding out whether we’re being targeted with a Drag (the isTargeted argument to onDrop).
  - Binding our gesture state to the `.updating` function of a gesture.
  - Knowing about (or causing) a modally presented View’s dismissal.
  - In general, breaking our Views into smaller pieces (and sharing data with them).
  - ...

  `Binding`s are all about having a **single source of the truth**!

- Sharing `@State` (or an `@ObservedObject`'s vars) with other Views

  ```swift
  struct MyView: View {
      @State var myString = "Hello"
      var body: View {
          OtherView(sharedText: $myString)
      }
  }
  struct OtherView: View {
      @Binding var sharedText: String
      var body: View {
          Text(sharedText)
      }
  }
  ```

  `OtherView`’s `body` is a `Text` whose String is _always_ the value of `myString` in `MyView`. `OtherView`’s `sharedText` is _bound_ to `MyView`’s `myString`.

- Binding to a Constant Value with `Binding.constant(value)`.

- Create computed Binding with `Binding(get:, set:)`.

### 1.2. `@EnvironmentObject`

- Same as `@ObservedObject`, but passed to a View in a different way

  ```swift
  let myView = MyView().environmentObject(theViewModel)
  ```

  Inside the View

  ```swift
  @EnvironmentObject var viewModel: ViewModelClass
  ```

- Environment objects are visible to _all Views in your body_ (except modally presented ones). So it is sometimes used when a number of Views are going to share the same ViewModel.

- Can only use one `@EnvironmentObject` wrapper per `ObservableObject` _type_ per View.

### 1.3. `@Environment`

- _Unrelated_ to `@EnvironmentObject`. Totally different thing.

- Property Wrappers can have yet more variables than `wrappedValue` and `projectedValue`. They are just normal structs.

- You can pass values to set these other vars using `()` when you use the Property Wrapper.

  ```swift
  @Environment(\.colorScheme) var colorScheme
  ```

  The value that you're passing (e.g. `\.colorScheme`) is a key path. It specifies which instance variable to look at in an `EnvironmentValues` struct.

- the `wrappedValue`’s type is _internal_ to the `Environment` Property Wrapper. Its type will depend on which key path you’re asking for.

## 2. Publisher

- It is an object that emits values and possibly a failure object if it fails while doing so.

  ```swift
  Publisher<Output, Failure>
  ```

  - `Output` is the type of the thing this Publisher publishes.
  - `Failure` is the type of the thing it communicates if it fails while trying to publish.

  It doesn’t care what `Output` or `Failure` are (though `Failure` must implement `Error`). If the Publisher does not deal with errors, the `Failure` can be `Never`.

- What can we do with a Publisher?

  - Listen to it (subscribe to get its values and find out when it finishes publishing and why).
  - Transform its values on the fly.
  - Shuttle its values off to somewhere else.
  - ...

- Listening (subscribing) to a Publisher: execute a closure whenever a Publisher publishes.

  ```swift
  cancellable = myPublisher.sink(
      receiveCompletion: { result in ... }, //result is aCompletion<Failure>enum
      receiveValue: { thingThePublisherPublishes in ... }
  )
  ```

  If the Publisher’s `Failure` is `Never`, then you can leave out the `receiveCompletion` above.

  `.sink` returns a thing (which we assign to `cancellable` here). implements the `Cancellable` protocol. Very often we will type erase this to `AnyCancellable` (just like with `AnyTransition`).

  - you can send `.cancel()` to it to stop listening to that publisher
  - it keeps the `.sink` subscriber alive

  **Always keep this var somewhere that will stick around as long as you want the `.sink` to!**

- Listening (subscribing) to a Publisher: a View can listen to a Publisher too.

  ```swift
  SomeView
      .onReceive(Publisher) { thingThePublisherPublishes in
          // do whatever you want with thingThePublisherPublishes
      }
  ```

  `.onReceive` will automatically invalidate your View (causing a redraw).

- Where do Publishers come from?

  - `$` in front of vars marked `@Published`
  - `URLSession`’s `dataTaskPublisher` (publishes the Data obtained from a URL)
  - `Timer`’s `publish(every:)` (periodically publishes the current date and time as a Date)
  - `NotificationCenter`’s `publisher(for:)` (publishes notifications when system events happen)

---

←Previous: [Lecture 8: Gestures JSON](Lecture%208.md)

→Next: [Lecture 12: Core Data](Lecture%2012.md)
