
# SwiftDataStructures

<img src="cookie-monster-eating-o.gif" />

[![Build Status](https://travis-ci.org/brynbellomy/SwiftDataStructures.svg?branch=master)](https://travis-ci.org/brynbellomy/SwiftDataStructures)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftDataStructures.svg?style=flat)](http://cocoadocs.org/docsets/SwiftDataStructures)
[![CocoaPods](https://img.shields.io/cocoapods/p/SwiftDataStructures.svg?style=flat)](http://cocoadocs.org/docsets/SwiftDataStructures)
[![CocoaPods](https://img.shields.io/cocoapods/l/SwiftDataStructures.svg?style=flat)](http://cocoadocs.org/docsets/SwiftDataStructures)
[![GitHub tag](https://img.shields.io/github/tag/brynbellomy/SwiftDataStructures.svg?style=flat)]()


## install

It's a [CocoaPod](http://cocoapods.org).  For the time being, only the pre-release beta of CocoaPods 0.36 is capable of working with Swift code.  To install it, use `gem install cocoapods --pre`.

Podfile:

```ruby
pod 'SwiftDataStructures'
```

Command line:

```sh
$ pod install
```

## Currently implemented:

- `OrderedDictionary`: Implemented using `LinkedList` rather than one of Swift's built-in types.  Hopefully a bit faster this way.
- `Set`: Finally!
- `Stack`: Also implemented with a `LinkedList`.
- `Queue`: Like `Stack`, this has also been implemented using a `LinkedList`.
- `List`: An abstraction over a `LinkedList` that hides its implementation using `LinkedListNode`s.  A `List`'s interface is basically identical to that of an `Array`.
- `LinkedList` (serves as a base for a lot of the other data structures)

## Forthcoming:

- `OrderedSet`
- A complete test suite
- Performance tests

Comments, ideas, and pull requests are very welcome!

The tests are coming along, but any contributions towards those would be awesome as well.  Even just a second set of eyes would go a long way.


# example usage

You can check out the tests for more information (better instructions are continually evolving).  It's all pretty intuitive, though ... the types all do pretty much what you would expect.

## LinkedList&lt;T&gt;

### Initialization:

```swift
// Empty list
let list = LinkedList<Int>()

// You can initialize a LinkedList using any type that conforms to Sequence
let someArray = [10, 20, 30]
let list = LinkedList<Int>(someArray)

let someSequence = SequenceOf([10, 20, 30])
let list = LinkedList<Int>(someSequence)

// LinkedList also implements ArrayLiteralConvertible
let list : LinkedList<Int> = [10, 20, 30]
```


### LinkedListNode&lt;T&gt;

LinkedList's elements are `LinkedListNode` objects, which are simple boxes/wrappers around whatever type `T` you're storing in the list.  A `LinkedListNode` has an `item` property for retrieving the wrapped value, as well as `previous` and `next` pointers for traversing the list.

```swift
public class LinkedListNode<T>
{
    public let item: T

    public private(set) var previous: LinkedListNode<T>?
    public private(set) var next:     LinkedListNode<T>?

    public init(_ theItem:T) {
        item = theItem
    }
}
```


### Accessing elements

`LinkedList` defines a subscript getter as well as `func at(index:Index) -> LinkedListNode<T>` for accessing elements at particular indices.  The subscript operator will fail when passed an out-of-bounds index, while `at()` will simply return `nil`.

```swift
let someNode = list[2]
let someNode = list.at(2)
```


### Traversing the list

`LinkedList` implements `SequenceType`, allowing you to use `for...in` loops, among many other things.

```swift
for node in list {
    println("node.item = \(node.item)")
}
```

A list also maintains `first` and `last` pointers:

```swift
list.first // an optional LinkedListNode<T>
list.last  // an optional LinkedListNode<T>
```

### Finding a particular item

```swift
let foundNode = list.find { $0.item == 1337 } // returns an optional LinkedListNode<T>
foundNode?.item // == 1337 (or nil if the node wasn't found)
```


### Manipulating the list

_**Note:** `LinkedList`'s `Index` type is a simple `Int`._

Adding new elements (`append` and `prepend`):

```swift
list.append(LinkedListNode(30))
list.prepend(LinkedListNode(30))
list.insert(LinkedListNode(30), atIndex:5)
```

Removing elements:

```swift
let removed = list.removeAtIndex(3) // removed == the removed LinkedListNode object
```


# contributors / authors


bryn austin bellomy < <bryn.bellomy@gmail.com> >
