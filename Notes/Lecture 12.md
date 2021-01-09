# Lecture 12: Core Data

- [1. Core Data](#1-core-data)
- [2. SQL vs. OOP](#2-sql-vs-oop)
- [3. Map](#3-map)
- [4. Features](#4-features)
- [5. SwiftUI Integration](#5-swiftui-integration)

## 1. Core Data

- Object-Oriented Database

## 2. SQL vs. OOP

- Core Data framework does the actual storing using SQL.

- But we interact with our data in an entirely object-oriented way.

- We don't need to know a single SQL statement to do it.

## 3. Map

- The heart of Core Data is creating a map.

- It is a map between the objects/`var`s we want and "tables and rows" of a relational database.

- Xcode will generate `class`es behind the scenes for the objects/`var`s we specified in the map. We can use `extension` to add our own methods and computed `var`s to those `class`es. These objects then serve as the source of data for the elements of our UI.

## 4. Features

- Creating objects

- Changing the values of their `var`s (including establishing relationships between objects)

- Saving the objects

- Fetching objects based on specific criteria

- Lots of database-y features like optimistic locking, undo management, etc.

## 5. SwiftUI Integration

- The objects we create in the database are `ObservableObject`s.

- Property wrapper `@FetchRequest`, which essentially represents a "standing query" that is constantly being fulfilled, fetches objects for us.

```swift
@Environment(\.managedObjectContext) var context
let flight = Flight(context: context)
flight.aircraft = "B737"
let ksjc = Airport(context: context)
ksjc.icao = "KSJC"
flight.origin = ksjc // this would add flight to ksjc.flightsFrom too
try? context.save()

let request = NSFetchRequest<Flight>(entityName: "Flight")
request.predicate = NSPredicate(format: "arrival < %@ and origin = %@", Date(), ksjc)
request.sortDescriptors = [NSSortDescriptor(key: “ident”, ascending: true)]
// past KSJC flights sorted by ident
// flights is nil if fetch failed, [] if no such flights, otherwise [Flight]
let flights = try? context.fetch(request)
```

- SwiftUI

  - `@ObservedObject var flight: Flight`
  - Property wrapper

    ```swift
    @FetchRequest(entity:sortDescriptors:predicate:) var flights: FetchedResults<Flight>
    @FetchRequest(fetchRequest:) var airports: FetchedResults<Airport>
    ```

    `FetchedResults<Flight>` is a `Collection` (not quite an `Array`) of Flight/Airport objects. `flights` and `airports` will _continuously_ update as the database changes

---

←Previous: [Lecture 9: Data Flow](Lecture%209.md)

→Next:
