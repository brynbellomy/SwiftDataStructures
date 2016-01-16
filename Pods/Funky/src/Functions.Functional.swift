//
//  Functions.Functional.swift
//  Funky
//
//  Created by bryn austin bellomy on 2014 Dec 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


// @@TODO: move these homeless funcs

/**
    Simple wrapper for `dispatch_after` that simplifies the most common use case (i.e., dispatch this block after X number of seconds).
 */
public func after (seconds seconds:NSTimeInterval, onQueue queue:dispatch_queue_t, execute block:dispatch_block_t)
{
    let time = dispatch_time(DISPATCH_TIME_NOW as dispatch_time_t, Int64(UInt64(seconds) * NSEC_PER_SEC))
    dispatch_after(time, queue, block)
}


/**
    Randomly chooses a date in between `startDate` and `endDate` and returns it.
 */
public func randomDate (between startDate:NSDate, and endDate:NSDate) -> NSDate {
    let timespan     = Float(startDate.timeIntervalSinceNow - endDate.timeIntervalSinceNow)
    let rouletteBall = NSTimeInterval(random(0, max:timespan))

    return NSDate(timeIntervalSince1970: startDate.timeIntervalSince1970 + rouletteBall)
}

/**
    Randomly chooses an item from the given array and returns it.
 */
public func chooseRandomly <T> (arr:[T]) -> T {
    let rouletteBall = random(0, max: Float(arr.count))
    let chosenIndex  = Int(trunc(rouletteBall))
    return arr[chosenIndex]
}



/**
    The identity function.  Returns its argument.
 */
public func id <T> (arg:T) -> T {
    return arg
}

/**
    Returns a function that always returns `arg`, regardless of what argument is passed into it.
 */
public func constant <T, U> (arg:T) -> (U -> T) {
    return { (ignored:U) -> T in arg }
}


/**
    Returns the first element of `collection` or `nil` if `collection` is empty.
 */
public func head
    <C: CollectionType>
    (collection: C) -> C.Generator.Element?
{
    if collection.count > 0 {
        return collection[collection.startIndex]
    }
    return nil
}


/**
    Returns a collection containing all but the first element of `collection`.
 */
public func tail
    <C: CollectionType, D: RangeReplaceableCollectionType where C.Generator.Element == D.Generator.Element>
    (collection: C) -> D
{
    return tail(collection, n: collection.startIndex.successor())
}


/**
    Returns a collection containing all but the first `n` elements of `collection`.
 */
public func tail
    <C: CollectionType, D: RangeReplaceableCollectionType where C.Generator.Element == D.Generator.Element>
    (collection: C, n: C.Index) -> D
{
    var theTail = D()
    for i in n ..< collection.endIndex {
        theTail.append(collection[i])
    }
    return theTail
}


/**
    Simple syntax sugar for the `SequenceOf` constructor, because constructors can't be
    curried (yet).  Wraps the given `collection` in a type-erased sequence.
 */
public func toSequence <C: CollectionType>
    (collection: C) -> AnySequence<C.Generator.Element> {
    return AnySequence(collection)
}


/**
    Simple syntax sugar for the `GeneratorSequence` constructor, because constructors
    can't be curried (yet). Wraps the given `generator` in a type-erased sequence.

    For example:

        for x in someGenerator |> toSequence {
             // ...
        }

 */
public func toSequence <G: GeneratorType>
    (generator: G) -> GeneratorSequence<G> {
    return GeneratorSequence(generator)
}


/**
    Collects a sequence (`SequenceType`) into a collection (`ExtensibleCollectionType`).  The
    specific type of collection you want returned must be made obvious to the type-checker.

    For example:

        let seq: SequenceOf<User> = ...
        let array: [User] = seq |> toCollection

 */
public func toCollection
    <S: SequenceType, D: RangeReplaceableCollectionType where S.Generator.Element == D.Generator.Element>
    (seq:S) -> D
{
    var gen = seq.generate()

    var collected = D()
    while let current = gen.next() {
        collected.append(current)
    }
    return collected
}


/**
    Simply calls `Array(collection)` — however, because constructors cannot be applied like
    normal functions, this is more convenient in functional pipelines.
 */
public func toArray <S: SequenceType>
    (seq:S) -> [S.Generator.Element]
{
    return Array(seq)
}


/**
    Simply calls `Array(collection)` — however, because constructors cannot be applied like
    normal functions, this is more convenient in functional pipelines.
 */
public func toArray <C: CollectionType>
    (collection:C) -> [C.Generator.Element]
{
    return Array(collection)
}


/**
    Simply calls `Set(collection)` — however, because constructors cannot be applied like
    normal functions, this is more convenient in functional pipelines.
 */
public func toSet
    <C: CollectionType>
    (collection:C) -> Set<C.Generator.Element>
{
    return Set(collection)
}


/**
    Returns `true` iff `one.0` == `two.0` and `one.1` == `two.1`.
 */
public func equalTuples
    <T: Equatable, U: Equatable>
    (one: (T, U), two: (T, U)) -> Bool
{
    return one.0 == two.0 && one.1 == two.1
}


/**
    Returns `true` iff the corresponding elements of sequences `one` and `two` all satisfy
    the provided `equality` predicate.
 */
public func equalSequences
    <S: SequenceType, T: SequenceType>
    (one:S, _ two:T, _ equality:(S.Generator.Element, T.Generator.Element) -> Bool) -> Bool
{
    var gen1 = one.generate()
    var gen2 = two.generate()

    while true
    {
        let (left, right) = (gen1.next(), gen2.next())

        if left == nil && right == nil                                            { return true  }
        else if (left == nil) || (right == nil) && !(left == nil && right == nil) { return false }
        else if equality(left!, right!) == false                                  { return false }
        else { continue }
    }
}


/**
    If both of the arguments passed to `both()` are non-`nil`, it returns its arguments as a
    tuple (wrapped in an `Optional`).  Otherwise, it returns `nil`.
*/
public func both
    <T, U>
    (one:T?, _ two:U?) -> (T, U)?
{
    if let one = one, two = two {
        return (one, two)
    }
    return nil
}


/**
    If any of the elements of `seq` satisfy `predicate`, `any()` returns `true`.  Otherwise, it
    returns `false`.
*/
public func any
    <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (_ seq: S) -> Bool
{
    var gen = seq.generate()
    while let next = gen.next() {
        if predicate(next) == true {
            return true
        }
    }
    return false
}


/**
    If all of the elements of `seq` satisfy `predicate`, `all()` returns `true`.  Otherwise,
    it returns `false`.
*/
public func all
    <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (_ seq: S) -> Bool
{
    var gen = seq.generate()
    while let next = gen.next() {
        if predicate(next) == false {
            return false
        }
    }
    return true
}


/**
    If all of the arguments passed to `all()` are non-`nil`, it returns its arguments as a
    tuple (wrapped in an `Optional`).  Otherwise, it returns `nil`.
*/
public func all
    <T, U, V>
    (one:T?, two:U?, three:V?) -> (T, U, V)?
{
    if let one = one, two = two, three = three {
        return (one, two, three)
    }
    return nil
}


/**
    If all of the arguments passed to `all()` are non-`nil`, it returns its arguments as a
    tuple (wrapped in an `Optional`).  Otherwise, it returns `nil`.
*/
public func all
    <T, U, V, W>
    (one:T?, two:U?, three:V?, four:W?) -> (T, U, V, W)?
{
    if let one = one, two = two, three = three, four = four {
        return (one, two, three, four)
    }
    return nil
}


/**
    Curried function that returns its arguments zipped together into a 2-tuple.
 */
public func zip2 <T, U> (one:T) (two:U) -> (T, U) {
    return (one, two)
}


/**
    Curried function that returns its arguments zipped together into a 3-tuple.
 */
public func zip3 <T, U, V>  (one:T) (two:U) (three:V) -> (T, U, V) {
    return (one, two, three)
}


/**
    Merges the provided sequences into a sequence of tuples containing their respective elements.
 */
public func zipseq
    <S: SequenceType, T: SequenceType>
    (one:S, _ two:T) -> AnySequence<(S.Generator.Element, T.Generator.Element)>
{
    return Zip2Generator(one.generate(), two.generate())
                |> unfold { (var generator) in both(generator.next(), generator) }
}


/**
    Eagerly creates a sequence out of a generator by calling the generator's `next()` method until
    it returns `nil`.  Do not call this on an infinite sequence.

    - returns: A sequence containing the elements returned by the generator.
 */
public func unfoldGenerator <G: GeneratorType> (gen:G) -> AnySequence<G.Element> {
    return gen |> unfold { (var generator) in both(generator.next(), generator) }
}


/**
    Creates a new sequence using an initial value and a generator closure.  The closure is called
    repeatedly to obtain the elements of the sequence.  The sequence is returned as soon as the
    closure returns `nil`.

    - parameter closure: The closure takes as its only argument the `T` value it returned on its last iteration.  It should return either `nil` (if the unfolding should stop), or a 2-tuple `(U, T)` where the first element is a new element of the sequence, and the second element is thevalue to pass to `closure` on the next iteration.
    - parameter initial: The value to pass to `closure` the first time it's called.
 */
public func unfold <T, U>
    (closure: T -> (U, T)?) (initial:T) -> AnySequence<U>
{
    var arr = [U]()
    var current = initial
    while let (created, next) = closure(current) {
        current = next
        arr.append(created)
    }

    return AnySequence(arr)
}


/**
    Very abstractly represents an iterative process that builds up a sequence.

    Calls `closure` on `initial` (and afterwards, always on the previous return value of `closure`) and
    stops after `count` iterations.

    The returned sequence is built up out of the left element of the tuple returned by `closure`.  The
    right element of the tuple returned by `closure` is intended for passing state to the next iteration.

    - returns: A sequence containing the left/first element of each tuple returned by `closure`.
 */
public func unfold <T, U>
    (count: Int, closure: T -> (U, T)?) (initial: T) -> AnySequence<U>
{
    var arr = [U]()
    var current = initial

    for _ in 0 ..< count{
        guard let (created, next) = closure(current) else {
            break
        }
        current = next
        arr.append(created)
    }

    return AnySequence(arr)
}



/**
    Takes a predicate and a sequence and returns the pair of arrays of elements which do and do not satisfy the
    predicate, respectively; i.e.,
 */

public func partition
    <S: SequenceType, T where T == S.Generator.Element>
    (predicate:T -> Bool) (_ seq:S) -> (Array<T>, Array<T>)
{
    let start = (Array<T>(), Array<T>())

    return seq |> reducer(start) { (var into, each) in
                      predicate(each) ? into.0.append(each)
                                      : into.1.append(each)
                      return into
                  }
}


/**
    Returns `true` iff `range` contains only valid indices of `collection`.
 */
public func containsIndices
    <I: Comparable, C: CollectionType where I == C.Index>
    (collection: C, _ range: Range<I>) -> Bool
{
    let interval: HalfOpenInterval = collection.startIndex ..< collection.endIndex
    return interval ~= range.startIndex && interval ~= range.endIndex
}


/**
    Applies `transform` to the first element of `tuple` and returns the resulting tuple.
 */
public func mapLeft1
    <T, U, V>
    (transform: T -> V) (_ tuple: (T, U)) -> (V, U)
{
    return (transform(tuple.0), tuple.1)
}


/**
    Applies `transform` to the key of each element of `dict` and returns the resulting
    sequence of key-value tuples as an `Array`.  If you need a dictionary instead of a
    tuple array, simply pass the return value of this function through `mapDictionary { $0 }`.
 */
public func mapLeft
    <T, U, V>
    (transform: T -> V) (_ dict: [T: U]) -> [(V, U)]
{
    return dict.map { mapLeft1(transform)($0) }
}


/**
    Applies `transform` to the first (`0`th) element of each tuple in `seq` and returns the
    resulting `Array` of tuples.
 */
public func mapLeft
    <T, U, V>
    (transform: T -> V) (_ seq: [(T, U)]) -> [(V, U)]
{
    return seq.map(mapLeft1(transform))
}


public func mapRight1
    <T, U, V>
    (transform: U -> V) (_ tuple: (T, U)) -> (T, V)
{
    return (tuple.0, transform(tuple.1))
}


/**
    Applies `transform` to the value of each key-value pair in `dict`, transforms the pairs into
    tuples, and returns the resulting `Array` of tuples.
 */
public func mapRight
    <T, U, V>
    (transform: U -> V) (_ dict: [T: U]) -> [(T, V)]
{
    return dict.map(mapRight1(transform))
}


/**
    Applies `transform` to the second element of each 2-tuple in `seq` and returns the resulting
    `Array` of tuples.
 */
public func mapRight
    <T, U, V>
    (transform: U -> V) (_ seq:[(T, U)]) -> [(T, V)]
{
    return seq.map(mapRight1(transform))
}


public func mapKeys
    <T, U, V>
    (transform: T -> V) (_ dict:[T: U]) -> [V: U]
{
    return dict |> mapLeft(transform)
                |> mapToDictionary(id)
}


public func mapValues
    <T, U, V>
    (transform: U -> V) (_ dict:[T: U]) -> [T: V]
{
    return dict |> mapRight(transform)
                |> mapToDictionary(id)
}


public func makeLeft
    <T, U>
    (transform:T -> U) (_ value:T) -> (U, T)
{
    return (transform(value), value)
}


/** I wish my LIFE had a "makeRight()" function */
public func makeRight
    <T, U>
    (transform:T -> U) (_ value:T) -> (T, U)
{
    return (value, transform(value))
}


public func takeLeft
    <T, U>
    (tuple: (T, U)) -> T
{
    return tuple.0
}


public func takeRight
    <T, U>
    (tuple: (T, U)) -> U
{
    return tuple.1
}



/**
    First element of the sequence.

    - returns: First element of the sequence if present
 */
public func takeFirst <S: SequenceType>
    (seq:S) -> S.Generator.Element?
{
    var generator = seq.generate()
    return generator.next()
}

/**
    Checks if call returns true for any element of `seq`.

    - parameter call: Function to call for each element
    - returns: True if call returns true for any element of self
 */
public func any <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (seq: S) -> Bool
{
    var generator = seq.generate()
    while let nextItem = generator.next()
    {
        if predicate(nextItem) {
            return true
        }
    }
    return false
}

/**
    Subsequence from `n` to the end of the sequence.

    - parameter n: Number of elements to skip
    - returns: Sequence from n to the end
 */
public func skip <S: SequenceType>
    (n: Int) (seq: S) -> AnySequence<S.Generator.Element>
{
    var gen = seq.generate()
    return AnySequence { Void -> S.Generator in
        for _ in 0 ..< n {
            _ = gen.next()
        }
        return gen
    }
}


/**
    Object at the specified index if exists.

    - parameter index:
    - returns: Object at index in sequence, `nil` if index is out of bounds
 */
public func takeIndex <S: SequenceType>
    (index: Int) (seq: S) -> S.Generator.Element?
{
    return seq |> skip(index) |> takeFirst
}

/**
    Objects in the specified range.

    - parameter range:
    - returns: Subsequence in range
*/
func takeRange <S: SequenceType>
    (range: Range<Int>) (seq: S) -> AnySequence<S.Generator.Element>
{
    let count = range.endIndex - range.startIndex
    return seq  |> skip(range.startIndex)
                |> take(count)
}


/**
    Skips the elements in the sequence up until the condition returns false.

    - parameter condition: A function which returns a boolean if an element satisfies a given condition or not.
    - parameter seq: The sequence.
    - returns: Elements of the sequence starting with the element which does not meet the condition.
 */
public func skipWhile <S: SequenceType>
    (condition: S.Generator.Element -> Bool) (_ seq: S) -> AnySequence<S.Generator.Element>
{
    var gen = seq.generate()
    var checkingGenerator = seq.generate()

    var keepSkipping = true

    while keepSkipping {
        let nextItem = checkingGenerator.next()
        keepSkipping = nextItem != nil ? condition(nextItem!) : false

        if keepSkipping {
            _ = gen.next()
        }
    }

    return AnySequence(anyGenerator(gen))
}



/**
    Returns the elements of the sequence up until an element does not meet the condition.

    - parameter condition: A function which returns a boolean if an element satisfies a given condition or not.
    - parameter seq: The sequence.
    - returns: Elements of the sequence up until an element does not meet the condition.
 */
public func takeWhile <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (_ seq: S) -> AnySequence<S.Generator.Element>
{
    let tw = takeWhileGenerator(seq, predicate:predicate)
    return AnySequence(tw)
}


public func takeWhileGenerator <S: SequenceType>
    (seq: S, predicate:S.Generator.Element -> Bool) -> AnyGenerator<S.Generator.Element>
{
    var gen = seq.generate()
    var endConditionMet = false

    return anyGenerator {
        if let next = gen.next() {
            if !endConditionMet {
                endConditionMet = !predicate(next)
            }

            return endConditionMet ? nil : next
        }
        return nil
    }
}


/**
    Takes the first `n` elements of `seq`.
 */
public func take <S: SequenceType>
    (n: Int) (_ seq: S) -> AnySequence<S.Generator.Element>
{
    return AnySequence(takeGenerator(seq, n:n))
}


public func takeGenerator <S: SequenceType>
    (seq: S, n: Int) -> AnyGenerator<S.Generator.Element>
{
    var count = 0
    return takeWhileGenerator(seq) { elem in
        ++count <= n
    }
}


public func groupBy
    <K: Hashable, V, S: SequenceType where S.Generator.Element == V>
    (keyClosure:V -> K) (_ seq:S) -> [K: [V]]
{
    return seq.reduce([K: [V]]()) {
        (var current, next) in

        let key: K = keyClosure(next)
        if current[key] == nil { current[key] = [V]() }
        current[key]!.append(next)
        return current
    }
}


/**
    Argument-reversed, curried version of `reduce()`.
 */
public func reducer
    <S: SequenceType, U>
    (initial:U, combine: (U, S.Generator.Element) -> U) (_ seq:S) -> U
{
    return seq.reduce(initial, combine: combine)
}


/**
    Returns an array containing only the unique elements of `seq`.
 */
public func unique
    <S: SequenceType where S.Generator.Element: Hashable>
    (seq:S) -> [S.Generator.Element]
{
    var dict = Dictionary<S.Generator.Element, Bool>()
    for item in seq {
        dict[item] = true
    }
    return Array(dict.keys)
}


/**
    Curries a binary function.
 */
public func curry <A, B, R>
    (f: (A, B) -> R) -> A -> B -> R
{
    return { x in { y in f(x, y) }}
}


/**
    Curries a ternary function.
 */
public func curry <A, B, C, R>
    (f: (A, B, C) -> R) -> A -> B -> C -> R
{
    return { a in { b in { c in f(a, b, c) } } }
}


/**
    Curries a binary function and swaps the placement of the arguments.  Useful for
    bringing the Swift built-in collection functions into functional pipelines.

    For example:

        someArray |> currySwap(map)({ $0 ... })

    See also the `‡` operator, which is equivalent and more concise:

        someArray |> mapTo { $0 ... })

 */
public func currySwap
    <T, U, V>
    (f: (T, U) -> V) -> U -> T -> V
{
    return { x in { y in f(y, x) }}
}


/**
    Returns `true` if `value` is `nil`, `false` otherwise.
 */
public func isNil <T: AnyObject> (val:T?) -> Bool {
    return val === nil
}


/**
    Returns `true` if `value` is `nil`, `false` otherwise.
 */
public func isNil <T: NilLiteralConvertible> (val:T?) -> Bool {
    return val == nil
}


/**
    Returns `true` if `value` is `nil`, `false` otherwise.
 */
public func isNil <T> (val:T?) -> Bool
{
    switch val {
        case .Some: return true
        case .None: return false
    }
}


/**
    Returns `true` if `value` is non-`nil`, `false` otherwise.
 */
public func nonNil <T> (value:T?) -> Bool {
    if let _ = value {
        return true
    }
    return false
}


/**
    Curried function that maps a transform function over a given object and
    returns a 2-tuple of the form `(object, transformedObject)`.
 */
public func zipMap <T, U>
    (transform: T -> U) (object: T) -> (T, U)
{
    let transformed = transform(object)
    return (object, transformed)
}


/**
    Curried function that maps `transform` over `object` and returns an unlabeled 2-tuple of the
    form `(transformedObject, object)`.
 */
public func zipMapLeft
    <T, U>
    (transform: T -> U) (object: T) -> (U, T)
{
    let transformed = transform(object)
    return (transformed, object)
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an array
    of 2-tuples of the form `(object, transformedObject)`.  If `transform` returns `nil` for a given
    element in the collection, the tuple for that element will not be included in the returned `Array`.
 */
public func zipFilter
    <C: CollectionType, T>
    (transform: C.Generator.Element -> T?) (source: C) -> [(C.Generator.Element, T)]
{
    let zipped_or_nil : (C.Generator.Element) -> (C.Generator.Element, T)? = zipFilter(transform)
    return source |> mapFilter(zipped_or_nil)
}


/**
    Curried function that maps a transform function over a given object and returns an `Optional` 2-tuple
    of the form `(object, transformedObject)`.  If `transform` returns `nil`, this function will also
    return `nil`.
 */
public func zipFilter <T, U> (transform: T -> U?) (object: T) -> (T, U)?
{
    if let transformed = transform(object) {
        return (object, transformed)
    }
    else { return nil }
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an `Array` of
    2-tuples of the form `(object, transformedObject)`.
 */
public func zipMap <C: CollectionType, T> (transform: C.Generator.Element -> T) (source: C) -> [(C.Generator.Element, T)] {
    let theZip = zipMap(transform)
    return source.map(theZip)
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an `Array` of
    2-tuples of the form `(object, transformedObject)`.
 */
public func zipMapLeft
    <C: CollectionType, T>
    (transform: C.Generator.Element -> T) (source: C) -> [(T, C.Generator.Element)]
{
    let theZip = zipMapLeft(transform)
    return source.map(theZip)
}


/**
    Decomposes a `Dictionary` into a lazy sequence of key-value tuples.
 */
public func pairs <K: Hashable, V>
    (dict:[K: V]) -> LazySequence<AnySequence<(K, V)>>
{
    return AnySequence(dict).lazy
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.  The return type
    must be explicitly specified, as this function is capable of returning any `ExtensibleCollectionType`.

    - returns: A collection of type `D` containing the elements of `seq` that satisfied `predicate`.
 */
public func selectWhere
    <S: SequenceType, D: RangeReplaceableCollectionType where S.Generator.Element == D.Generator.Element>
    (predicate: S.Generator.Element -> Bool) (_ seq: S) -> D
{
    var keepers = D()
    for item in seq {
        if predicate(item) == true {
            keepers.append(item)
        }
    }
    return keepers
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.

    - returns: An `Array` containing the elements of `seq` that satisfied `predicate`.
 */
public func selectArray <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (_ seq: S) -> Array<S.Generator.Element>
{
    return selectWhere(predicate)(seq)
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.
 */
public func selectWhere <K, V> (predicate: (K, V) -> Bool) (dict: [K: V]) -> [K: V] {
    let arr: [(K, V)] = dict |> pairs |> selectWhere(predicate)
    return arr |> mapToDictionary(id)
}

public func countWhere <S: SequenceType>
    (predicate: S.Generator.Element -> Bool) (_ seq: S) -> Int
{
    return (seq |> selectArray(predicate)).count
}


/**
    A curried, argument-reversed version of `map` for use in functional pipelines.  For example:

        let descriptions = someCollection |> mapTo { $0.description }

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The transformed collection.
 */
public func mapTo
    <S: SequenceType, T>
    (transform: S.Generator.Element -> T) (source: S) -> [T]
{
    return source.map(transform)
}



/**
    Curried function that maps a transform function over a sequence and filters nil values from the
    resulting collection before returning it.  Note that you must specify the generic parameter `D`
    (the return type) explicitly.  Small pain in the ass for the lazy, but it lets you ask for any
    kind of `ExtensibleCollectionType` that you could possibly want.

    - parameter transform: The transform function.
    - parameter source: The sequence to map.
    - returns: An `ExtensibleCollectionType` of your choosing.
 */
public func mapFilter
    <S: SequenceType, D: RangeReplaceableCollectionType>
    (transform: S.Generator.Element -> D.Generator.Element?) (source: S) -> D
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
    Curried function that maps a transform function over a sequence and filters `nil` values
    from the resulting `Array` before returning it.

    - parameter transform: The transform function.
    - parameter source: The sequence to map.
    - returns: An `Array` with the mapped, non-nil values from the input sequence.
 */
public func mapFilter
    <S: SequenceType, T>
    (transform: S.Generator.Element -> T?) (source: S) -> [T]
{
    var result = [T]()
    for x in source {
        if let mapped = transform(x) {
            result.append(mapped)
        }
    }
    return result
}


/**
    Curried function that rejects elements from `source` if they satisfy `predicate`.  The
    filtered sequence is returned as an `Array`.
 */
public func rejectIf
    <S: SequenceType, T where S.Generator.Element == T>
    (predicate:T -> Bool) (source: S) -> [T]
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


/**
    Curried function that rejects values from `source` if they satisfy `predicate`.  Any
    time a value is rejected, `disposal(value)` is called.  The filtered sequence is
    returned as an `Array`.  This function is mainly useful for logging failures in
    functional pipelines.

    - parameter predicate: The predicate closure to which each sequence element is passed.
    - parameter disposal: The disposal closure that is invoked with each rejected element.
    - parameter source: The sequence to filter.
    - returns: The filtered sequence as an `Array`.
 */
public func rejectIfAndDispose
    <S: SequenceType, T where S.Generator.Element == T>
    (predicate:T -> Bool) (_ disposal:T -> Void) (source: S) -> [T]
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

    <pre>
    someCollection |> doEach { println("the object is \($0)") }
                   |> mapTo    { $0.description }
                   |> doEach { println("the object's description is \($0)") }
    </pre>

    - parameter transform: The transformation function to apply to each incoming element.
    - parameter source: The collection to transform.
    - returns: The collection, unmodified.
 */
public func doEach
    <S: SequenceType, T>
    (closure: S.Generator.Element -> T) (source: S) -> S
{
    for item in source {
        closure(item)
    }
    return source
}


/**
    Invokes a closure containing side effects, ignores the return value of `closure`,
    and returns the value of its argument `data`.
 */
public func doSide
    <T, X>
    (closure: T -> X) (data: T) -> T
{
    closure(data)
    return data
}


/**
    Invokes a closure containing side effects, ignores the return value of `closure`,
    and returns the value of its argument `data`.
 */
public func doSide2
    <T, U, X>
    (closure: (T, U) -> X) (one:T, two:U) -> (T, U)
{
    closure(one, two)
    return (one, two)
}


/**
    Invokes a closure containing side effects, ignores the return value of `closure`,
    and returns the value of its argument `data`.
 */
public func doSide3
    <T, U, V, X>
    (closure: (T, U, V) -> X) (one:T, two:U, three:V) -> (T, U, V)
{
    closure(one, two, three)
    return (one, two, three)
}


/**
    Rejects nil elements from the provided collection.

    - parameter collection: The collection to filter.
    - returns: The collection with all `nil` elements removed.
*/
public func rejectNil
    <T>
    (collection: [T?]) -> [T]
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
    Returns `nil` if either value in the provided 2-tuple is `nil`.  Otherwise, returns the input tuple with
    its inner `Optional`s flattened (in other words, the returned tuple is guaranteed by the type-checker to
    have non-`nil` elements).  Another way to think about `rejectEitherNil` is that it is a logical transform
    that moves the `?` (`Optional` unary operator) from inside the tuple braces to the outside.

    - parameter tuple: The tuple to examine.
    - returns: The tuple or nil.
*/
public func rejectEitherNil
    <T, U>
    (tuple: (T?, U?)) -> (T, U)?
{
    if let zero = tuple.0, one = tuple.1 {
        return (zero, one)
    }
    return nil
}


/**
    Rejects tuple elements from the provided collection if either value in the tuple is `nil`.  This is often
    useful when handling the results of multiple subtasks when those results are provided as a `Dictionary`.
    Such a `Dictionary` can be passed through `pairs()` to create a sequence of key-value tuples that this
    function can be `mapFilter`ed over.

    - parameter collection: The collection to filter.
    - returns: The provided collection with all tuples containing a `nil` element removed.
*/
public func rejectEitherNil
    <T, U>
    (collection: [(T?, U?)]) -> [(T, U)]
{
    return collection.reduce(Array<(T, U)>()) { (var nonNilValues, item) in
        if nonNil(item.0) && nonNil(item.1) {
            nonNilValues.append((item.0!, item.1!))
        }
        return nonNilValues
    }
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    - parameter keySelector: A function taking an element of `array` and returning the key for that element in the returned dictionary.
    - returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func mapToDictionaryKeys
    <K: Hashable, S: SequenceType>
    (keySelector:S.Generator.Element -> K) (_ seq:S) -> [K: S.Generator.Element]
{
    var result: [K: S.Generator.Element] = [:]
    for item in seq {
        result[keySelector(item)] = item
    }
    return result
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    - parameter keySelector: A function taking an element of `array` and returning the key for that element in the returned dictionary.
    - returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func mapToDictionary
    <K: Hashable, V, S: SequenceType>
    (transform: S.Generator.Element -> (K, V)) (_ seq: S) -> [K: V]
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

    - parameter domain: The collection to search.
    - returns: The index of the first matching item,  or `nil` if none was found.
 */
public func findWhere
    <C: CollectionType>
    (domain: C, predicate: (C.Generator.Element) -> Bool) -> C.Index?
{
    var maybeIndex: C.Index? = domain.startIndex
    var numElementsRemaining = domain.count.toIntMax()

    while maybeIndex != nil && numElementsRemaining > 0
    {
        if let index = maybeIndex
        {
            let item = domain[index]
            if predicate(item) {
                return index
            }

            maybeIndex = index.successor()
        }
        numElementsRemaining--
    }

    return nil
}



//
// got this from http://www.objc.io/snippets/
// @@TODO: document
//

/**
    Decomposes `array` into a 2-tuple whose `head` property is the first element of `array` and
    whose `tail` property is an array containing all but the first element of `array`.  If
    `array.count == 0`, this function returns `nil`.
 */
public func decompose <T>
    (array:[T]) -> (head: T, tail: [T])?
{
    if array.count > 0 {
        return (array.first!, tail(array, n: 1))
    }
    return nil
}


/**
    Attempts to descend through a nested tree of `Dictionary` objects to the value represented
    by `keypath`.
 */
public func valueForKeypath <K: Hashable, V>
    (dictionary:[K: V], keypath:[K]) -> V?
{
    let currentKey = keypath[0]
    if let currentValue = dictionary[currentKey]
    {
        if keypath.count == 1 {
            return currentValue
        }
        else {
            if let innerDict = currentValue as? [K: V] {
                let newKeypath = Array(keypath[ 1 ..< keypath.endIndex ])
                return valueForKeypath(innerDict, keypath: newKeypath)
            }
        }
    }
    return nil
}


/**
    Attempts to descend through a nested tree of `Dictionary` objects to set the value of the key
    represented by `keypath`.  If a non-`Dictionary` type is encountered before reaching the end
    of `keypath`, a `.Failure` is returned.  Note: this function returns the result of modifying
    the input `Dictionary` in this way; it does not modify `dict` in place.
 */
public func setValueForKeypath
    (var dict:[String: AnyObject], keypath:[String], value: AnyObject?) -> Result<[String: AnyObject], ErrorIO>
{
    precondition(keypath.count > 0, "keypath.count must be > 0")

    switch keypath.count
    {
        case 1:
            dict[keypath.first!] = value
            return success(dict)

        case let c where c > 1:
            let (firstKey, remainingKeys) = (keypath.first!, keypath.dropFirst())
            if dict.indexForKey(firstKey) == nil {
                dict[firstKey] = [String: AnyObject]() as AnyObject
            }

            if let subDict = dict[firstKey] as? [String: AnyObject] {
                return setValueForKeypath(subDict, keypath: Array(remainingKeys), value: value)
                            .map { changedSubDict in
                                dict[firstKey] = changedSubDict
                                return dict
                            }
            }
            else { return failure("setValueForKeypath() -> found a value for dict[firstKey!] but it was not an NSDictionary") }

        default:
            return failure("Something weird happened in setValueForKeypath().  keypath.count = \(keypath.count)")
    }
}


public func mapIfIndex
    <S: SequenceType, D: RangeReplaceableCollectionType where S.Generator.Element == D.Generator.Element>
    (source: S, transform: S.Generator.Element -> S.Generator.Element, ifIndex: Int -> Bool) -> D
{
        var result = D()
        for (index, value) in source.enumerate() {
            if ifIndex(index) == true {
                result.append(transform(value))
            }
            else {
                result.append(value)
            }
        }
        return result
}


public func mapEveryNth
    <S: SequenceType, C: RangeReplaceableCollectionType where S.Generator.Element == C.Generator.Element>
    (source: S, n: Int, transform: S.Generator.Element -> S.Generator.Element) -> C
{
    // enumerate starts from zero, so for this to work with the nth element,
    // and not the 0th, n+1th etc, we need to add 1 to the ifIndex check:
    let isNth = { ($0 + 1) % n == 0 }

    return mapIfIndex(source, transform: transform, ifIndex: isNth)
}






