---
title: Functional Complements to Swift
layout: post
---
>> In exploring ways to use functional programming concepts in Swift, I’ve made some additions to its basic language features. This is part of an ongoing series about functional components I’ve added to Swift. 

Here, I’ve added a function to Array called `partition`. In short, the function will partition the Array into a Dictionary based on a function which takes an Element of the Array and returns its corresponding Key into the Dictionary.

{% highlight swift %}
```
extension Array {
  func partition<Key>(key: (Element)->Key) -> [Key: [Element]] {
  var groups = [Key: [Element]]()
    for element in self {
      let key = key(element)
      var group = groups[key] ?? [Element]()
      group.append(element)
      groups[key] = group
    }
    return groups
  }
}
```
{% endhighlight %}

Now we can use the method to partition our arrays!

{% highlight swift %}
```
let nums = [1,2,3,4,5,6,7,8,9,10]
nums.partition { n in
	n % 2 == 0 ? "even" : "odd"
}
```
{% endhighlight %}

This will give us the following Dictionary.

```
["odd": [1, 3, 5, 7, 9], "even": [2, 4, 6, 8, 10]]
```

Without our method, we could could achieve the same thing using Array’s `reduce(initial: combine:)`, like so.

{% highlight swift %}
```
let groups = ["odd": [Int](), "even": [Int]()]
nums.reduce(groups) { (var groups, n) in
  let key = n % 2 == 0 ? "even" : "odd"
  groups[key]?.append(n)
  return groups
}
```
{% endhighlight %}

Our `partition` is, obviously, much more terse and readable. I haven’t needed to use this method in any projects yet, but I can see it being very useful somewhere. 

[Check out the full code.][gist]

[gist]: https://gist.github.com/mklbtz/7181da7f3b5db7745817

