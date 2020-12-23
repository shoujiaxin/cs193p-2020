# Lecture 6: Animation

- [1. Property Observers](#1-property-observers)
- [2. `@State`](#2-state)
- [3. Animation](#3-animation)
  - [3.1. Implicit Animation](#31-implicit-animation)
  - [3.2. Explicit Animation](#32-explicit-animation)
  - [3.3. Transitions](#33-transitions)
  - [3.4. `.onAppear`](#34-onappear)
  - [3.5. Shape and ViewModifier Animation](#35-shape-and-viewmodifier-animation)

## 1. Property Observers

- A way to "watch" a `var` and execute code when it changes.

- The syntax can look a lot like a computed var, but it is _completely unrelated_ to that

  ```swift
  var isFaceUp: Bool {
      willSet {
          if newValue {
              startUsingBonusTime()
          } else {
              stopUsingBonusTime()
          }
      }
  }
  ```

  Inside here, `newValue` is a special variable (the value it's going to get set to).

- There's also a `didSet` (inside that one, `oldValue` is what the value used to be).

## 2. `@State`

- View structs are completely and utterly read-only.

- Mark vars used for temporary state with `@State`

  ```swift
  @State private var somethingTemporary: SomeType
  ```

  This is actually going to make some space _in the heap_ for this.

- Changes to `@State` var _will cause View to redraw if necessary_

## 3. Animation

- A smoothed out portrayal in UI over a period of time (which is configurable and usually brief) of a _change_ that has _already happened_ (very recently).

- Can only animate _changes_ to Views in containers that are already on screen (CTAAOS).

  - The appearance and disappearance of Views in CTAAOS.
  - Changes to the arguments to `Animatable` view modifiers of Views that are in CTAAOS.
  - Changes to the arguments to the creation of Shapes inside CTAAOS.

- Two ways to make an animation "go"

  - By using the view modifier `.animation(Animation)` (implicitly)
  - By wrapping `withAnimation(Animation) { }` around code that might change things (explicitly)

### 3.1. Implicit Animation

- "Automatic animation."
- All `ViewModifier` arguments will _always_ be animated.
- The changes are animated with the duration and "curve" you specify.

```swift
Text("👻")
    .opacity(scary ? 1 : 0)
    .rotationEffect(Angle.degrees(upsideDown ? 180 : 0))
    .animation(Animation.easeInOut)
```

_A container just propagates the `.animation` modifier to all the Views it contains._

- Animation Curve

  The kind of animation controls the rate at which the animation "plays out".

  - `.linear`: Consistent rate throughout.
  - `.easeInOut`: Starts out the animation slowly, picks up speed, then slows at the end.
  - `.spring`: Provides "soft landing" (a "bounce") for the end of the animation.

### 3.2. Explicit Animation

- Create an animation session during which all eligible changes made as a result of executing a block of code will be animated together.

  ```swift
  withAnimation(.linear(duration: 2)) {
      // do something that will cause ViewModifier/Shape arguments to change somewhere
  }
  ```

  This is imperative code in View, it will appear in closures like `.onTapGesture`.

- Almost always wrapped around calls to ViewModel Intent functions. And also wrapped around things that only change the UI like "entering editing mode".

- **Explicit animations DO NOT override an implicit animation.**

### 3.3. Transitions

- Specify how to animate the arrival/departure of Views in CTAAOS.

- A transition is nothing more than a _pair_ of ViewModifiers.

  - One of the modifiers is the "before" modification of the View that's on the move.
  - The other modifier is the "after" modification of the View that's on the move.

- A transition is just a version of a "changes in arguments to view modifiers" animation.

- `.transition()` does NOT get redistributed to a container's content Views. `Group` and `ForEach` DO distribute `.transition()` to their content Views, however.

- `.transition()` is just _specifying_ what the ViewModifiers are, it doesn't cause any animation to occur.

- **Transitions do not work with implicit animations**, only explicit animations. They only happen when an explicit animation is going on.

- All the transition API is "type erased". We use the struct `AnyTransition` which erases type info for the underlying ViewModifiers.

  - `AnyTransition.opacity`: fades the View in and out as it comes and goes
  - `AnyTransition.scale`: uses `.frame` modifier to expand/shrink the View as it comes and goes
  - `AnyTransition.offset(CGSize)`: use `.offset` modifier to move the View as it comes and goes
  - `AnyTransition.modifier(active:identity:)`: provide the two ViewModifiers to custom transition

- `AnyTransition` struct has a `.animation(Animation)` which can be used to override the animation for a transition. (This is _NOT_ an implicit animation!)

  ```swift
  .transition(.opacity.animation(.linear(duration: 20))) // a VERY slow fade
  ```

### 3.4. `.onAppear`

- Transitions only work on Views that are in CTAAOS.

- `.onAppear { }` executes a closure any time a View appears on screen (there's also `.onDisappear { }`).

### 3.5. Shape and ViewModifier Animation

- All actual animation happens in Shapes and ViewModifiers.

- The animation system divides the animation duration up into little pieces.

- The communication with the animation system happens (both ways) with a single var, which is the only thing in the `Animatable` protocol

  ```swift
  var animatableData: Type
  ```

  `Type` has to implement the protocol `VectorArithmetic`. It is almost always a floating point number (`Float`, `Double` or `CGFloat`).

- `AnimatablePair` combines two `VectorArithmetic`s into one `VectorArithmetic`

- The setting of `animatableData` is the animation system telling the Shape/VM which piece to draw.

  The getting of `animatableData` is the animation system getting the start/end points of an animation.

- `animatableData` is usually a computed var

---

←Previous: [Lecture 5: ViewBuilder Shape ViewModifier](Lecture%205.md)
