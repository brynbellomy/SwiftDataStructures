//
//  Set.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 12.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


/**
    A set of unique elements as determined by `hashValue` and `==`.
 */
public struct Set <T: Hashable>
{
    /** This is an implementation detail.  Don't rely on it. */
    public typealias Unit = Void

    /** This is an implementation detail.  Don't rely on it. */
    private static var unitValue: Unit { return () }

    //
    // MARK: Lifecycle
    //

    /** Constructs the empty `Set`. */
    public init() {
        self.init(values: [:])
    }

    /** Constructs a `Set` with the elements of `sequence`. */
    public init <S: SequenceType where S.Generator.Element == T> (_ sequence: S) {
        self.init(values: [:])
        extend(sequence)
    }

    /** Constructs a `Set` from a variadic parameter list. */
    public init(_ elements: T...) {
        self.init(elements)
    }

    /** Constructs a `Set` with a hint as to the capacity it should allocate. */
    public init(minimumCapacity: Int) {
        self.init(values: [T: Unit](minimumCapacity: minimumCapacity))
    }

    /** Constructs a `Set` with a dictionary of `values`. */
    private init(values v: [T: Unit]) {
        values = v
    }


    //
    // MARK: Properties
    //

    /** The underlying dictionary. */
    private var values: [T: Unit]

    /** The number of entries in the set. */
    public var count: Int { return values.count }

    /** True iff `count == 0` */
    public var isEmpty: Bool { return values.isEmpty }


    //
    // MARK: Primitive methods
    //

    /** True iff `element` is in the receiver, as defined by its hash and equality. */
    public func contains(element: T) -> Bool {
        return values[element] != nil
    }

    /** Inserts `element` into the receiver, if it doesn’t already exist. */
    public mutating func insert(element: T) {
        values[element] = Set.unitValue
    }

    /** Removes `element` from the receiver, if it’s a member. */
    public mutating func remove(element: T) {
        values.removeValueForKey(element)
    }

    /** Removes all elements from the receiver. */
    public mutating func removeAll() {
        values = [:]
    }


    //
    // MARK: Algebraic operations
    //

    /** Returns the union of the receiver and `set`. */
    public func union(set: Set<T>) -> Set<T> {
        return self + set
    }

    /** Returns the intersection of the receiver and `set`. */
    public func intersection(set: Set) -> Set
    {
        return count <= set.count ? filter { set.contains($0) }
                                  : filter { self.contains($0) }
    }

    /** Returns a new set with all elements from the receiver which are not contained in `set`. */
    public func difference(set: Set) -> Set {
        return filter { !set.contains($0) }
    }


    //
    // MARK: Set inclusion functions
    //

    /** True iff the receiver is a subset of (is included in) `set`. */
    public func subset(set: Set) -> Bool {
        return difference(set) == Set()
    }

    /** True iff the receiver is a subset of but not equal to `set`. */
    public func strictSubset(set: Set) -> Bool {
        return subset(set) && self != set
    }

    /** True iff the receiver is a superset of (includes) `set`. */
    public func superset(set: Set) -> Bool {
        return set.subset(self)
    }

    /** True iff the receiver is a superset of but not equal to `set`. */
    public func strictSuperset(set: Set) -> Bool {
        return set.strictSubset(self)
    }


    //
    // MARK: Higher-order functions
    //

    /** Returns a new set including only those elements `x` where `includeElement(x)` is true. */
    public func filter(includeElement: (T) -> Bool) -> Set<T> {
        return Set(Swift.filter(self, includeElement))
    }

    /** Returns a new set with the result of applying `transform` to each element. */
    public func map <U> (transform: T -> U) -> Set<U> {
        return flatMap { [transform($0)] }
    }

    /** Applies `transform` to each element and returns a new set which is the union of each resulting set. */
    public func flatMap <C: SequenceType>(transform: T -> C) -> Set<C.Generator.Element>
    {
        let initial = Set<C.Generator.Element>()
        return self.reduce(initial) { (var into, nextSet) in
            into.extend(transform(nextSet))
            return into
        }
    }

    /** Combines each element of the receiver with an accumulator value using `combine`, starting with `initial`. */
    public func reduce <U> (initial: U, combine: (U, T) -> U) -> U {
        return Swift.reduce(self, initial, combine)
    }
}


//
// MARK: ArrayLiteralConvertible
//

extension Set: ArrayLiteralConvertible {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

//
// MARK: SequenceType
//

extension Set: SequenceType {
    public func generate() -> GeneratorOf<T> {
        return GeneratorOf(values.keys.generate())
    }
}


//
// MARK: CollectionType
//

extension Set: CollectionType
{
    public var startIndex: DictionaryIndex<T, Unit> { return values.startIndex }
    public var endIndex:   DictionaryIndex<T, Unit> { return values.endIndex }

    public subscript(v: Unit) -> T {
        get { return values[values.startIndex].0 }
        set { insert(newValue) }
    }

    public subscript(index: DictionaryIndex<T, Unit>) -> T {
        return values[index].0
    }
}


//
// MARK: ExtensibleCollectionType
//

extension Set: ArrayLiteralConvertible
{
    /** In theory, reserve capacity for `n` elements. However, Dictionary does not implement reserveCapacity(), so we just silently ignore it. */
    public func reserveCapacity(n: Set<T>.Index.Distance) {}

    /** Inserts each element of `sequence` into the receiver. */
    public mutating func extend<S: SequenceType where S.Generator.Element == T>(sequence: S) {
        // Note that this should just be for each in sequence; this is working around a compiler crasher.
        for each in [T](sequence) {
            insert(each)
        }
    }

    /** Appends `element` onto the `Set`. */
    public mutating func append(element: T) {
        insert(element)
    }
}


//
// MARK: Hashable
//

extension Set: Hashable
{
    /**
        Hashes using Bob Jenkins’ one-at-a-time hash. (http://en.wikipedia.org/wiki/Jenkins_hash_function#one-at-a-time)
        NB: Jenkins’ usage appears to have been string keys; the usage employed here seems similar but may have subtle differences which have yet to be discovered.
     */
    public var hashValue: Int
    {
        var h = reduce(0) { into, each in
            var h = into + each.hashValue
            h += (h << 10)
            h ^= (h >> 6)
            return h
        }
        h += (h << 3)
        h ^= (h >> 11)
        h += (h << 15)
        return h
    }
}


//
// MARK: Printable, DebugPrintable
//

extension Set: Printable, DebugPrintable
{
    public var description:      String { return count > 0 ? "{" + join(", ", map(toString)) + "}" : "{}" }
    public var debugDescription: String { return description }
}


//
// MARK: - Operators
//

/** Concat. **/
public func + <T> (var lhs:Set<T>, rhs:Set<T>) -> Set<T> {
    lhs.extend(rhs)
    return lhs
}

/** Extend (in-place).  Extends `set` with the elements of `sequence`. */
public func += <S: SequenceType> (inout set: Set<S.Generator.Element>, sequence: S) {
    set.extend(sequence)
}


/** Set difference.  Returns a new set with all elements from `set` which are not contained in `other`. */
public func - <T> (set: Set<T>, other: Set<T>) -> Set<T> {
    return set.difference(other)
}

/** Removes all elements in `other` from `set`. */
public func -= <T> (inout set: Set<T>, other: Set<T>) {
    for element in other {
        set.remove(element)
    }
}


/** Intersection (in-place).  Intersects with `set` with `other`. */
public func &= <T> (inout set: Set<T>, other: Set<T>) {
    for element in set {
        if !other.contains(element) {
            set.remove(element)
        }
    }
}

/** Returns the intersection of `set` and `other`. */
public func & <T> (set: Set<T>, other: Set<T>) -> Set<T> {
    return set.intersection(other)
}


/** Defines equality for sets of equatable elements. */
public func == <T: Equatable> (a: Set<T>, b: Set<T>) -> Bool {
    return equal(a.values.keys, b.values.keys)
}





