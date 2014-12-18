//
//  Queue.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Nov 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


//
// MARK: - struct Queue<T> -
//

public struct Queue<T>
{
    public   typealias Element = T
    internal typealias UnderlyingCollection = LinkedList<T>

    private var elements = UnderlyingCollection()

    public var back    : Element?       { return elements.last?.item }
    public var front   : Element?       { return elements.first?.item }
    public var count   : Index.Distance { return elements.count }
    public var isEmpty : Bool           { return count == 0 }

    public init() {
    }

    /**
        Element order is [front, ..., back], as if one were to iterate through the sequence in forward order, calling `queue.enqueue(element)` on each element.
     */
    public init<S : SequenceType where S.Generator.Element == T>(_ elements:S) {
        extend(elements)
    }

    public mutating func enqueue(elem: Element) {
        let newElement = UnderlyingCollection.NodeType(elem)
        elements.append(newElement)
    }

    public mutating func dequeue() -> Element? {
        return (count > 0) ? removeAtIndex(0) : nil
    }

    public func find(predicate: (Element) -> Bool) -> Index? {
        return elements.find { predicate($0.item) }
    }

    public mutating func removeAtIndex(index:Index) -> Element {
        return elements.removeAtIndex(index).item
    }
}



//
// MARK: - Queue : SequenceType
//

extension Queue : SequenceType
{
    public typealias Generator = GeneratorOf<T>
    public func generate() -> Generator
    {
        var generator = elements.generate()
        return GeneratorOf {
            return generator.next()?.item
        }
    }
}



//
// MARK: - Queue : MutableCollectionType
//

extension Queue : MutableCollectionType
{
    public typealias Index = UnderlyingCollection.Index
    public var startIndex : Index { return elements.startIndex }
    public var endIndex   : Index { return elements.endIndex }

    /**
        Subscript `n` corresponds to the element that is `n` positions from the front of the queue.  Subscript 0 always corresponds to the frontmost element.
     */
    public subscript(position:Index) -> Generator.Element
    {
        get { return elements[position].item }
        set { elements[position] = UnderlyingCollection.NodeType(newValue) }
    }
}



//
// MARK: - Queue : ExtensibleCollectionType
//

extension Queue : ExtensibleCollectionType
{
    public mutating func reserveCapacity(n: Index.Distance) {
        elements.reserveCapacity(n)
    }

    /**
        This method is simply an alias for `enqueue()`, included for `ExtensibleCollectionType` conformance.
     */
    public mutating func append(newElement:Element) {
        enqueue(newElement)
    }


    /**
        Element order is [front, ..., back], as if one were to iterate through the sequence in forward order, calling `enqueue(element)` on each element.
     */
    public mutating func extend<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
        let wrapped = map(sequence) { UnderlyingCollection.NodeType($0) }
        elements.extend(wrapped)
    }
}



//
// MARK: - Queue : ArrayLiteralConvertible
//

extension Queue : ArrayLiteralConvertible
{
    /**
        Element order is [front, ..., back], as if one were to iterate through the sequence in forward order, calling `queue.enqueue(element)` on each element.
     */
    public init(arrayLiteral elements: Element...) {
        extend(elements)
    }
}



