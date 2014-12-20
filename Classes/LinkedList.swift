//
//  LinkedList.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Dec 17.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


//
// MARK: - struct LinkedList<T> -
//

public struct LinkedList<T>
{
    public typealias NodeType = LinkedListNode<T>
//    public typealias Element  = NodeType

    public private(set) var first: NodeType?
    public private(set) var last:  LinkedListNode<T>?

    public private(set) var count: Index.Distance = 0


    public init() {
    }


    public init<S : SequenceType where S.Generator.Element == T>(_ elements:S) {
        let mapped = map(elements) { NodeType($0) }
        extend(mapped)
    }


    /**
        Returns the element at the specified index, or nil if the index was out of range.
     */
    public func at(index:Index) -> Generator.Element?
    {
        if index < startIndex || index > endIndex.predecessor() {
            return nil
        }

        var generator = generate()
        var current   = first

        for i in startIndex ... index {
            current = generator.next()
        }

        return current!
    }


    /**
        Returns the first element for which `predicate` returns true.
     */
    public func find(predicate: (LinkedListNode<T>) -> Bool) -> Index?
    {
        for (i, elem) in enumerate(self) {
            if predicate(elem) == true {
                return i
            }
        }
        return nil
    }


    /**
        Inserts the provided element at the beginning of the list.
     */
    public mutating func prepend(newElement:NodeType) {
        insert(newElement, atIndex:startIndex)
    }


    /**
        Inserts the provided element at the specified index of the list.  The index must be >= startIndex and <= endIndex.  Insert can therefore be used to append and prepend elements to the list (and, in fact, `append` and `prepend` simply call this function).
     */
    public mutating func insert(newElement:NodeType, atIndex index:Index)
    {
        precondition(index >= startIndex && index <= endIndex)

        newElement.previous = nil
        newElement.next = nil

        let currentElementAtPosition = at(index)
        let elementBefore = currentElementAtPosition?.previous ?? at(index.predecessor()) ?? nil

        currentElementAtPosition?.previous = newElement
        elementBefore?.next = newElement

        newElement.next = currentElementAtPosition
        newElement.previous = elementBefore

        // update first
        if index == startIndex {
            first = newElement
        }

        // update last
        if index == endIndex {
            last = newElement
        }

        ++count
    }


    /**
        Removes the element `n` positions from the beginning of the list and returns it.  `index` must be a valid index or a precondition assertion will fail.

        :param: index The index of the element to remove.
        :returns: The removed element.
     */
    public mutating func removeAtIndex(index:Index) -> NodeType
    {
        precondition(index >= startIndex && index <= endIndex.predecessor(), "index (\(index)) is out of range [startIndex = \(startIndex), endIndex = \(endIndex), count = \(count)].")

        var element = self[index]
        var elementBefore = element.previous
        var elementAfter  = element.next

        if index == startIndex {
            first = elementAfter
        }

        if index == endIndex.predecessor() {
            last = elementBefore
        }

        elementBefore?.next    = elementAfter
        elementAfter?.previous = elementBefore

        element.next     = nil
        element.previous = nil

        --count

        return element
    }

    public mutating func removeLast() -> NodeType {
        return removeAtIndex(endIndex.predecessor())
    }
}



public class LinkedListNode<T>
{
    public let item: T

    public private(set) var previous: LinkedListNode<T>?
    public private(set) var next:     LinkedListNode<T>?

    public init(_ theItem:T) {
        item = theItem
    }
}



//
// MARK: - LinkedList : SequenceType
//

extension LinkedList : SequenceType
{
    public typealias Generator = LinkedListGenerator<T>

    public func generate() -> Generator {
        return Generator(self)
    }
}



public struct LinkedListGenerator<T> : GeneratorType
{
    public typealias Collection = LinkedList<T>

    private weak var current : Collection.NodeType?

    public init(_ linkedList:Collection) {
        current = linkedList.first
    }

    public mutating func next() -> Collection.NodeType?
    {
        // @@TODO: i seem to recall reading in apple's swift documentation that this precondition should be enforced; however, it causes a runtime crash (on xcode 6.1.1).  should investigate.
//        precondition(current != nil, "next() was called too many times")

        let toReturn = current
        current = current?.next

        return toReturn
    }
}


//
// MARK: - LinkedList : MutableCollectionType
//

extension LinkedList : MutableCollectionType
{
    public typealias Index = Int
    public var startIndex : Index { return Index(0) }
    public var endIndex   : Index { return Index(count) }

    public subscript(index:Index) -> Generator.Element
    {
        get {
            precondition(index >= startIndex && index <= endIndex.predecessor(), "index is out of range.")

            let node = at(index)
            return node!
        }
        set {
            precondition(index >= startIndex && index <= endIndex.predecessor(), "index is out of range.")

            let currentElement = self[index]
            let elementBefore = currentElement.previous
            let elementAfter = currentElement.next

            elementBefore?.next = newValue
            elementAfter?.previous = newValue

            newValue.next = elementAfter
            newValue.previous = elementBefore

            if index == startIndex {
                first = newValue
            }
            if index == endIndex.predecessor() {
                last = newValue
            }
        }
    }
}



//
// MARK: - LinkedList : ExtensibleCollectionType
//

extension LinkedList : ExtensibleCollectionType
{
    public mutating func reserveCapacity(n: Index.Distance) {
        // no-op
    }

    public mutating func append(newElement:NodeType) {
        insert(newElement, atIndex:endIndex)
    }


    public mutating func extend<S : SequenceType where S.Generator.Element == NodeType>(sequence: S)
    {
        // Note that this should just be "for item in sequence"; this is working around a compiler crash.
        for elem in [NodeType](sequence) {
            append(elem)
        }
    }
}



//
// MARK: - LinkedList : ArrayLiteralConvertible
//

extension LinkedList : ArrayLiteralConvertible
{
    public init(arrayLiteral elements: T...) {
        let wrapped = map(elements) { LinkedListNode($0) }
        extend(wrapped)
    }
}


