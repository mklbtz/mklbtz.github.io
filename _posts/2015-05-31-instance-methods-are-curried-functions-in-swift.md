---
title: Instance Methods are Curried Functions in Swift
layout: post
link: http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
---
> **Update 2017-09-04**<br/>
> This behavior will be changed in a future version of Swift whenever proposal [SE-0042] is implemented, but as of Swift 4.0 it's still available. Check out [the proposal][SE-0042] for more details and the rationale behind this change.

This is a really neat technical detail of Swift: under the hood, instance methods can be accessed directly through the class as a curried function. If you don't know what function currying is, it's something best explained through example. Here is the same function in curried and non-curried forms:

~~~ swift
func normalFunc(a: Int, b: Int) -> Int
func curryFunc(a: Int) -> (b: Int) -> Int
~~~

That's a function returning a function returning an `Int`. Those familiar with Javascript will recognize this from the ability to partially apply parameters using `.bind()`. So, when I say that instance methods are curried class methods, I mean that these two method calls are identical:

~~~ swift
let message = "spicy curry is tasty!"
message.hasPrefix("spicy")
String.hasPrefix(message)("spicy")
~~~

[Ole Begemann]({{page.link}}) tipped me off to a really compelling use case for this feature. He shows how to make a type-safe target-action pattern that does not rely on selectors or Objective-C’s dynamic message dispatcher. If you're not sure why that's so cool, he offers this tidbit of wisdom:

> This pattern is often better than using plain closures for callbacks, especially when the receiving objects has to hold on to the closure for an indeterminate amount of time. Using closures often forces the caller of the API to do extra work to prevent strong reference cycles. With the target-action pattern, the object that provides the API can do the strong-weak dance internally, which leads to cleaner code on the calling side.

[Check out Begemann's post for more!]({{page.link}})

[SE-0042]: https://github.com/apple/swift-evolution/blob/9cf2685293108ea3efcbebb7ee6a8618b83d4a90/proposals/0042-flatten-method-types.md
