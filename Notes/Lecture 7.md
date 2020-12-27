# Lecture 7: Multithreading EmojiArt

- [1. Colors and Images](#1-colors-and-images)
  - [1.1. `Color` vs. `UIColor`](#11-color-vs-uicolor)
  - [1.2. `Image` vs. `UIImage`](#12-image-vs-uiimage)
- [2. Multithreading](#2-multithreading)
  - [2.1. Queues](#21-queues)
  - [2.2. GCD (Grand Central Dispatch)](#22-gcd-grand-central-dispatch)

## 1. Colors and Images

### 1.1. `Color` vs. `UIColor`

- `Color`

  - SwiftUI varies by context.
  - A color-specifier, can also act like a `ShapeStyle` or `View`.

- `UIColor`

  - Is used to manipulate colors.
  - Has many more built-in colors than `Color`, including "system-related" colors.
  - Can be interrogated and can convert between color spaces.

### 1.2. `Image` vs. `UIImage`

- `Image`

  - Primarily serves as a `View`.
  - Is _not_ a type for vars that hold an image (i.e. a jpeg or gif or some such).
  - Access images in Assets.xcassets by name using `Image(_ name: String)`.
  - You can control the size of system images (in SF Symbols app) with `.imageScale()` view modifier.

- `UIImage`

  - Is the type for actually creating/manipulating images and storing in vars.
  - Powerful representation of an image.
  - Multiple file formats, transformation primitives, animated images, etc.
  - Use `Image(uiImage:)` to display.

## 2. Multithreading

- It is **NEVER** okay for a mobile application UI to be unresponsive to the user.

### 2.1. Queues

- A queue is just a bunch of blocks of code, lined up, waiting for a thread to execute them.

- The system takes care of providing/allocating threads to execute code off these queues.

- We specify the blocks of code waiting in a queue using _closures_ (aka functions as arguments).

- Main Queue

  - The most important queue of iOS.
  - It is the queue that has all the blocks of code that might muck with the UI.
  - It is an unequivocal **error** to do UI (directly or indirectly) off the main queue.

- Background Queues

  - These are where we do any long-lived, non-UI tasks.
  - The system has a bunch of threads available to execute code on these background queues.
  - The main queue will always be higher priority than any of the background queues.

### 2.2. GCD (Grand Central Dispatch)

- The base API for doing all this queue stuff.

- Two fundamental tasks:

  1. getting access to a queue
  2. plopping a block of code on a queue

- Ways to create a queue:

  - `DispatchQueue.main`: the main queue where all UI code must be posted
  - `DispatchQueue.global(qos: QoS)`: a non-UI queue with a certain quality of service

    `qos` (quality of service) is one of the following:

    - `.userInteractive`: do this fast, the UI depends on it!
    - `.userInitiated`: the user just asked to do this, so do it now
    - `.utility`: this needs to happen, but the user didn't just ask for it
    - `.background`: maintenance tasks (cleanups, etc.)

- Plopping a Closure onto a Queue

  Two basic ways:

  ```swift
  let queue = DispatchQueue.main // or DispatchQueue.global(qos:)
  queue.async { /* code to execute on queue */ }
  queue.sync { /* code to execute on queue */ }
  ```

  `sync` **blocks** waiting for that closure to be picked off by its queue and completed.

- Nesting

  ```swift
  DispatchQueue(global: .userInitiated).async {
      // do something that might take a long time
      DispatchQueue.main.async {
          // update the UI
      }
  }
  ```

- Asynchronous API

  - A lot of asynchronous iOS API is at a higher level, for example `URLSession`.
  - If you want to do UI in response, you'll need `DispatchQueue.main.async { }`.

---

←Previous: [Lecture 6: Animation](Lecture%206.md)
