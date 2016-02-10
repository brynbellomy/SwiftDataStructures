//
//  OrderedDictionary.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Nov 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


//
// MARK: - struct OrderedDictionary<K, V> -
//

public struct OrderedDictionary <K: Hashable, V> //: ListType
{
    public  typealias Element        = OrderedDictionaryElement<K, V>
    private typealias LinkedListType = LinkedList<Element>

    public  typealias Index          = LinkedListType.Index
    public  typealias Key            = K
    public  typealias Value          = V

    private var elements = LinkedListType()

    public var last    : Element?       { return elements.last?.item }
    public var first   : Element?       { return elements.first?.item }
    public var count   : Index.Distance { return elements.count }
    public var isEmpty : Bool           { return count == 0 }

    public var keys:   [K] { return generateTuples().map { key, _   in key   } }
    public var values: [V] { return generateTuples().map { _, value in value } }


    //
    // MARK: - Lifecycle
    //

    public init() {
    }

    public init <S: SequenceType where S.Generator.Element == Element>(_ elements:S) {
        appendContentsOf(elements)
    }
    
    public init <S: SequenceType where S.Generator.Element == (K, V)>(_ elements:S) {
        appendContentsOf( elements.map { Element(key: $0.0, value: $0.1) } )
    }

    //
    // MARK: - Public API
    //

    public func elementForKey (key: K) -> Element? {
        return nodeForKey(key)?.item ?? nil
    }

    public func elementAtIndex(index: Index) -> Element? {
        return nodeAtIndex(index)?.item ?? nil
    }

    private func nodeForKey (key: K) -> LinkedListType.NodeType? {
        for node in elements {
            if node.item.key == key {
                return node
            }
        }
        return nil
    }

    private func nodeAtIndex(index: Index) -> LinkedListType.NodeType? {
        return elements[index]
    }

    public func indexForKey(key: K) -> Index? {
        return find { $0.key == key }
    }

    /**
        @@TODO: I'm not sure whether to mark this `mutating` or not.  I don't technically have
        to because it updates a pointer to a `LinkedListNode`, but that's an implementation
        detail, so I really oughta pretend it's not the case.  Right?
    */
    public mutating func updateElement(element:Element, atIndex index:Index) {
        elements[index].item = element
    }

    public mutating func updateValue (value: V, forKey key: K) {
        precondition(hasKey(key) == true, "Tried to update value for key '\(key)' but the key was not found.")
        nodeForKey(key)!.item.value = value
    }

    public mutating func updateValue (value: V, atIndex index: Index) {
        precondition(hasIndex(index) == true, "Tried to update value for index '\(index)' but it was out of range.")
        nodeAtIndex(index)!.item.value = value
    }

    public mutating func insertElement (element: Element, atIndex index: Index) {
        precondition(hasKey(element.key) == false, "Tried to insert element but element's key already exists in the OrderedDictionary.")
        elements.insert(LinkedListNode(element), atIndex: index)
    }

    public mutating func insertKey (key: Key, value: Value, atIndex index: Index) {
        let element = Element(key:key, value:value)
        insertElement(element, atIndex: index)
    }

    public mutating func removeForKey(key:K) -> Element {
        precondition(hasKey(key) == true)

        let index = indexForKey(key)
        return removeAtIndex(index!)
    }

    public mutating func removeAtIndex(index: Index) -> Element {
        return elements.removeAtIndex(index).item
    }

    public mutating func removeAll(keepCapacity keepCapacity:Bool) {
        elements.removeAll(keepCapacity: keepCapacity)
    }

    public func find(predicate: Element -> Bool) -> Index? {
        return elements.find { predicate($0.item) }
    }

    public func hasIndex(index:Index) -> Bool {
        return index <= elements.endIndex.predecessor()
    }

    public func hasKey(key:Key) -> Bool {
        return indexForKey(key) != nil
    }

    /**
        This is often the simplest method for iterating over the contents of the `OrderedDictionary` in
        order.  `sequence()` returns a sequence whose elements are key-value pairs.  The sequence's order
        is the same as the `OrderedDictionary`.
    */
    public func sequence() -> AnySequence<(Key, Value)> {
        return AnySequence(generateTuples())
    }
}



//
// MARK: - OrderedDictionary: SequenceType
//

extension OrderedDictionary: SequenceType
{
    public typealias Generator = AnyGenerator<Element>
    public func generate() -> Generator
    {
        var generator = elements.generate()
        return anyGenerator { generator.next()?.item }
    }

    public func generateTuples() -> AnyGenerator<(Key, Value)>
    {
        let generator = generate()
        return anyGenerator { generator.next()?.asTuple() ?? nil }
    }
}



//
// MARK: - OrderedDictionary: MutableCollectionType
//

extension OrderedDictionary: MutableCollectionType
{
    public var startIndex : Index { return elements.startIndex }
    public var endIndex   : Index { return elements.endIndex }

    public subscript(index: Index) -> Element
    {
        get { return elementAtIndex(index)! }
        set { updateElement(newValue, atIndex:index) }
    }

//    public subscript(index: Index) -> Value?
//    {
//        get { return elementAtIndex(index)?.value }
//    }

    public subscript(key: Key) -> Value?
    {
        get {
            if let val = elementForKey(key)?.value {
                return val
            }
            return nil
        }
        set {
            if hasKey(key) {
                if let newValue = newValue {
                    updateValue(newValue, forKey:key)
                }
                else {
                    removeForKey(key)
                }
            }
            else {
                if let newValue = newValue {
                    let element = Element(key:key, value:newValue)
                    let node = LinkedListNode(element)
                    elements.append(node)
                }
            }
        }
    }
}



//
// MARK: - OrderedDictionary: ExtensibleCollectionType
//

extension OrderedDictionary: RangeReplaceableCollectionType
{
    public typealias KeyValueTuple = (Key, Value)

    public mutating func reserveCapacity(n: Index.Distance) {
        elements.reserveCapacity(n)
    }

    public mutating func append(newElement: Element) {
        let wrapped = LinkedListType.NodeType(newElement)
        elements.append(wrapped)
    }

    public mutating func append(key: Key, value: Value) {
        let newElement = Element(key: key, value: value)
        let wrapped = LinkedListType.NodeType(newElement)
        elements.append(wrapped)
    }

    public mutating func appendContentsOf <S: SequenceType where S.Generator.Element == Element> (sequence: S) {
        let mapped = sequence.map(LinkedListType.NodeType.init)
        elements.appendContentsOf(mapped)
    }

    public mutating func extendTuples <S: SequenceType where S.Generator.Element == KeyValueTuple> (sequence: S) {
        let mapped = sequence.map { tpl in Element(key:tpl.0, value: tpl.1) }
        appendContentsOf(mapped)
    }
    
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Index>, with newElements: C) {
        let nodes = newElements.map { LinkedListType.NodeType($0) }
        elements.replaceRange(subRange, with: nodes)
    }
}



//
// MARK: - OrderedDictionary: DictionaryLiteralConvertible
//

//extension OrderedDictionary: DictionaryLiteralConvertible
//{
//    public init(dictionaryLiteral elements: (Key, Value)...) {
//        let mapped = elements.map { key, value in OrderedDictionaryElement(key:key, value:value) }
//        appendContentsOf(mapped)
//    }
//}


//
// MARK: - struct OrderedDictionaryElement -
//

public struct OrderedDictionaryElement <K: Hashable, V>
{
    public typealias Key   = OrderedDictionary<K, V>.Key
    public typealias Value = OrderedDictionary<K, V>.Value

    public let key: Key
    public private(set) var value: Value

    public init(key k:Key, value v:Value) {
        key = k
        value = v
    }

    public func asTuple() -> (Key, Value) {
        return (key, value)
    }
}


//
// MARK: - Operators -
//

/**
    Allows equality testing of an `OrderedDictionaryElement<K, V>` and a tuple `(K, V)`.
 */
public func == <K: Hashable, V: Equatable> (lhs: OrderedDictionary<K, V>.Element, rhs: (K, V)) -> Bool {
    return lhs.key == rhs.0 && lhs.value == rhs.1
}

/**
    Allows equality testing between two `OrderedDictionaryElement<K, V>`s.
 */
public func == <K: Hashable, V: Equatable> (lhs: OrderedDictionary<K, V>.Element, rhs: OrderedDictionary<K, V>.Element) -> Bool {
    return lhs.key == rhs.key && lhs.value == rhs.value
}

/**
    Allows equality testing between two optional `OrderedDictionaryElement<K, V>`s.
 */
public func == <K: Hashable, V: Equatable> (lhs: OrderedDictionary<K, V>.Element?, rhs: OrderedDictionary<K, V>.Element?) -> Bool {
    return lhs?.key == rhs?.key && lhs?.value == rhs?.value
}

