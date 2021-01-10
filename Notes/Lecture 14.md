# Lecture 14: UIKit Integration

- [1. Views in UIKit](#1-views-in-uikit)
- [2. Integration](#2-integration)
  - [2.1 Delegation](#21-delegation)
  - [2.2 Representables](#22-representables)

## 1. Views in UIKit

- No MVVM either, MVC (Model - View - Controller) instead.

- In MVC, views are grouped together and controlled by a _Controller_.

- This Controller is the granularity at which you present views onscreen.

## 2. Integration

- Two points of integration for SwiftUI to UIKit: `UIViewRepresentable` and `UIViewControllerRepresentable`.

- The main work involved is interfacing with the given view or controller’s API.

### 2.1 Delegation

- UIKit is based on object-oriented technology.

- Objects (controllers and views) often _delegate_ some of their functionality to other objects.

- They do this by having a `var` called `delegate`, which is constrained via a `protocol` with all the delegatable functionality.

### 2.2 Representables

- `UIViewRepresentable` and `UIViewControllerRepresentable` are SwiftUI `View`s, they have 5 main components:

  - a function which creates the UIKit thing in question (view or controller)

    ```swift
    func makeUIView{Controller}(context: Context) -> view/controller
    ```

  - a function which updates the UIKit thing when appropriate (bindings change, etc.)

    ```swift
    func updateUIView{Controller}(view/controller, context: Context)
    ```

  - a `Coordinator` object which handles any delegate activity that goes on

    ```swift
    func makeCoordinator() -> Coordinator // Coordinator is a don’t care for Representables
    ```

  - a `Context` (contains the `Coordinator`, your SwiftUI’s environment, animation transaction)

    ```swift
    // passed into the methods above
    ```

  - a “tear down” phase if you need to clean up when the view or controller disappears

    ```swift
    func dismantleUIView{Controller}(view/controller, coordinator: Coordinator)
    ```

---

←Previous: [Lecture 13: Persistence](Lecture%2013.md)
