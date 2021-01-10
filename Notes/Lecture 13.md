# Lecture 13: Persistence

- [1. Persistence](#1-persistence)
  - [1.1. `UserDefaults`](#11-userdefaults)
  - [1.2. `Codable` / JSON](#12-codable--json)
  - [1.3. `UIDocument`](#13-uidocument)
  - [1.4. Core Data](#14-core-data)
  - [1.5. Cloud Kit](#15-cloud-kit)
  - [1.6. `FileManager` / `URL` / `Data`](#16-filemanager--url--data)
- [2. Cloud Kit](#2-cloud-kit)
- [3. File System](#3-file-system)
  - [3.1. Sandbox](#31-sandbox)
  - [3.2. `URL`](#32-url)
  - [3.3. `Data`](#33-data)
  - [3.4. `FileManager`](#34-filemanager)

## 1. Persistence

- Storing stuff between application launches

  - `UserDefaults`
  - `Codable` / JSON
  - `UIDocument`
  - Core Data
  - Cloud Kit
  - File system

### 1.1. `UserDefaults`

- Simple

- Limited (Property Lists only)

- Small

### 1.2. `Codable` / JSON

Clean way to turn almost any data structure into an interoperable/storable format.

### 1.3. `UIDocument`

- Integrates the Files app and "user perceived documents" into your application.

- UIKit-based

### 1.4. Core Data

- Powerful

- Object-Oriented

- Elegant SwiftUI integration

### 1.5. Cloud Kit

- Storing data into a database in the cloud (i.e. on the network), which thus appears on all of the user's devices.

- Has its own "networked UserDefaults-like thing".

- Plays nicely with Core Data.

### 1.6. `FileManager` / `URL` / `Data`

Storing things in the Unix file system that underlies iOS.

## 2. Cloud Kit

- A database with very basic "database" operations in the cloud.

- Since it's on the network, accessing the database could be slow or even impossible.

- Asynchronous programming.

- Important Components

  - Record Type: like a `class` or `struct`
  - Fields: like `var`s in a `class` or `struct`
  - Record: an "instance" of a Record Type
  - Reference: a "pointer" to another Record
  - Database: a place where Records are stored
  - Zone: a sub-area of a Database
  - Container: collection of Databases
  - Query: a Database search
  - Subscription: a "standing Query" which sends push notifications when changes occur

- Dynamic Schema Creation

  When you store a record with a new, never-before-seen Record Type, it will create that type. Or if you add a Field to a Record, it will automatically create a Field for it in the database.

  _This only works during Development, not once you deploy to your users._

- Create a record in a database

  ```swift
  let db = CKContainer.default.publicCloudDatabase // or .sharedCloudDatabase / .privateCloudDatabase
  let tweet = CKRecord(“Tweet”)
  tweet[“text”] = “140 characters of pure joy”
  let tweeter = CKRecord(“TwitterUser”)
  tweet[“tweeter”] = CKReference(record: tweeter, action: .deleteSelf)
  db.save(tweet) { (savedRecord: CKRecord?, error: NSError?) -> Void in
      if error == nil {
          // the record is saved successfully
      } else if error?.errorCode == CKErrorCode.NotAuthenticated.rawValue {
          // tell user he or she has to be logged in to iCloud for this to work!
      } else {
          // report other errors (there are 29 different CKErrorCodes!)
      }
  }
  ```

- Query for records in a database

  ```swift
  let predicate = NSPredicate(format: “text contains %@“, searchString)
  let query = CKQuery(recordType: “Tweet”, predicate: predicate)
  db.perform(query) { (records: [CKRecord]?, error: NSError?) in
      if error == nil {
          // records will be an array of matching CKRecords
      } else if error?.errorCode == CKErrorCode.NotAuthenticated.rawValue {
          // tell user he or she has to be logged in to iCloud for this to work!
      } else {
          // report other errors (there are 29 different CKErrorCodes!)
      }
  }
  ```

- Standing Queries (aka Subscriptions)

  All you do is register an `NSPredicate` and whenever the database changes to match it, it will send push notifications.

## 3. File System

- Your application sees iOS file system like a normal Unix filesystem

  - It starts at `/`.
  - There are file protections.
  - You can only read and write in your application's "sandbox".

### 3.1. Sandbox

- Why?

  - Security: no one else can damage your application
  - Privacy: no other applications can view your application's data
  - Cleanup: when delete an application, everything it has ever written goes with it

- What's in the sandbox

  - Application directory: executable, `.jpg`s. Not writeable.
  - Documents directory: Permanent storage created by and always visible to the user.
  - Application Support directory: Permanent storage not seen directly by the user.
  - Caches directory: Store temporary files here (this is not backed up).
  - Other directories...

### 3.2. `URL`

- Getting a path to these special sandbox directories

  ```swift
  let url: URL = FileManager.default.url(
      for directory: FileManager.SearchPathDirectory.documentDirectory,
      in domainMask: .userDomainMask // always .userDomainMask on iOS
      appropriateFor: nil, // only meaningful for "replace" file operations
      create: true // whether to create the system directory if it doesn’t already exist
  )
  ```

- Building on top of these system paths

  ```swift
  func appendingPathComponent(String) -> URL
  func appendingPathExtension(String) -> URL // e.g. "jpg"
  ```

- Finding out about what's at the other end of a URL

  ```swift
  var isFileURL: Bool // is this a file URL (whether file exists or not) or something else?
  func resourceValues(for keys: [URLResourceKey]) throws -> [URLResourceKey:Any]?
  ```

  Example keys: `.creationDateKey`, `.isDirectoryKey`, `.fileSizeKey`

### 3.3. `Data`

- Reading binary data from a URL

  ```swift
  init(contentsOf: URL, options: Data.ReadingOptions) throws
  ```

  The options are almost always [].

- Writing binary data to a URL

  ```swift
  func write(to url: URL, options: Data.WritingOptions) throws -> Bool
  ```

  The options can be things like `.atomic` (write to tmp file, then swap) or `.withoutOverwriting`.

### 3.4. `FileManager`

- Provides utility operations. e.g. `fileExists(atPath: String) -> Bool`

- Can also create and enumerate directories; move, copy, delete files; etc.

- Thread safe (as long as a given instance is only ever used in one thread).

- Also has a delegate you can set which will have functions called on it when things happen.

- ...

---

←Previous: [Lecture 12: Core Data](Lecture%2012.md)

→Next: [Lecture 14: UIKit Integration](Lecture%2014.md)
