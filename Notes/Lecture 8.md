# Lecture 8: Gestures JSON

- [1. Persistence](#1-persistence)
  - [1.1. Storing Data Permanently](#11-storing-data-permanently)
  - [1.2. `UserDefaults`](#12-userdefaults)
- [2. Gestures](#2-gestures)
  - [2.1. Getting Input from the User](#21-getting-input-from-the-user)
  - [2.2. Making your Views Recognize Gestures](#22-making-your-views-recognize-gestures)
  - [2.3. Creating a Gesture](#23-creating-a-gesture)
  - [2.4. Handling the Recognition of a Discrete Gesture](#24-handling-the-recognition-of-a-discrete-gesture)
  - [2.5. Handling Non-Discrete Gestures](#25-handling-non-discrete-gestures)

## 1. Persistence

### 1.1. Storing Data Permanently

There are numerous ways to make data persist in iOS:

- In the filesystem (`FileManager`).
- In a SQL database (`CoreData` for OOP access or even direct SQL calls).
- iCloud (interoperates with both of the above).
- `CloudKit` (a database in the cloud).
- Many third-party options.
- `UserDefaults` (the simplest to use).

### 1.2. `UserDefaults`

- Think of it as sort of a "persistent dictionary".

- Only should be used for "user preferences" or other lightweight bits of information.

- It is limited in the data types it can store.

- `UserDefaults` can _only_ store what is called a Property List.

  - Property List simply a "concept".
  - It is any combination of `String`, `Int`, `Bool`, floating point, `Date`, `Data`, `Array` or `Dictionary`.
  - If you want to store anything else, you have to convert it into a Property List. A powerful way to do this is using the `Codable` protocol in Swift, which converts structs into `Data` objects.

- `UserDefaults` has a lot of uses of the type `Any` (which basically means "untyped").

- Using `UserDefaults`

  ```swift
  let defaults = UserDefaults.standard
  // Storing Data
  defaults.set(object, forKey: "SomeKey") // object must be a Property List
  defaults.setDouble(37.5, forKey: "MyDouble")
  // Retrieving Data
  let i: Int = defaults.integer(forKey: "MyInteger")
  let b: Data? = defaults.data(forKey: "MyData")
  let u: URL? = defaults.url(forKey: "MyURL")
  let strings: [String]? = defaults.stringArray(forKey: "MyString")
  ```

  Retrieving `Array` of anything but `String` with

  ```swift
  let a = array(forKey: "MyArray")
  ```

  will return an `Array<Any>`. You would have to use the `as` operator to "type cast" the Array elements. `Codable` might help avoid this by using `data(forKey:)` instead.

## 2. Gestures

### 2.1. Getting Input from the User

- SwiftUI has powerful primitives for recognizing "gestures" made by the user's fingers.

- This is called multitouch (since multiple fingers can be involved at the same time).

- SwiftUI pretty much takes care fo "recognizing" when multitouch gestures are happening.

- All you have to do is _handle_ the gestures. In other words, decide what to do when the user drags or pinches or taps.

### 2.2. Making your Views Recognize Gestures

```swift
myView.gesture(theGesture) // theGesture must implement the Gesture protocol
```

### 2.3. Creating a Gesture

Usually `theGesture` will be created by some func or computed var you create. Or perhaps by a local var inside the body var of your View.

```swift
var theGesture: some Gesture {
    return TapGesture(count: 2)
}
```

This happens to be a "double tap" gesture.

### 2.4. Handling the Recognition of a Discrete Gesture

Discrete gesture happens "all at once" and just does one thing when it is recognized (i.e. `TapGesture` and `LongPressGesture`).

Use `.onEnded { }` to "do something" when a discrete gesture is recognized

```swift
var theGesture: some Gesture {
    return TapGesture(count: 2)
        .onEnded { /* do something */ }
}
```

Discrete gestures also have “convenience versions”

- `myView.onTapGesture(count: Int) { /* do something */ }`
- `myView.onLongPressGesture(...) { /* do something */ }`

### 2.5. Handling Non-Discrete Gestures

In non-discrete gestures, you handle not just the fact that the gesture was recognized, also the gesture while it is in the process of happening (fingers are moving).

Examples:

- `DragGesture`
- `MagnificationGesture`
- `RotationGesture`

`LongPressGesture` can also be treated as non-discrete (i.e. fingers down and fingers up).

You still get to do something when a non-discrete gestures ends

```swift
var theGesture: some Gesture {
    return TapGesture(count: 2)
        .onEnded { value in /* do something */ }
}
```

Note though that its `.onEnded` passes a `value`, which is the state of the `DragGesture` when it ended.

What that `value` is varies from gesture to gesture

- For a `DragGesture`, it's a struct with things like the start and end location of the fingers.
- For a `MagnificationGesture`, it's the scale of the magnification (how far the fingers spread out).
- For a `RotationGesture`, it's the `Angle` of the rotation (like the fingers were turning a dial).

During a non-discrete gesture, you’ll also get a chance to do something while it’s happening. Every time something changes (fingers move), you will get a chance to update some state. This state is stored in a specially marked var

```swift
@GestureState var myGestureState: MyGestureStateType = <starting value>
```

**This var will always return to `<starting value>` when the gesture ends.**

While the gesture is happening, you can change this state by

```swift
var theGesture: some Gesture {
    return TapGesture(count: 2)
        .updating($myGestureState) { value, myGestureState, transaction in
            myGestureState = /* usually something related to value */
        }
        .onEnded { value in /* do something */ }
}
```

- This `.updating` will cause the closure you pass to it to be called when the fingers move.
- The `value` argument to your closure is the same as with .onEnded (the state of the fingers).
- The `transaction` argument has to do with animation.
- The `myGestureState` argument to your closure is essentially your `@GestureState`. This is the _only_ place you can change your `@GestureState`!

There’s a simpler version of `.updating` if you don’t need to track any special `@GestureState`.

```swift
var theGesture: some Gesture {
    return TapGesture(count: 2)
        .onChanged { value in
            /* do something with value (which is the state of the fingers) */
        }
        .onEnded { value in /* do something */ }
}
```

This makes sense only if what you’re doing is related directly to the actual finger positions.

---

←Previous: [Lecture 7: Multithreading EmojiArt](Lecture%207.md)

→Next: [Lecture 9: Data Flow](Lecture%209.md)
