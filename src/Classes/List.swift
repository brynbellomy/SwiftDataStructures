//
//  List.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Feb 2.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


//
// MARK: - struct List<T> -
//

public struct List <T>
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
        Element order is [front, ..., back], as if one were to iterate through the sequence in forward order, calling `list.append(element)` on each element.
     */
    public init <S: SequenceType where S.Generator.Element == T> (_ elements: S) {
        extend(elements)
    }

    public func find(predicate: (Element) -> Bool) -> Index? {
        return elements.find { predicate($0.item) }
    }

    public mutating func removeAtIndex(index:Index) -> Element {
        return elements.removeAtIndex(index).item
    }
}



//
// MARK: - List : SequenceType
//

extension List : SequenceType
{
    public typealias Generator = AnyGenerator<T>
    public func generate() -> Generator
    {
        var generator = elements.generate()
        return anyGenerator {
            return generator.next()?.item
        }
    }
}



//
// MARK: - List : MutableCollectionType
//

extension List : MutableCollectionType
{
    public typealias Index = UnderlyingCollection.Index
    public var startIndex : Index { return elements.startIndex }
    public var endIndex   : Index { return elements.endIndex }

    /**
        Subscript `n` corresponds to the element that is `n` positions from the front of the list.  Subscript 0 always corresponds to the frontmost element.
     */
    public subscript(position:Index) -> Generator.Element
    {
        get { return elements[position].item }
        set { elements[position] = UnderlyingCollection.NodeType(newValue) }
    }
}



//
// MARK: - List : ExtensibleCollectionType
//

extension List : RangeReplaceableCollectionType
{
    public mutating func reserveCapacity(n: Index.Distance) {
        elements.reserveCapacity(n)
    }

    /**
        This method is simply an alias for `append()`, included for `ExtensibleCollectionType` conformance.
     */
    public mutating func append(newElement:Element) {
        elements.append(UnderlyingCollection.NodeType(newElement))
    }


    /**
        Element order is [front, ..., back], as if one were to iterate through the sequence in forward order, calling `append(element)` on each element.
     */
    public mutating func extend<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
        let wrapped = sequence.map { UnderlyingCollection.NodeType($0) }
        elements.appendContentsOf(wrapped)
    }
    
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Index>, with newElements: C) {
        let nodes = newElements.map { UnderlyingCollection.NodeType($0) }
        elements.replaceRange(subRange, with: nodes)
    }
}



//
// MARK: - List : ArrayLiteralConvertible
//

extension List : ArrayLiteralConvertible
{
    /**
        Element order is [front, ..., back], as if one were to iterate through the sequence in forward order, calling `list.append(element)` on each element.
     */
    public init(arrayLiteral elements: Element...) {
        extend(elements)
    }
}


