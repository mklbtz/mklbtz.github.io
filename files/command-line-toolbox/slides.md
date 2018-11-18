## The Command Line Toolbox 🧰

### A Crash Course on building your own CLI tools

---

# Michael Bates

![left](/Users/mklbtz/Desktop/Swift Cloud Workshop/img/sass.jpeg)

Kentucky 🏇🥃
Swing Dance 💃🏾🕺🏻
[Learn Swift Louisville](https://www.meetup.com/learn-swift-louisville/) Organizer

Day job: Python & JS 🙁
CLI tools: Swift 🥰

---
# Goals

Learn Tips & Tricks

Discover Open Source Packages

Build your own tools!

---

# Command Lines Shells

Necessary 👍

Super-powerful 💪

Not great languages 👎

---

🏃‍♀️ Running Scripts

🔨 Building Interfaces

💬 Effective I/O

---

# 🏃‍♀️ Running Scripts

---

# 🏃‍♀️ Running Scripts

1. Single executable file
2. Swift Package Manager

---

# Single Executable File

```swift
//FoodPls.swift

print("🍔🍕🌭🥪🥗🍳🥧🌮🌯🍗🍝🍜🍣🍱🥡🍛🍺".randomElement()!)
```

---

# Single Executable File

```swift
//FoodPls.swift

print("🍔🍕🌭🥪🥗🍳🥧🌮🌯🍗🍝🍜🍣🍱🥡🍛🍺".randomElement()!)
```

```bash
> swift FoodPls.swift
🥡
```

---

# Single Executable File

```swift
//FoodPls.swift

print("🍔🍕🌭🥪🥗🍳🥧🌮🌯🍗🍝🍜🍣🍱🥡🍛🍺".randomElement()!)
```

```bash
> swift FoodPls.swift
🥡
> foodpls
🌭
```

---

# Getting Fancy

1.  `chmod +x FoodPls.swift`

^
First: mark as executable

---

# Getting Fancy

1.  `chmod +x FoodPls.swift`
2.  `#!/usr/bin/xcrun swift`

^
add funny comment — shebang
This tells the shell

---

# Getting Fancy

1.  `chmod +x FoodPls.swift`
2.  `#!/usr/bin/xcrun swift`
3.  `cp FoodPls.swift /usr/local/bin/foodpls`

---

# Getting Fancy

1.  `chmod +x FoodPls.swift`
2.  `#!/usr/bin/xcrun swift`
3.  `cp FoodPls.swift /usr/local/bin/foodpls`

```bash
> foodpls
🍕
```

---

# Swift Package Manger
Executable target

---

# Swift Package Manger
Executable target — from scratch

```
> xcrun swift package init --type=executable
```

---

# Swift Package Manger
Executable target — existing package

```
targets: [
	.target(name: "foodpls", dependencies: []),
	// ...
]

// Sources/foodpls/main.swift
```

---

# Swift Package Manager
"Installing" the binary

```
> swift build
> cp .build/debug/foodpls /usr/local/bin/
```

---

# Marathon 🏃 
### by John Sundell<br/>[github.com/JohnSundell/Marathon](github.com/JohnSundell/Marathon)

---

# Marathon 🏃 

✔️ Write, run, and install single-file scripts

✔️ Install dependencies

---
# Marathon 🏃‍♂️

```
> marathon run FoodPls.swift
🥗
```

^
Install your dependencies
Build and run 
All in one shot

---
# Marathon 🏃‍♂️

```
> marathon edit FoodPls.swift
🏃  Updating packages...
✏️  Opening foodpls.xcodeproj/
```

^ 
Generate Xcode project…
- use autocomplete
- see build errors

---
# Marathon 🏃‍♂️

```
> marathon install FoodPls.swift 
🏃  Compiling script...
    Installing binary...
💻  FoodPls.swift installed at /usr/local/bin/foodpls
```

^ Install globally 

---
# Marathon 🏃‍♂️

```swift
import Files // marathon:https://github.com/JohnSundell/Files.git
```

^
Declare dependencies

---
# Marathon 🏃‍♂️

```swift
import Files // marathon:https://github.com/JohnSundell/Files.git
```

```
> marathon add https://github.com/JohnSundell/Files.git 
```

^
Global dependencies

---
# Marathon 🏃‍♂️

``` 
> marathon install https://example.com/script.swift
```

GitHub Gists: 👍

^
Anywhere on the internet
Only single-file scripts
Distribute through GitHub gists
Next: tool to install executables from any swift package

---
# Mint 🌱 
### by Yonas Kolb<br/>[github.com/yonaskolb/mint](github.com/yonaskolb/mint)

^
Homebrew for swift packages

---
# Mint 🌱 
Install executables from any Swift Package

- Carthage
- SwiftLint
- Sourcery
- Your own tools!

---
# Mint 🌱 

```
> mint install realm/SwiftLint

🌱  Finding latest version of SwiftLint
🌱  Resolved latest version of SwiftLint to 0.28.0
🌱  Cloning https://github.com/realm/SwiftLint.git 0.28.0...
🌱  Building SwiftLint Package with SPM...
🌱  Installing SwiftLint...
🌱  Installed SwiftLint 0.28.0
🌱  Linked swiftlint 0.28.0 to /usr/local/bin.

> swiftlint version
0.28.0
```

^
Latest version of swift lint
Benefits:
- any tagged version
- no waiting on maintainers to update

---
# Mint 🌱 

```bash
> mint run realm/SwiftLint@0.22.0 swiftlint
```

^
Run once without installing
Specific version

---
# Mint 🌱 
Mintfile

```
Carthage/Carthage
realm/SwiftLint
krzysztofzablocki/Sourcery@0.15.0
...
```

Better than a readme 👍

^
existing projects?
lots of dependencies?
Useful for bootstrapping new devs
Don't use readme

---
# Gotchas — Mint 🌱 and Marathon 🏃‍♂️
Building from source

Check your version

`Swiftenv` considered harmful:
`Package.swift not found`

---
# 🔨 Building Interfaces

---
# 🔨 Building Interfaces

Complex Behavior + Good UI = 🏆

---
# 🔨 Building Interfaces

Complex Behavior + Good UI = 🏆

GUI 👉 Animations
CLI 👉 Sub-commands

---
# 🔨 Building Interfaces

```bash
> todos add "buy milk"
```

---
# 🔨 Building Interfaces

```bash
> todos add "buy milk"
```

1. DIY sub-commands
2. Packages  

---
# DIY Sub-Commands

```swift
let args = CommandLine.arguments.dropfirst()
```

---
# DIY Sub-Commands

```swift
let args = CommandLine.arguments.dropfirst()
```

`dropFirst`: removes program name

---
# DIY Sub-Commands

```swift
let args = CommandLine.arguments.dropfirst()
let cmd = args[0]
```
👎

---
# DIY Sub-Commands

```swift
let args = CommandLine.arguments.dropfirst()

enum Command: String {
  case add // rm, list, etc.
}

let cmd = args.first.map(Command(rawValue:))
```

---
# DIY Sub-Commands

```swift
switch cmd {
case nil:
  fatalError("Unrecognized command")
case .add: 
  addTodo(title: CommandLine.arguments[1])
}
```

---
# DIY Sub-Commands

```swift
switch cmd {
case nil:
  fatalError("Unrecognized command")
case .add: 
  addTodo(title: CommandLine.arguments[1])
}
```

```
> todos add "buy milk"
```

^
Good for: simple scripts, few commands
Doesn't scale

---
# DIY Sub-Commands

Good for simple scripts 👍

Doesn't scale well 👎

Manual type conversion 👎 

---
# DIY Sub-Commands

```
> todos help
Available commands:
   add    Create a new task
   do     Complete tasks by ID
   edit   Change the title of a task
   ls     List outstanding tasks
   rm     Remove tasks
   undo   Un-complete tasks by ID
```

See mklbtz/finch for a full implementation of this!

^
Each command has different options!

---

# Commander
### by Kyle Fuller<br/>[github.com/kylef/Commander](github.com/kylef/Commander)

---
# Commander

```swift
import Commander

Group {
  $0.command("add") { (title: String) in
    addTask(title: title)
  }
}.run()
```

---
# Commander

```swift
import Commander

Group {
  $0.command("add") { (title: String) in
    addTask(title: title)
  }
}.run()
```

```
> todos add "buy milk"
```

---
# Commander

Type inference 👌

Good for medium complexity 👍

Automatic Numeric & Array conversion 👍

---
# Commandant
### by Carthage<br/>[github.com/Carthage/Commandant](github.com/Carthage/Commandant)
^
object-oriented approach

---
# Commandant

```swift
import Commandant

let commands = CommandRegistry<String>()

commands.register(AddCommand(manager: try TaskManager()))

commands.register(HelpCommand(registry: commands))

commands.main(defaultVerb: "help") { error in
  print(error)
}
```

^
Similar process

---
# Commandant

```swift
struct AddCommand: CommandProtocol {
  let verb = "add"
  let function = "Create a new task"

  func run(_ options: Options) -> Result<Void, String> {
    // ...
  }
}
```

^
make new types

---
# Commandant

```swift
extension AddCommand {
  struct Options: OptionsProtocol {
    let title: String

    static func evaluate(_ m: CommandMode)
      -> Result<Options, CommandantError<String>> {
      return Options.init
        <*> m <|* Argument<String>(usage: "Title for task")
    }
  }
}
```

^
defines the kind of arguments
evaluate function where you parse arguments
Funky operators

---
# Commandant

```swift
extension AddCommand {
  struct Options: OptionsProtocol {
    let title: String

    static func evaluate(_ m: CommandMode) 
      -> Result<Options, CommandantError<String>> {
      return Options.init
        <*> m <|* Argument<String>(usage: "Title for task")
    }
  }
}
```

```
> todos add "buy milk"
```

---
# Commandant

Good for complex tools with lots of options 👍

Battle-tested by Carthage 👍

Custom operators 👌

^
SPM has similar setup

---
# Beak 🐦
### by Yonas Kolb<br/>[github.com/yonaskolb/beak](github.com/yonaskolb/beak)

---
# Beak 🐦

Static-analysis with SourceKit

Generated interface & help

Dependency management like Mint 🌱

^
Zero-config

---
# Beak 🐦

```swift
// beak.swift

/// Create a new task
public func add(title: String) {}
```

---
# Beak 🐦

```swift
// beak.swift

/// Create a new task
public func add(title: String) {}
```

```
> beak list
Functions:
  add: Create a new task

> beak run add --title="buy milk"
```

^
Comment strings -> help text
Keyword args become flags

---
# Beak 🐦

```swift
// beak.swift

/// Create a new task
public func add(_ title: String) {}
```

```bash
> beak list
Functions:
  add: Create a new task

> beak run add "buy milk"
```

^
Positional args 

---
# Beak 🐦

Great for task-runners 👍

Use with Mint for super-productivity 🤩

^
Recreate NPM functionality

---
# 💬 Effective I/O

---
# 💬 Effective I/O

1. stdin
2. stderr
3. Exit codes
4. Files

---
# stdin

```swift
func readline() -> String?
```

---
# stdin

```swift
print("What is your name?")
print("> ", terminator: "")

let name = readLine() ?? "stranger"

print("Hello, \(name)")
```

---
# stdin

```swift
print("What is your name?")
print("> ", terminator: "")

let name = readLine() ?? "stranger"

print("Hello, \(name)")
```

```
What is your name?
> Michael
Hello, Michael
```

---
# stdin

```swift
print("What is your name?")
print("> ", terminator: "")

let name = readLine() ?? "stranger"

print("Hello, \(name)")
```

```
What is your name?
> ^D
Hello, stranger
```

---
# stdin

```swift
while let input = readLine() {
  // ...
}
```

---
# stdin

```swift
sequence(first: "", next: { _ in 
  readLine(strippingNewline: false) 
}).joined()
```

^
Get all input for JSON etc.

---
# stderr

^
No errorPrint function :( 
Let's build one!

---

# stderr

```swift
func print<Target>(_: Any..., to: inout Target) where Target : TextOutputStream
```

^
Only conformance is string itself

---
# stderr

```swift
func print<Target>(_: Any..., to: inout Target) where Target : TextOutputStream
```

```swift
/// Returns the file handle associated with the standard error file
class var standardError: FileHandle { get }
```

---
# stderr

```swift
extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    if let data = string.data(using: .utf8) {
	    self.write(data)
    }
  }
}
```

---
# stderr

```swift
func errorPrint(_ item: Any) {
  var stderr = FileHandle.standardError
  print(item, to: &stderr)
}
```

---
# Error Codes

^  
bash logic
Express errors

---
# Error Codes

```swift
fatalError("oops!")
```

Lots of stack dump info 👎

---
# Error Codes

```swift
import Darwin
exit(-1)
```

---
# Files
### by John Sundell<br/>[github.com/JohnSundell/Files](github.com/JohnSundell/Files)

---
# Files
Wrapper around Foundation APIs 👍

Very convenient to use 👍

---
# Files

```swift
let folder = try Folder(path: "/users/john/folder")

let file = try folder.createFile(named: "file.json")
try file.write(string: "{\"hello\": \"world\"}")

try file.delete()
try folder.delete()
```

---
# Files

```swift
for file in try Folder(path: "MyFolder").files {
    try file.rename(to: file.nameWithoutExtension.capitalized)
}
```

---
# Files

```swift
let origin = try Folder(path: "/users/john/folderA")
let target = try Folder(path: "/users/john/folderB")
try origin.files.move(to: target)
```

---
# Files

✔️ SPM

✔️ Carthage

✔️ CocoaPods

---
# Wrap-up

---
# Wrap-up

1. 🏃‍♀️ Running Scripts
  - single-files & packages
  - JohnSundell/Marathon 🏃‍♂️
  - yonaskolb/Mint 🌱

---
# Wrap-up
2. Building Interfaces
  - DIY
  - kylef/commander
  - Carthage/Commandant
  - yonaskolb/beak

---
# Wrap-up
3. Effective I/O
  - stdin
  - stderr
  - error codes
  - JohnSundell/Files

---
## The Command Line Toolbox 🧰
### A Crash Course on building your own CLI tools<br><br>Michael Bates — [@mklbtz](https://twitter.com/mklbtz) — [mklbtz.com](http://mklbtz.com)