//
//  DictionaryOf.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 May 18.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky


public struct DictionaryOf <K: Hashable, V>
{
    private var items = [V]()
    private let getKey: V -> K

    public init (getKey gk:V -> K) {
        getKey = gk
    }
    
    public init (array:[V], getKey gk:V -> K) {
        items = array
        getKey = gk
        
        checkKeyUniqueness()
    }
    
    public subscript (key:K) -> V {
        get {
            return (items.filter { x in self.getKey(x) == key } |> takeFirst)!
        }
        set {
            precondition(getKey(newValue) == key)
            removeValueForKey(key)
            items.append(newValue)
            checkKeyUniqueness()
        }
    }
    
    public func values() -> [V] {
        return items
    }
    
    public func keys() -> [K] {
        return items.map { self.getKey($0) }
    }
    
    public func containsKey (key:K) -> Bool {
        let matches = items |> countWhere { self.getKey($0) == key }
        return matches > 0
    }

    public mutating func append (element:V) {
        items.append(element)
        checkKeyUniqueness()
    }
    
    public mutating func removeValueForKey (key:K) -> V? {
        return (items |>  findWhere‡ { self.getKey($0) == key })
                      >>- { self.items.removeAtIndex($0) }
    }
    
    private func checkKeyUniqueness() -> Bool {
        let allKeys = keys()
        let uniqueKeys = Set<K>(allKeys)
        precondition(uniqueKeys.count == allKeys.count)
        precondition(uniqueKeys.count == items.count)
        return allKeys.count == uniqueKeys.count
    }

    public func map (transform:V -> V) -> DictionaryOf<K, V> {
        return DictionaryOf<K, V>(array: items.map(transform), getKey:getKey)
    }
}

extension DictionaryOf: SequenceType {
    public func generate() -> AnyGenerator<V> {
        return anyGenerator(items.generate())
    }
}


