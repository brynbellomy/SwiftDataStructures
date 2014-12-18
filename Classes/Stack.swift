//
//  Stack.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Dec 17.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


//
// MARK: - struct Stack<T> -
//

public struct Stack<T>
{
    public   typealias Element = T
    internal typealias UnderlyingCollection = LinkedList<T>

    private var elements = UnderlyingCollection()

    public var top     : Element?       { return elements.last?.item }
    public var bottom  : Element?       { return elements.first?.item }
    public var count   : Index.Distance { return elements.count }
    public var isEmpty : Bool           { return count == 0 }

    public init() {
    }

    /**
        Element order is [bottom, ..., top], as if one were to iterate through the sequence in forward order, calling `stack.push(element)` on each element.
     */
    public init<S : SequenceType where S.Generator.Element == T>(_ elements:S) {
        extend(elements)
    }

    /**
        Adds an element to the top of the stack.
    
        :param: elem The element to add.
    */
    public mutating func push(elem: Element) {
        let newElement = UnderlyingCollection.NodeType(elem)
        elements.append(newElement)
    }

    /**
        Removes the top element from the stack and returns it.
    
        :returns: The removed element or `nil` if the stack is empty.
     */
    public mutating func pop() -> Element? {
        return (count > 0) ? removeTop() : nil
    }

    public func find(predicate: (Element) -> Bool) -> Index? {
        return elements.find { predicate($0.item) }
    }

    /**
        Removes the element `n` positions from the top of the stack and returns it.  `index` must be a valid index or a precondition assertion will fail.

        :param: index The index of the element to remove.
        :returns: The removed element.
     */
    public mutating func removeAtIndex(index:Index) -> Element {
        precondition(index >= startIndex && index <= endIndex.predecessor(), "index (\(index)) is out of range [startIndex = \(startIndex), endIndex = \(endIndex), count = \(count)].")
        return elements.removeAtIndex(endIndex.predecessor() - index).item
    }

    /**
        This function is equivalent to `pop()`, except that it will fail if the stack is empty.
    
        :returns: The removed element.
     */
    public mutating func removeTop() -> Element {
        precondition(count > 0, "Cannot removeTop() from an empty Stack.")
        return elements.removeLast().item
    }
}



//
// MARK: - Stack : SequenceType
//

extension Stack : SequenceType
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
// MARK: - Stack : MutableCollectionType
//

extension Stack : MutableCollectionType
{
    public typealias Index = UnderlyingCollection.Index
    public var startIndex : Index { return elements.startIndex }
    public var endIndex   : Index { return elements.endIndex }

    /**
        Subscript `n` corresponds to the element that is `n` positions from the top of the stack.  Subscript 0 always corresponds to the top element.
     */
    public subscript(position:Index) -> Generator.Element
    {
        get {
            return reverse(elements)[position].item
        }
        set {
            let newNode = UnderlyingCollection.NodeType(newValue)
            elements[position] = newNode
        }
    }
}



//
// MARK: - Stack : ExtensibleCollectionType
//

extension Stack : ExtensibleCollectionType
{
    public mutating func reserveCapacity(n: Index.Distance) {
        elements.reserveCapacity(n)
    }

    /**
        This method is simply an alias for `push()`, included for `ExtensibleCollectionType` conformance.
     */
    public mutating func append(newElement:Element) {
        push(newElement)
    }


    /**
        Element order is [bottom, ..., top], as if one were to iterate through the sequence in forward order, calling `stack.push(element)` on each element.
     */
    public mutating func extend<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
        let wrapped = map(sequence) { UnderlyingCollection.NodeType($0) }
        elements.extend(wrapped)
    }
}



//
// MARK: - Stack : ArrayLiteralConvertible
//

extension Stack : ArrayLiteralConvertible
{
    /**
        Element order is [bottom, ..., top], as if one were to iterate through the sequence in forward order, calling `stack.push(element)` on each element.
     */
    public init(arrayLiteral elements: Element...) {
        extend(elements)
    }
}



