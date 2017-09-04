---
title: Functional Complements to Swift, Part 2
layout: post
---
> In exploring ways to use functional programming concepts in Swift, I’ve made some additions to its basic language features. This is part of an ongoing series about functional components I’ve added to Swift. 

~~~ swift
infix operator => { associativity right }

func => <T,U> (value: T?, @noescape transform: T->U) -> U? {
    return map(value) { transform($0) }
}
~~~


~~~ swift
infix operator <= { associativity left }
func <= <T,U> (@noescape transform: T->U, value: T?) -> U? {
    return map(value) { transform($0) }
}
~~~


~~~ swift
let x: Int? = 1
string <= n()
~~~
