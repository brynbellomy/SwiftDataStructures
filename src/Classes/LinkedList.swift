//
//  LinkedList.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Dec 17.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Funky
//import Respect


//
// MARK: - struct LinkedList<T> -
//

/**
    `LinkedList` is intended to be used in the implementation of other collection types.  To this end, it intentionally exposes some of its own implementation
    details (particularly, the existence `LinkedListNode<T>`) so that developers can make use of these details to optimize the types they build on top of it.
 */
public struct LinkedList <T> //: ListType
{
    public typealias InnerType = T
    public typealias NodeType = LinkedListNode<T>

    public private(set) var first: NodeType?
    public private(set) var last:  LinkedListNode<T>?

    public private(set) var count: Index.Distance = 0


    public init() {
    }

    public init(_ other:LinkedList<T>) {
        extend(other)
    }


    public init <S: SequenceType where S.Generator.Element == NodeType> (_ nodes:S) {
        extend(nodes)
    }


    public init <C: CollectionType where C.Generator.Element == NodeType> (_ nodes:C) {
        extend(nodes)
    }


    public init <S: SequenceType where S.Generator.Element == T> (elements:S) {
        let mapped = map(elements) { NodeType($0) }
        extend(mapped)
    }


    /**
        Returns the element at the specified index, or nil if the index was out of range.
     */
    public func at(index:Index) -> Generator.Element?
    {
        if !contains(startIndex ..< endIndex, index) {
            return nil
        }

        var generator = generate()
        var current   = first

        for i in startIndex ... index {
            current = generator.next()
        }

        precondition(current != nil, "LinkedList.at() -- Found a very unexpected nil where an element should've been.")
        return current
    }


    /**
        Returns the index of the first element for which `predicate` returns true.
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
        Removes the last element from the list and returns it.  The list must contain at least 1 element or a precondition will fail.
     */
    public mutating func removeLast() -> NodeType {
        return removeAtIndex(endIndex.predecessor())
    }
}



/**
    `LinkedListNode` is a type that wraps each individual element of `LinkedList`.  It maintains pointers to the `next` and `previous` elements.  Note that because of `LinkedList`'s dependence on pointer semantics, `LinkedListNode` is implemented (unlike most of the other data structures) as a `class`.
 */
public class LinkedListNode <T>
{
    public var item: T

    public private(set) var previous: LinkedListNode<T>?
    public private(set) var next:     LinkedListNode<T>?

    public init(_ theItem:T) {
        item = theItem
    }
}


//
// MARK: - LinkedList: Equatable
//

public func == <T: Equatable> (lhs:LinkedList<T>, rhs:LinkedList<T>) -> Bool {
    return zipseq(lhs, rhs) |> all(==)
}

public func == <T: Equatable> (lhs:LinkedListNode<T>, rhs:LinkedListNode<T>) -> Bool {
    return lhs.item == rhs.item
}



//
// MARK: - LinkedList: SequenceType
//

extension LinkedList: SequenceType
{
    public typealias Generator = LinkedListGenerator<T>

    public func generate() -> Generator {
        return Generator(self)
    }
}



public struct LinkedListGenerator <T> : GeneratorType
{
    public typealias Collection = LinkedList<T>

    private weak var current : Collection.NodeType?

    public init(_ linkedList:Collection) {
        current = linkedList.first
    }

    public mutating func next() -> Collection.NodeType?
    {
        // @@TODO: i seem to recall reading in apple's swift documentation that this precondition should be enforced; however, it causes a runtime crash (on xcode 6.1.1).  should investigate.
        // precondition(current != nil, "next() was called too many times")

        let toReturn = current
        current = current?.next

        return toReturn
    }
}


//
// MARK: - LinkedList: MutableCollectionType
//

extension LinkedList: MutableCollectionType
{
    public typealias Index = Int
    public var startIndex : Index { return Index(0) }
    public var endIndex   : Index { return Index(count) }

    public subscript(index:Index) -> Generator.Element
    {
        get {
            precondition(index >= startIndex && index <= endIndex.predecessor(), "index is out of range.")
            return at(index)!
        }
        set {
            precondition(index >= startIndex && index <= endIndex.predecessor(), "index is out of range.")

            let currentElement = self[index]
            let elementBefore = currentElement.previous
            let elementAfter = currentElement.next

            elementBefore?.next    = newValue
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
// MARK: - LinkedList: ExtensibleCollectionType
//

extension LinkedList: ExtensibleCollectionType
{
    public mutating func reserveCapacity(n: Index.Distance) {
        // no-op
    }

    public mutating func append(newElement:NodeType) {
        insert(newElement, atIndex:endIndex)
    }


    public mutating func extend <S : SequenceType where S.Generator.Element == T> (unwrapped sequence: S) {
        let mapped = map(sequence) { NodeType($0) }
        extend(mapped)
    }

    public mutating func extend <S : SequenceType where S.Generator.Element == NodeType> (sequence: S)
    {
        // Note that this should just be "for item in sequence"; this is working around a compiler crash.
        for elem in [NodeType](sequence) {
            append(elem)
        }
    }
}


//
// MARK: - LinkedList: MutableSliceable
//

extension LinkedList: MutableSliceable
{
    public subscript(subrange: Range<Index>) -> LinkedList<T>
    {
        get
        {
            precondition(contains(self, subrange), "Subrange (\(subrange)) out of range.")

            var subslice = LinkedList<T>()
            subslice.first = self[ subrange.startIndex ]
            subslice.last  = self[ subrange.endIndex ]
            return subslice
        }

        set
        {
            precondition(contains(self, subrange), "Subrange (\(subrange)) out of range.")

            let removeLength = subrange.endIndex - subrange.startIndex
            let insertLength = newValue.count
            let deltaCount = insertLength - removeLength

            let spliceBegin = self[subrange.startIndex]
            let spliceEnd   = self[subrange.endIndex]
            let insertionBegin = newValue.first
            let insertionEnd = newValue.last

            if let previous = spliceBegin.previous {
                previous.next = insertionBegin
                insertionBegin?.previous = previous
            }
            else {
                assert(spliceBegin === first)
                first = insertionBegin
                first?.previous = nil
            }

            if let next = spliceEnd.next {
                next.previous = insertionEnd
                insertionEnd?.next = next
            }
            else {
                assert(spliceEnd === last)
                last = newValue.last
                last?.next = nil
            }

            count += deltaCount
        }
    }
}



//
// MARK: - LinkedList: RangeReplaceableCollectionType
//

extension LinkedList: RangeReplaceableCollectionType
{
    public mutating func replaceRange <C: CollectionType where C.Generator.Element == NodeType>
        (subrange: Range<Index>, with newElements: C)
    {
        var newElems = LinkedList(SequenceOf<NodeType>(newElements))
        self[subrange] = newElems
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



    public mutating func splice <C: CollectionType where C.Generator.Element == NodeType> (newElements: C, atIndex i: Index) {
        let range: Range<Index> = i ... i
        replaceRange(i...i, with: newElements)
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


    public mutating func removeRange(subrange: Range<Index>) {
        let tuple: (NodeType?, NodeType?) = removeRange(subrange)
        return
    }

    public mutating func removeRange(subrange: Range<Index>) -> (NodeType?, NodeType?)
    {
        var startNode = self[subrange.startIndex]
        var endNode   = self[subrange.endIndex]
        let (previous, subsequent) = (startNode.previous, endNode.next)

        previous?.next       = subsequent
        subsequent?.previous = previous

        count -= distance(subrange.startIndex, subrange.endIndex)

        return (previous, subsequent)
    }


    /**
        Removes all of the elements from the list.  The `keepCapacity` parameter is ignored.
     */
    public mutating func removeAll(#keepCapacity:Bool) {
        first = nil
        last  = nil
        count = 0
    }
}



//
// MARK: - LinkedList: ArrayLiteralConvertible
//

extension LinkedList: ArrayLiteralConvertible
{
    public init(arrayLiteral elements: T...) {
        let wrapped = elements |> mapr { LinkedListNode($0) }
        extend(wrapped)
    }
}



//
// MARK: - LinkedList: Printable, DebugPrintable
//

extension LinkedList: Printable, DebugPrintable
{
    public var description: String {
        let arr = Array(self)
        return arr.description
    }

    public var debugDescription: String { return description }
}



