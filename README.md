
# SwiftDataStructures

Currently implemented:

- `LinkedList`
- `Stack`: Implemented using `LinkedList` rather than Swift's built-in `Array`.  Hopefully a bit faster this way.
- `Queue`: Like `Stack`, this has also been implemented using a `LinkedList`.


Comments, ideas, and pull requests are very welcome!

Everything is pretty thoroughly tested so far.


# usage

You can check out the tests for more information (better instructions are continually evolving).  It's pretty intuitive, though.

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
