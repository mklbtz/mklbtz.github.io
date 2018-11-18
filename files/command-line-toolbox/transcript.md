So if you've been a developer for any amount of time you've probably used a command line. And if you have used a command line for any amount of time you've probably thought, "gee, I do X a whole bunch. I wonder if I can automate it…". But the thing about command lines is they kinda suck as programming languages. I mean, have you _seen_ `awk`? I'm pretty sure it is short for "awkward". 

But you know what *is* a great language? Swift is!. I've written several CLI tools in Swift over the years. Everything from little helper scripts to a full on task manager. So I want to share with you some of the tricks I've learned writing my own command line tools and show off a few packages that really make scripting a breeze. This will be a crash-course that I hope will empower you to build your own CLI tools and share them with the world. 

I'm going to cover these topics…

1. 🏃‍♀️ Running Scripts
2. 🔨 Building Interfaces
3. 💬 Effective I/O

# Running Scripts

There are two ways to run Swift from the command line. One is to use a single executable file. The other is to use the swift package manager. 

## Executable files

This first way is by far the simplest. Say we've got a single file, a script, that we want to run from the command line. Let's say it prints out a random food emoji to help you decide on lunch. (Yes, this is a thing I've done. Yes all my coworkers think I am ridiculous.) 

```swift
print("🍔🍕🌭🥪🥗🍳🥧🌮🌯🍗🍝🍜🍣🍱🥡🍛🍺".randomElement()!)
```

Of course we can invoke the swift compiler directly…

```bash
> xcrun swift FoodPls.swift
🥡
```

…but we can do better. We want it to use this tool from anywhere and give it a fancy name like `foodpls`! Since the Mac is a unix system, we just need three things to make this happen.

First, mark the file as executable using `chmod +x FoodPls.swift`.

Second, add this funny comment — called a shebang — to the top of the file. 
This tells the shell what program is used to execute this file. 
`#!/usr/bin/xcrun swift`

Finally, rename the file and move it somewhere in your `PATH`. 
A commonly used location is `/usr/local/bin`. 
This makes it usable from anywhere.
`cp FoodPls.swift /usr/local/bin/foodpls`

```bash
> foodpls
🌭
```

This causes Swift to interpret or recompile the script with each invocation. There's a performance hit for that, but it's not very noticeable as long as the file isn't crazy long or complex. Maybe you want to convert a Playground into something reusable, this is the way to do it. 

This approach does limit you to only using one file. For more complex projects, or if the compilation delay is too annoying, you want to use the swift package manager. 

## Executable Targets

If you're starting from scratch, you can initialize your package as an executable-type. 

```bash
> xcrun swift package init --type=executable
```

If you've already got a working package that you want to add a command line tool to, you just need to add an executable target to your Package manifest and a corresponding main.swift file.

```
targets: [
	.target(name: "foodpls", dependencies: []),
]
// Sources/foodpls/main.swift
```

When you build the package, you can copy the output binary into our `PATH`, just like before. 

```bash
> cp .build/debug/foodpls /usr/local/bin/
```

In principle that's all we have to do, but it can be tedious to manage your installations manually. Especially if you start writing a bunch of these. This is where I want to introduce the first community package, Marathon 🏃 by John Sundell. 

## Marathon

Marathon is a tool that makes it super easy to write, run, and install swift scripts. It's based on SPM so it can install dependencies for you as well. This is how you run a script:

```
> marathon run FoodPls.swift
🥗
```

Marathon also has a convenience for editing your script. 
This command will generate an Xcode project for you (using SPM), so you can use autocomplete, see build errors, and all that. 
Normally opening a single file in Xcode doesn't give you these features. 

```bash
> marathon edit FoodPls.swift
🏃  Updating packages...
✏️  Opening foodpls.xcodeproj/

ℹ️  Marathon will keep running, in order to commit any changes you make in Xcode back to the original script file
   Press the return key once you're done
```

To install your script globally, just run this command.

```bash
> marathon install FoodPls.swift 
🏃  Compiling script...
   Installing binary...
💻  FoodPls.swift installed at /usr/local/bin/foodpls
```

If you want to pull in a dependency for your script, you can add special comments, like this one. Marathon will install such dependencies when you run or install your script. 

```swift
import Files // marathon:https://github.com/JohnSundell/Files.git
```

You can also install dependencies globally, making them usable from all your scripts. 

```bash
> marathon add https://github.com/JohnSundell/Files.git 
```

Marathon also gives you a way to run swift scripts straight off the internet, GitHub or wherever.

```bash  
> marathon install https://example.com/script.swift
```

Again this only works with single-file scripts, though.

## Mint

There is a tool which lets you install the executables from any Swift package on GitHub. That package is called Mint 🌱 by Yonas Kolb. You can use it the way you would use Homebrew, but for Swift packages. Many tools you've probably used for iOS development, like Carthage and Sourcery and SwiftLint are installable with Mint since they work with SPM. This also means it is super simple to distribute your own tools! 

Another benefit to using Mint is you don't have to rely on maintainers to update their brew formula and you can install any tagged version of your favorite package. Homebrew only lets you install the latest version of a formula, generally.

Here's how you could install the latest SwiftLint…

```bash
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
Linting Swift files at paths
```

…or even run a specific version just once…

```bash
> mint run realm/SwiftLint@0.28.0 swiftlint
```

You can even add a list of dependencies to a `Mintfile` so that Mint can install them all in one go. Keeping a Mintfile in your project repos can help new developers get boot-strapped quickly. 

```
Carthage/Carthage
realm/SwiftLint
krzysztofzablocki/Sourcery@0.15.0
```

One thing to be wary of: since both of these Mint and Marathon build from source, so you might need to install different versions of Swift, depending on what features are being used. 

If you use Swiftenv by Kyle Fuller, you might see this completely misleading error: `Package.swift not found`. That just means Swiftenv doesn't have the right version installed. You can work around that by installing the right version or skipping swiftenv altogether. 

# Building Interfaces

Now that we know how to make our Swift projects runnable from the command line and install dependencies, we want to make something more interesting than a food-emoji-randomizer, as useful as that may be. 

When building a complex app, a good UI is critical to keeping it usable. We can apply the same treatments to our command line tools. We want them to be simple to use even if they are complicated under the hood. Often that means having a bunch of sub-commands for each feature or interaction, each with their own arguments, flags, and options. 

For the sake of example, let's try building a todo manager for the command line.   Or the interface for one, at least. We want to be able to add a todo like this:

```bash
> todos add "buy milk"
```

First, I want to show you how to use built-in Swift features to build something simple like this. Later, I'll show you a few packages that make it easy to build more complex interfaces.

## DIY

We start by getting the command line arguments. Notice that I'm dropping the first command line argument here. The first one is always the name of the program or file that's running and we don't need that. That's one gotcha to be aware of. 

```swift
let args = CommandLine.arguments.dropfirst()
```

Next we can write a raw-representable enum to cover all the commands. By making this enum backed by strings, we can use the raw-value initializer to do our "parsing".

```swift
enum Command: String {
  case add, rm, list // ...
}

let cmd = Command(rawValue: args[0])
```

Finally, we dispatch the appropriate function using a switch statement. We can cover the nil-case to show an error. 

```swift
switch cmd {
case nil:
  fatalError("Unrecognized command")
case .add: 
  addCommand(title: CommandLine.arguments[1])
// ...
}
```

All of this lets us run this command: `todos add "buy milk"`. The first word "add" becomes `Command.add` and "buy milk" gets passed to the implementation function. 
I like this approach for really simple scripts. Either for dispatching sub-commands like this or for capturing flags or options. 
It doesn't scale very well, though. In the future, we'll probably want our task manager to support a longer list of sub-commands, and this can get unwieldily quickly. 

```bash
> todos help
Available commands:
   add    Create a new task
   do     Complete tasks by ID
   edit   Change the title of a task
   ls     List outstanding tasks
   rm     Remove tasks
   undo   Un-complete tasks by ID
```

It also limits your input types to strings in every case. If you want to take numbers or booleans as input, you'll have to write even more boiler plate code. 
If you don't mind bringing in a dependency, I've got three different packages you can use to make complex command line interfaces with ease.

## Commander

The first one I want to introduce is Commander by Kyle Fuller. With Commander, we can recreate the same add-command functionality like this. In main.swift, we define a group to hold our sub-commands and at run-time Commander will parse the CLI arguments and invoke the correct command in the group.

```swift
// main.swift
import Commander
Group {
  $0.command("add") { (title: String) in
    // ...
  }
  // ...
}.run()
```

Just like before, we can run `todos add "buy milk"`. `add` gets matched to the "add" command and the callback is called with "buy milk" as the title argument.

It makes heavy use of type inference, so it's pretty clean, at least when the type-checker works. This might look familiar to those of you who've used the routing features in Kitura or Vapor, or even the Express framework in Nodejs. 

I'm showing a string input here, but you can also take numeric types and arrays.

```swift
	$0.command("math") { (x: Int, y: Int) in print(x + y) }
```

Commander doesn't make use of Codable in the way Kitura routing does, but it does have its own `ArgumentConvertible` protocol that serves that purpose. If you wanna get fancy and take some custom or aggregate types as input, you can do that.

I have found this works well for small-to-medium-sized tools. Particularly if your core functionality is in a different module and the CLI tool is just a thin wrapper around that. Even still, it's easy for the commands to get cluttered with implementation details.

## Commandant

So, for larger projects, there is a third option. Commandant by the Carthage team. 

Commandant takes a more object-oriented approach, so it might be a good choice for those of you who come from iOS and like to organize things into classes or structs.

It's a similar process as before: we register all our commands and tell Commandant to run. Here we can even specify a default command.

```swift
// main.swift
import Commandant
let commands = CommandRegistry<String>()

commands.register(AddCommand(manager: try TaskManager()))
// ...
commands.register(HelpCommand(registry: commands))

commands.main(defaultVerb: "ls") { error in
  print(error)
}
```

In Commandant, each command is a new type that conforms to a `CommandProtocol` and implements a `run` function and a `verb` string. 

```swift
struct AddCommand: CommandProtocol {
  let verb = "add"
  let function = "Create a new task"

  func run(_ options: Options) -> Result<Void, String> {
    // ...
  }
}
```

Commands can have a nested `Options` type that defines the kind of arguments the command accepts. Options has an evaluate function where you parse those argument strings into the proper type. You have to use these funky operators for the parsing stuff. It looks scary at first but it's easy to get the hang of. This is also where you can provide help text describing how to use the argument.

```swift
extension AddCommand {
  struct Options: OptionsProtocol {
    let title: String

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return Options.init
        <*> m <|* Argument<String>(usage: "The title for the new task")
    }
  }
}
```

Again, we can run `todos add "buy milk"`. The word "add" will invoke `AddCommand.run` and  "buy milk" becomes the `title` property on our options struct.

I think this is a good setup for larger projects or ones with many complex options that need to be explained in help. Carthage is built using this package. Also the Swift package manager uses a custom setup that's pretty similar to Commandant and it works well there. 

## Beak

Last but not least, I want to tell you about another tool I discovered recently. It's called Beak, by Yonas Kolb who makes Mint. What sets Beak apart is its use of SourceKit. Beak statically analyzes your code to generate the interface each time you run it. So literally all you have to do is expose a public function and beak takes care of the rest.

```swift
// beak.swift

/// Create a new task
public func add(title: String) {}
```

Comment strings get turned into help text.

```bash
> beak list
Functions:
  add: Create a new task
```

Keyword arguments get turned into flagged arguments. 

```bash
> beak run add --title="buy milk"
```

And positional arguments are also positional.

```swift
public func add(_ title: String) {}
```

```bash
> beak run add "buy milk"
```

And you can even use it in a shebang to make the file itself executable, if you want.

```
#!/usr/bin/env beak --path
```

It can install dependencies just like Mint, and it supports more than just strings as the argument types.

```
Todo
```

Beak was designed to be a task runner like NPM for node or rake for ruby. By default it looks for a file called beak.swift. With a Mintfile and a beak file, you can basically recreate everything that NPM does for node developers. 

# Effective I/O

Finally, I want to touch on standard I/O and file management. 

## STD I/O

For command line tools, the main way you talk to the user is using stdin, stdout, and stderr. Printing to stdout is dead simple and I'm sure you've all done it before. The other two require a bit more work. 

```swift
print("this is stdout!")
```

## stdin

Stdin is the way we can get information from users. Swift provides us with a function that reads one line of input at a time called readLine. 

```swift
func readline() -> String?
```

This function returns a string when the user types something and hits enter. For example, we can use print and readLine together to provide an interactive experience. We can ask for the user's name like this.

```swift
print("What is your name?")
print("> ", terminator: "")
let name = readLine() ?? "stranger"
print("Hello, \(name)")
```

If they type in their name, we can greet them. 

```
What is your name?
> Michael
Hello, Michael
```

If the user presses ^D instead of typing a response, readLine returns nil and we can provide an anonymous greeting. 

```
What is your name?
> ^D
Hello, stranger
```

You may also want to use stdin as a kind of data input. For example, if the user pipes in a file, you could use a while let loop to read every line one by one. Familiar tools like `echo` and `grep` operate on each line independently, so this would be an efficient way to recreate that.

```swift
while let input = readLine() {
  // ...
}
```

However, if you need all of stdin as one big string — maybe it's a JSON file and you need to parse it all at once — you can use this sequence function to join all the lines together. This also shows that you can tell readLine whether or not to strip out the newline character from the end.

```swift
sequence(first: "", next: { _ in 
  readLine(strippingNewline: false) 
}).joined()
```

## stderr 

When things go wrong, it's traditional for unix-y tools to print a message to stderr. Unfortunately this is not as simple as printing to stdout. There is no `errorPrint` function in Swift, so let's build one! To get this to work, we need to piece together two built-in features. 

Swift already provides an override of `print` that takes a TextOutputStream argument. It's used to print somewhere other than stdout, which is what we want. But, the only thing that conforms to TextOutputStream is String itself, so we can't use this yet.

```swift
func print<Target>(_: Any..., to: inout Target) where Target : TextOutputStream
```

Foundation has a FileHandle class which is a wrapper around file descriptors and lets you read and write data to them. It has a static property which gives you access to stderr as a file. 

```swift
/// Returns the file handle associated with the standard error file
class var standardError: FileHandle { get }
```

Perfect! To fit these pieces together, we can conform FileHandle to TextOutputStream by implementing the write method.

```swift
extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    if let data = string.data(using: .utf8) {
	    self.write(data)
		}
  }
}
```

And finally we can implement our errorPrint function by printing to stderr.

```swift
func errorPrint(_ item: Any) {
  var stderr = FileHandle.standardError
  print(item, to: &stderr)
}
```

I really hope this functionality — or at least the FileHandle conformance — will get added to Foundation soon. It's not the worst thing to implement, but it really deserves to be part of the language I think.

## Exit codes

One final thing about unix conventions. When errors do occur, if the program needs to exit early, it's common to set an exit code that represents the error. These exit codes get used by the shell in things like conditional logic:

```bash
> git stash && git pull
```

The default exit code is zero, which represents success or true. To override the default exit code, you import Darwin or Glibc on unix and call `exit`.

```swift
import Darwin
exit(-1)
```

You can pass any number to represent your error. Anything other than zero, negative or positive, is considered an error or false by the shell.

You could also use `fatalError` to do this without importing a system library, but that reveals a bunch of stack dump info that may not suit your needs. 

## Files

The second most important thing that a CLI tool will need to do is work with the file system. Of course Foundation framework gives us FileManager, which is very robust, but its API is not the friendliest to work with. Particularly for scripts that would otherwise be pretty small, file handling can quickly become the most complex part. 

For this, I want to show you one last community package, this one written by John Sundell again. It's simply called Files. It is a thin wrapper around Foundation APIs but provides a much nicer interface.

I'll just show off a few code snippets, because I think they speak for themselves. 

You can create, write to, and delete files with single commands. Error are all handled through do/catch blocks

```swift
let folder = try Folder(path: "/users/john/folder")

let file = try folder.createFile(named: "file.json")
try file.write(string: "{\"hello\": \"world\"}")

try file.delete()
try folder.delete()
```

You can rename all the files in a folder with a very simple for-loop.

```swift
for file in try Folder(path: "MyFolder").files {
    try file.rename(to: file.nameWithoutExtension.capitalized)
}
```

You can even do batch operations, like move all the files from one folder to another.

```swift
let origin = try Folder(path: "/users/john/folderA")
let target = try Folder(path: "/users/john/folderB")
try origin.files.move(to: target)
```

Files is available through SPM, but also Carthage and CocoaPods. So you can use this in your iOS apps, if you want.

# Wrap-up

In this command-line crash-course I've covered three topics:

1. Running Swift
2. Building Interfaces
3. Effective I/O

I showed you how make individual files executable using shebangs and how to build an executable with the swift package manager. We learned about Marathon and Mint, two great options for installing dependencies for your scripts and other swift-based tools. 

We looked at an example todo tool's interface, and rebuilt part of it by switching over raw-representable enums. Then we cross-examined Commander and Commandant, which take two very different approaches parsing arguments and dispatching commands. 

Finally, I gave you a grab-bag of code snippets for working with stdin, stdout, and stderr. Plus, a quick look at Files, an elegant wrapper around file management.

My name is Michael Bates. 
You can find me on Twitter and everywhere else as @mklbtz. 
This has been Command Line Tools in Swift. 
Thank you so much!