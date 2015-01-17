//
//  Functions.Functional.swift
//  Funky
//
//  Created by bryn austin bellomy on 2014 Dec 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import LlamaKit


public func id <T> (arg:T) -> T {
    return arg
}


public func head <C: CollectionType> (collection: C) -> C.Generator.Element?
{
    if countElements(collection) > 0 {
        return collection[collection.startIndex]
    }
    return nil
}


public func tail <C: CollectionType, D: ExtensibleCollectionType where C.Generator.Element == D.Generator.Element>
    (collection: C, n: C.Index) -> D
{
    var theTail = D()
    let end = collection.endIndex
    for i in n ..< collection.endIndex {
        theTail.append(collection[i])
    }
    return theTail
}

public func collect <S: SequenceType, D: ExtensibleCollectionType where S.Generator.Element == D.Generator.Element> (seq:S) -> D
{
    var gen = seq.generate()

    var collected = D()
    while let current = gen.next() {
        collected.append(current)
    }
    return collected
}


public func equal <T: Equatable, U: Equatable> (one:(T, U), two:(T, U)) -> Bool {
    return one.0 == two.0 && one.1 == two.1
}


public func equal <S: SequenceType, T: SequenceType>
    (one:S, two:T, equality:(S.Generator.Element, T.Generator.Element) -> Bool) -> Bool
{
    var gen1 = one.generate()
    var gen2 = two.generate()

    while true
    {
        let (left, right) = (gen1.next(), gen2.next())

        if left == nil && right == nil         { return true  }
        else if (left == nil) ^ (right == nil) { return false }
        else if equality(left!, right!) == false { return false }
        else { continue }
    }
}


public func both <T, U>
    (one:T?, two:U?) -> (T, U)?
{
    return rejectEitherNil((one, two))
}


public func any <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> Bool
{
    var gen = seq.generate()
    while let next = gen.next() {
        if predicate(next) == true {
            return true
        }
    }
    return false
}


public func all <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> Bool
{
    var gen = seq.generate()
    while let next = gen.next() {
        if predicate(next) == false {
            return false
        }
    }
    return true
}


public func all <T, U, V>
    (one:T?, two:U?, three:V?) -> (T, U, V)?
{
    if let (one, two) = both(one, two) {
        if let three = three {
            return (one, two, three)
        }
    }
    return nil
}


public func all <T, U, V, W>
    (one:T?, two:U?, three:V?, four:W?) -> (T, U, V, W)?
{
    if let (one, two) = both(one, two)? {
        if let (three, four) = both(three, four)? {
            return (one, two, three, four)
        }
    }
    return nil
}


public func isSuccess <T> (result:Result<T>) -> Bool {
    return result.isSuccess()
}


public func isFailure <T> (result:Result<T>) -> Bool {
    return !isSuccess(result)
}


public func unwrapValue <T> (result: Result<T>) -> T? {
    return result.value()
}


public func unwrapError <T> (result: Result<T>) -> NSError? {
    return result.error()
}


public func zip2 <T, U> (one:T) (two:U) -> (T, U) {
    return (one, two)
}


public func zip3 <T, U, V>  (one:T) (two:U) (three:V) -> (T, U, V) {
    return (one, two, three)
}

public func zipseq <S: SequenceType, T: SequenceType>
    (one:S, two:T) -> SequenceOf<(S.Generator.Element, T.Generator.Element)>
{
    return ZipGenerator2(one.generate(), two.generate())
                |> unfold {
                    var y = $0
                    if let elem = y.next() {
                        return (elem, y)
                    }
                    return nil
                }
}


// @@TOOD: find a place to use this and see if it works (or just test `zipseq`, which uses it)
public func unfold <T, U> (closure: T -> (U, T)?) (initial:T) -> SequenceOf<U>
{
    var arr = [U]()
    var current = initial
    while let (created, next) = closure(current) {
        current = next
        arr.append(created)
    }

    return SequenceOf(arr)
}


//
//-- | The 'partition' function takes a predicate a list and returns
//-- the pair of lists of elements which do and do not satisfy the
//-- predicate, respectively; i.e.,
//--
//-- > partition p xs == (filter p xs, filter (not . p) xs)
//
//partition               :: (a -> Bool) -> [a] -> ([a],[a])
//{-# INLINE partition #-}
//partition p xs = foldr (select p) ([],[]) xs
//

public func partition <S: SequenceType, T where T == S.Generator.Element>
    (predicate:T -> Bool) (seq:S) -> ([T], [T])
{
    let start = ([T](), [T]())

    return seq |> reducer(start) { (var into, each) in
                      if predicate(each) {
                          into.0.append(each)
                      }
                      else {
                          into.1.append(each)
                      }
                      return into
                  }
}


public func contains <I: Comparable, C: CollectionType where I == C.Index>
    (c: C, range: Range<I>) -> Bool
{
    let interval: HalfOpenInterval = c.startIndex ..< c.endIndex
    return interval ~= range.startIndex && interval ~= range.endIndex
}


public func mapLeft1 <T, U, V> (transform:T -> V) (tuple:(T, U)) -> (V, U) {
    return (transform(tuple.0), tuple.1)
}


public func mapLeft <T, U, V> (transform: T -> V) (seq:[T: U]) -> [(V, U)] {
    return map(seq, mapLeft1(transform))
}


public func mapLeft <T, U, V> (transform: T -> V) (seq:[(T, U)]) -> [(V, U)] {
    return map(seq, mapLeft1(transform))
}


public func mapRight1 <T, U, V> (transform:U -> V) (tuple:(T, U)) -> (T, V) {
    return (tuple.0, transform(tuple.1))
}


public func mapRight <T, U, V> (transform: U -> V) (seq:[T: U]) -> [(T, V)] {
    return map(seq, mapRight1(transform))
}


public func mapRight <T, U, V> (transform: U -> V) (seq:[(T, U)]) -> [(T, V)] {
    return map(seq, mapRight1(transform))
}


public func mapKeys <T, U, V> (transform: T -> V) (seq:[T: U]) -> [V: U] {
    return mapLeft(transform)(seq:seq)
        |> mapToDictionary(id)
}


public func mapValues <T, U, V> (transform: U -> V) (seq:[T: U]) -> [T: V] {
    return mapRight(transform)(seq:seq)
        |> mapToDictionary(id)
}


public func makeLeft <T, U> (transform:T -> U) (value:T) -> (U, T) {
    return (transform(value), value)
}

public func makeRight <T, U> (transform:T -> U) (value:T) -> (T, U) {
    return (value, transform(value))
}


public func takeLeft <T, U> (tuple:(T, U)) -> T {
    return tuple.0
}


public func takeRight <T, U> (tuple:(T, U)) -> U {
    return tuple.1
}


public func takeFirst <S: SequenceType> (predicate: S.Generator.Element -> Bool) (seq:S) -> S.Generator.Element?
{
    for item in seq {
        if predicate(item) {
            return item
        }
    }
    return nil
}


public func selectFailures <T> (array:[Result<T>]) -> [NSError] {
    return array |> mapFilter { $0.error() }
}


public func rejectFailures <T> (source: [Result<T>]) -> [T]
{
    return source |> rejectIf({ !$0.isSuccess() })
                  |> mapFilter(unwrapValue)
}


public func rejectFailuresAndDispose <T> (disposal:NSError -> Void) (source: [Result<T>]) -> [T]
{
    return source |> rejectIfAndDispose({ !$0.isSuccess() })({ disposal($0.error()!) })
                  |> mapFilter(unwrapValue)
}


public func groupBy
    <K: Hashable, V, S: SequenceType where S.Generator.Element == V>
    (keyClosure:V -> K) (seq:S) -> [K: [V]]
{
    return reduce(seq, [K: [V]]()) { (var current, next) in
        let key: K = keyClosure(next)
        if current[key] == nil { current[key] = [V]() }
        current[key]!.append(next)
        return current
    }
}


/** Argument-reversed, curried version of `reduce()`. */
public func reducer
    <S: SequenceType, U>
    (initial:U, combine: (U, S.Generator.Element) -> U) (seq:S) -> U
{
    return reduce(seq, initial, combine)
}


/** Argument-reversed, curried version of `split()`. */
public func splitOn
    <S: Sliceable where S.Generator.Element: Equatable>
    (separator: S.Generator.Element) (collection: S) -> [S.SubSlice]
{
    return split(collection) { $0 == separator }
}


/** Curried version of `join()`. */
public func joinWith
    <C: ExtensibleCollectionType, S: SequenceType where S.Generator.Element == C>
    (separator: C) (elements: S)
        -> C
{
    return join(separator, elements)
}


/** Returns an array containing only the unique elements of `seq`. */
public func unique <S: SequenceType where S.Generator.Element : Hashable> (seq:S) -> [S.Generator.Element]
{
    var dict = Dictionary<S.Generator.Element, Bool>()
    for item in seq {
        dict[item] = true
    }
    return Array(dict.keys)
}


public func pairs <K: Hashable, V> (dict:[K: V]) -> [(K, V)] {
    return map(dict, id)
}


/** Curries a binary function. */
public func curry
    <A, B, R>
    (f: (A, B) -> R) -> A -> B -> R
{
    return { x in { y in f(x, y) }}
}


/** Curries a ternary function. */
public func curry
    <A, B, C, R>
    (f: (A, B, C) -> R) -> A -> B -> C -> R
{
    return { a in { b in { c in f(a, b, c) } } }
}


/**
    Curries a binary function and swaps the placement of the arguments.  Useful for bringing the Swift built-in collection functions into functional pipelines.  For example:

    someArray |> currySwap(map)({ $0 ... })

    (...or whatever).
 */
public func currySwap <T, U, V> (f: (T, U) -> V) -> U -> T -> V {
    return { x in { y in f(y, x) }}
}


public func isNil <T: AnyObject> (val:T?) -> Bool {
    return val === nil
}


public func isNil <T: NilLiteralConvertible> (val:T?) -> Bool {
    return val == nil
}


public func isNil <T> (val:T?) -> Bool {
    switch val {
        case .Some(let _): return true
        case .None: return false
    }
}


public func nonNil <T> (value:T?) -> Bool {
    if let value = value? {
        return true
    }
    return false
}


/** Curried function that maps a transform function over a given object and returns a 2-tuple of the form `(object, transformedObject)`. */
public func zipMap <T, U> (transform: T -> U) (object: T) -> (T, U)
{
    let transformed = transform(object)
    return (object, transformed)
}


/** Curried function that maps a transform function over the first (or left) element of a tuple. */
public func zipMapLeft <T, U> (transform: T -> U) (object: T) -> (U, T)
{
    let transformed = transform(object)
    return (transformed, object)
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an array of 2-tuples of the form `(object, transformedObject)`.  If the transform function returns nil for a given element in the collection, the tuple for that element will not be included in the returned `Array`.
 */
public func zipFilter
    <C: CollectionType, T>
    (transform: C.Generator.Element -> T?) (source: C) -> [(C.Generator.Element, T)]
{
    let zipped_or_nil : (C.Generator.Element) -> (C.Generator.Element, T)? = zipFilter(transform)
    return source |> mapFilter(zipped_or_nil)
}


/**
    Curried function that maps a transform function over a given object and returns an `Optional` 2-tuple of the form `(object, transformedObject)`.  If the transform function returns nil, this function will also return nil.
 */
public func zipFilter <T, U> (transform: T -> U?) (object: T) -> (T, U)?
{
    if let transformed = transform(object)? {
        return (object, transformed)
    }
    else { return nil }
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an `Array` of 2-tuples of the form `(object, transformedObject)`.
 */
public func zipMap <C: CollectionType, T> (transform: C.Generator.Element -> T) (source: C) -> [(C.Generator.Element, T)] {
    let theZip = zipMap(transform)
    return map(source, theZip)
}

/**
    Curried function that maps a transform function over a `CollectionType` and returns an `Array` of 2-tuples of the form `(object, transformedObject)`.
 */
public func zipMapLeft <C: CollectionType, T> (transform: C.Generator.Element -> T) (source: C) -> [(T, C.Generator.Element)] {
    let theZip = zipMapLeft(transform)
    return map(source, theZip)
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.
 */
public func select <S: SequenceType> (predicate: S.Generator.Element -> Bool) (seq: S) -> [S.Generator.Element] {
    return filter(seq, predicate)
}

/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.
 */
public func select <K, V> (predicate: (K, V) -> Bool) (dict: [K: V]) -> [K: V] {
    return dict |> pairs |> select(predicate) |> mapToDictionary(id)
}


/**
    A curried, argument-reversed version of `map` for use in functional pipelines.  For example:

    `let descriptions = someCollection |> mapr { $0.description }`

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The transformed collection.
*/
public func mapr <S: SequenceType, T> (transform: S.Generator.Element -> T) (source: S) -> [T] {
    return map(source, transform)
}

/**
    Curried function that maps a transform function over a sequence and filters nil values from the resulting collection before returning it.  Note that you must specify the generic parameter `D` (the return type) explicitly.  Small pain in the ass for the lazy, but it lets you ask for any kind of `ExtensibleCollectionType` that you could possibly want.

    :param: transform The transform function.
    :param: source The sequence to map.
    :returns: An `ExtensibleCollectionType` of your choosing.
 */
public func mapFilter <S: SequenceType, D: ExtensibleCollectionType> (transform: (S.Generator.Element) -> D.Generator.Element?) (source: S) -> D
{
    var result = D()
    for x in source {
        if let y = transform(x) {
            result.append(y)
        }
    }
    return result
}


/**
    Curried function that maps a transform function over a sequence and filters nil values from the resulting `Array` before returning it.

    :param: transform The transform function.
    :param: source The sequence to map.
    :returns: An `Array` with the mapped, non-nil values from the input sequence.
 */
public func mapFilter <S: SequenceType, T> (transform: S.Generator.Element -> T?) (source: S) -> [T]
{
    var result = [T]()
    for x in source {
        if let mapped = transform(x) {
            result.append(mapped)
        }
    }
    return result
}


public func rejectIf <S: SequenceType, T where S.Generator.Element == T> (predicate:T -> Bool) (source: S) -> [T]
{
    var results = [T]()
    for x in source
    {
        if !predicate(x) {
            results.append(x)
        }
    }
    return results
}


public func rejectIfAndDispose
    <S: SequenceType, T where S.Generator.Element == T>
    (predicate:T -> Bool) (disposal:T -> Void) (source: S) -> [T]
{
    var results = [T]()
    for x in source
    {
        if !predicate(x) {
            results.append(x)
        }
        else {
            disposal(x)
        }
    }
    return results
}


/**
    A curried, argument-reversed version of `each` used to create side-effects in functional
    pipelines.  Note that it returns the collection, `source`, unmodified.  This is to facilitate
    fluent chaining of such pipelines.  For example:

    someCollection |> doEach { println("the object is \($0)") }
                   |> mapr    { $0.description }
                   |> doEach { println("the object's description is \($0)") }

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The collection, unmodified.
 */
public func doEach<S : SequenceType, T>(closure: S.Generator.Element -> T)(source: S) -> S {
    for item in source {
        closure(item)
    }
    return source
}


public func doSide<T, X>(closure: T -> X)(data: T) -> T {
    closure(data)
    return data
}


public func doSide2<T, U, X>(closure: (T, U) -> X)(one:T, two:U) -> (T, U) {
    closure(one, two)
    return (one, two)
}


public func doSide3<T, U, V, X>(closure: (T, U, V) -> X)(one:T, two:U, three:V) -> (T, U, V) {
    closure(one, two, three)
    return (one, two, three)
}


/**
    Rejects nil elements from the provided collection.

    :param: collection The collection to filter.
    :returns: The collection with all `nil` elements removed.
*/
public func rejectNil<T>(collection: [T?]) -> [T]
{
    var nonNilValues = [T]()
    for item in collection
    {
        if nonNil(item) {
            nonNilValues.append(item!)
        }
    }
    return nonNilValues
}



/**
    Returns nil if either value in the provided 2-tuple is nil.  Otherwise, returns the input tuple with its inner `Optional`s flattened (in other words, the returned tuple is guaranteed by the type-checker to have non-nil elements).

    :param: tuple The tuple to examine.
    :returns: The tuple or nil.
*/
public func rejectEitherNil <T, U>
    (tuple: (T?, U?)) -> (T, U)?
{
    // have to use if-let clauses to recursively flatten Optional types in a single statement
    if let zero = tuple.0? {
        if let one = tuple.1? {
            return (zero, one)
        }
    }
    return nil
}


/**
    Rejects tuple elements from the provided collection if either value in the tuple is nil.

    :param: collection The collection to filter.
    :returns: The provided collection with all tuples containing a `nil` element removed.
*/
public func rejectEitherNil <T, U>
    (collection: [(T?, U?)]) -> [(T, U)]
{
    return reduce(collection, Array<(T, U)>()) { (var nonNilValues, item) in
        if nonNil(item.0) && nonNil(item.1) {
            nonNilValues.append((item.0!, item.1!))
        }
        return nonNilValues
    }
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    :param: keySelector A function taking an element of `array` and returning the key for that element in the returned dictionary.
    :returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func mapToDictionaryKeys <K: Hashable, S: SequenceType>
    (keySelector:S.Generator.Element -> K)
    (seq:S) -> [K: S.Generator.Element]
{
    var result: [K: S.Generator.Element] = [:]
    for item in seq {
        result[keySelector(item)] = item
    }
    return result
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    :param: keySelector A function taking an element of `array` and returning the key for that element in the returned dictionary.
    :returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func mapToDictionary <K: Hashable, V, S: SequenceType>
    (transform: S.Generator.Element -> (K, V))
    (seq: S) -> [K: V]
{
    var result: [K: V] = [:]
    for item in seq {
        let (key, value) = transform(item)
        result[key] = value
    }
    return result
}


/**
    Iterates through `domain` and returns the index of the first element for which `predicate(element)` returns `true`.

    :param: domain The collection to search.
    :returns: The index of the first matching item,  or `nil` if none was found.
 */
public func find <C: CollectionType where C.Generator.Element: Equatable>
    (domain: C, predicate: (C.Generator.Element) -> Bool) -> C.Index?
{
    var maybeIndex: C.Index? = domain.startIndex
    do
    {
        if let index = maybeIndex?
        {
            let item = domain[index]
            if predicate(item) == true {
                return index
            }

            maybeIndex = index.successor()
        }

    } while maybeIndex != nil

    return nil
}



public func findWhere <C: CollectionType where C.Generator.Element: Equatable>
    (domain: C, predicate: (C.Generator.Element) -> Bool) -> C.Index?
{
    var maybeIndex : C.Index? = domain.startIndex
    do
    {
        if let index = maybeIndex
        {
            let item = domain[index]
            if predicate(item) {
                return index
            }

            maybeIndex = index.successor()
        }

    } while maybeIndex != nil

    return nil
}



/**
    Converts an array of tuples of type `(K, V)` to a dictionary of type `[K : V]`.

    :param: array The array to convert.
    :returns: A dictionary.
 */
public func mapTupleArrayToDictionary <E: Hashable, F> (array:[(E, F)]) -> [E : F]
{
    var result: [E : F] = [:]
    for item in array {
        result[item.0] = item.1
    }
    return result
}



// got this from http://www.objc.io/snippets/

public func decompose <T> (array:[T]) -> (head: T, tail: [T])?
{
    let theTail = array[1 ..< array.count]
    if array.count > 0 {
        return (array.first!, tail(array, 1))
    }
    return nil
}





public func valueForKeypath <K: Hashable, V> (dictionary:[K: V], keypath:[K]) -> V?
{
    let currentKey = keypath[0]
    if let currentValue = dictionary[currentKey]?
    {
        if keypath.count == 1 {
            return currentValue
        }
        else {
            if let innerDict = currentValue as? [K: V] {
                let newKeypath = Array(keypath[ 1 ..< keypath.endIndex ])
                return valueForKeypath(innerDict, newKeypath)
            }
        }
    }
    return nil
}


public func mapIfIndex
    <S: SequenceType, C: ExtensibleCollectionType where S.Generator.Element == C.Generator.Element>
    (source: S, transform: (S.Generator.Element) -> S.Generator.Element, ifIndex: Int -> Bool)
        -> C
{
        var result = C()
        for (index,value) in enumerate(source) {
            if ifIndex(index) {
                result.append(transform(value))
            }
            else {
                result.append(value)
            }
        }
        return result
}



public func mapEveryNth
    < S: SequenceType, C: ExtensibleCollectionType
      where S.Generator.Element == C.Generator.Element >
    (source: S, n: Int, transform: S.Generator.Element -> C.Generator.Element)
    -> C
{
    // enumerate starts from zero, so for this to work with the nth element,
    // and not the 0th, n+1th etc, we need to add 1 to the ifIndex check:
    let isNth = { ($0 + 1) % n == 0 }

    return mapIfIndex(source, transform, isNth)
}






