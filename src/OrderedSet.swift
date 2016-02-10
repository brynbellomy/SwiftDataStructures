//
//  OrderedSet.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 12.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky


//
// MARK: - struct OrderedSet<T> -
//

public struct OrderedSet <T: Hashable> //: ListType
{
    public  typealias Element        = T
    private typealias LinkedListType = LinkedList<Element>
    
    public  typealias Index          = LinkedListType.Index
    
    private var elements = LinkedListType()
    
    public var last    : Element?       { return elements.last?.item }

    /** The first element obtained when iterating, or `nil` if self is empty. Equivalent to `self.generate().next()`. */
    public var first   : Element?       { return elements.first?.item }

    public var count   : Index.Distance { return elements.count }

    public var isEmpty : Bool           { return count == 0 }
    
    //
    // MARK: - Lifecycle
    //
    
    public init() {
    }
    
    public init <S: SequenceType where S.Generator.Element == Element>(_ elements:S) {
        appendContentsOf(elements)
    }
    
    //
    // MARK: - Public API
    //
    
    public func elementAtIndex(index: Index) -> Element? {
        return nodeAtIndex(index)?.item ?? nil
    }
    
    private func nodeAtIndex(index: Index) -> LinkedListType.NodeType? {
        return elements[index]
    }
    
    /**
        @@TODO: I'm not sure whether to mark this `mutating` or not.  I don't technically have
        to because it updates a pointer to a `LinkedListNode`, but that's an implementation
        detail, so I really oughta pretend it's not the case.  Right?
    */
    public mutating func updateElement (element:Element, atIndex index:Index) {
        elements[index].item = element
    }
    
    public mutating func insertElement (element: Element, atIndex index: Index) {
        elements.insert(LinkedListNode(element), atIndex: index)
    }
    
    /** Remove the member referenced by the given index. */
    public mutating func removeAtIndex (index: Index) -> Element {
        return elements.removeAtIndex(index).item
    }
    
    /** Remove all elements in the `OrderedSet`. */
    public mutating func removeAll (keepCapacity keepCapacity:Bool) {
        elements.removeAll(keepCapacity: keepCapacity)
    }
    
    public func findWhere (predicate: Element -> Bool) -> Index? {
        return elements.find { predicate($0.item) }
    }
    
    public func hasIndex (index:Index) -> Bool {
        return index <= elements.endIndex.predecessor()
    }
    
    /** Returns `true` if the set contains the given `element`. */
    public func contains (element:Element) -> Bool {
        return (elements |> countWhere { $0.item == element }) > 0
    }
}



//
// MARK: - OrderedSet: SequenceType
//

extension OrderedSet: SequenceType
{
    public typealias Generator = AnyGenerator<Element>
    public func generate() -> Generator
    {
        var generator = elements.generate()
        return anyGenerator { generator.next()?.item }
    }
}



//
// MARK: - OrderedSet: MutableCollectionType
//

extension OrderedSet: MutableCollectionType
{
    public var startIndex : Index { return elements.startIndex }
    public var endIndex   : Index { return elements.endIndex }
    
    public subscript(index: Index) -> Element {
        get { return elementAtIndex(index)! }
        set { updateElement(newValue, atIndex:index) }
    }
}



//
// MARK: - OrderedSet: ExtensibleCollectionType
//

extension OrderedSet: RangeReplaceableCollectionType
{
    public mutating func reserveCapacity(n: Index.Distance) {
        elements.reserveCapacity(n)
    }
    
    public mutating func append (newElement: Element) {
        let wrapped = LinkedListType.NodeType(newElement)
        elements.append(wrapped)
    }
    
    public mutating func appendContentsOf <S: SequenceType where S.Generator.Element == Element> (sequence: S) {
        let wrapped = sequence.map(LinkedListType.NodeType.init)
        elements.appendContentsOf(wrapped)
    }
    
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Index>, with newElements: C) {
        let nodes = newElements.map { LinkedListType.NodeType($0) }
        elements.replaceRange(subRange, with: nodes)
    }
}



//
// MARK: - OrderedSet: ArrayLiteralConvertible
//

//extension OrderedSet: ArrayLiteralConvertible
//{
//    public init(arrayLiteral elements: Element...) {
//        appendContentsOf(elements)
//    }
//}




extension OrderedSet
{
    var hashValue: Int { return Set(self).hashValue }
    
    /** A textual representation of self. */
    var description: String {
        let bareElements = elements.map { $0.item }
        return "OrderedSet(\(describe(bareElements)))"
    }
    
    /** A textual representation of self, suitable for debugging. */
    var debugDescription: String { return description }
    
    /** Returns the Index of a given member, or nil if the member is not present in the set. */
    func indexOf(member: T) -> Index? {
        return findWhere { $0 == member }
    }
    
    /** Insert a member into the set. */
    mutating func insert(member: T) {
        append(member)
    }
    
    /** Remove the member from the set and return it if it was present. */
    mutating func remove(member: T) -> T? {
        if let index = indexOf(member) {
            return removeAtIndex(index)
        }
        return nil
    }
    
    /** Remove a member from the set and return it. Requires: count > 0. */
    mutating public func removeFirst() -> T {
        precondition(count > 0, "Cannot removeFirst() from an empty OrderedSet.")
        return removeAtIndex(0)
    }
    
    /** Returns true if the set is a subset of a finite sequence as a Set. */
    func isSubsetOf<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Bool {
        return Set(self).isSubsetOf(sequence)
    }
    
    /** Returns true if the set is a subset of a finite sequence as a Set but not equal. */
    func isStrictSubsetOf<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Bool {
        return Set(self).isStrictSubsetOf(sequence)
    }
    
    /** Returns true if the set is a superset of a finite sequence as a Set. */
    func isSupersetOf<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Bool {
        return Set(self).isSupersetOf(sequence)
    }
    
    /** Returns true if the set is a superset of a finite sequence as a Set but not equal. */
    func isStrictSupersetOf<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Bool {
        return Set(self).isStrictSupersetOf(sequence)
    }
    
    /** Returns true if no members in the set are in a finite sequence as a Set. */
    func isDisjointWith<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Bool {
        return Set(self).isDisjointWith(sequence)
    }
    
    /** Return a new Set with items in both this set and a finite sequence. */
    func union<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> OrderedSet<T> {
        var unioned = OrderedSet(self)
        unioned.appendContentsOf(sequence)
        return unioned
    }
    
    /** Insert elements of a finite sequence into this Set. */
    mutating func unionInPlace<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) {
        appendContentsOf(sequence)
    }
    
    // @@TODO
    /** Return a new set with elements in this set that do not occur in a finite sequence. */
    // func subtract<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Set<T> {

    // }
    
    // /** Remove all members in the set that occur in a finite sequence. */
    // mutating func subtractInPlace<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) {

    // }
    
    // /** Return a new set with elements common to this set and a finite sequence. */
    // func intersect<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Set<T> {

    // }
    
    // /** Remove any members of this set that aren't also in a finite sequence. */
    // mutating func intersectInPlace<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) {

    // }
    
    // /** Return a new set with elements that are either in the set or a finite sequence but do not occur in both. */
    // func exclusiveOr<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) -> Set<T> {

    // }
    
    // /** For each element of a finite sequence, remove it from the set if it is a common element, otherwise add it to the set. Repeated elements of the sequence will be ignored. */
    // mutating func exclusiveOrInPlace<S : SequenceType where S.Generator.Element == Generator.Element>(sequence: S) {

    // }
}