//
//  OrderedDictionarySpec.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 16.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftDataStructures
import Funky
import Respect

private func itConformsTo (proto:ProtocolSpecType) (specArgs:AnyObject) {
    itConformsTo(TestTypes.OrderedDictionary, proto, specArgs)
}


public class OrderedDictionarySpecArgs <K: Hashable, V>
{
    let subject:      OrderedDictionary<K, V>
    let shouldMatch:  [(OrderedDictionary<K, V>.Index, OrderedDictionary<K, V>.Element)]

    public init(_ subj: OrderedDictionary<K, V>, shouldMatch s:[(OrderedDictionary<K, V>.Index, OrderedDictionary<K, V>.Element)]) {
        subject = subj
        shouldMatch = s
    }
}



public class OrderedDictionarySpec
{
    public typealias Element = OrderedDictionaryType.Element
    public typealias Index = OrderedDictionaryType.Index
    public typealias Key = OrderedDictionaryType.Key
    public typealias Value = OrderedDictionaryType.Value
    public typealias Args = OrderedDictionarySpecArgs<Key, Value>

    typealias CollectionSpec = CollectionTypeSpec<OrderedDictionaryType>
    typealias SequenceSpec   =   SequenceTypeSpec<OrderedDictionaryType>
    //    typealias ListSpec       =       ListTypeSpec<OrderedDictionaryType>

    public class func registerSharedExamples(equality equality:(Element?, Element?) -> Bool)
    {
        sharedExamples(.OrderedDictionary) { context in
            if let args = context()["args"] as? Args {
                let (subject, shouldMatch) = (args.subject, args.shouldMatch)

                let elementsAndIndices = shouldMatch
                let elementsOnly       = shouldMatch.map(takeRight)

                itConformsTo(.CollectionType) <| CollectionSpec.Args(subject, shouldMatch:elementsAndIndices)
                itConformsTo(.SequenceType)   <|   SequenceSpec.Args(subject, shouldMatch:elementsOnly)

                it("returns the correct values for count") {
                    expect(subject.count) == shouldMatch.count
                }

                it("returns the correct values for first and last") {
                    let first = subject.elementAtIndex(subject.startIndex)
                    let last  = subject.elementAtIndex(subject.endIndex.predecessor())
                    expect(subject.first == first)
                    expect(subject.last  == last)
                }

                it("returns the correct values for hasIndex(_:)") {
//                    let firstIndex = elementsAndIndices.first
//                    let lastIndex  = elementsAndIndices.last
                    for (index, _) in elementsAndIndices {
                        expect(args.subject.hasIndex(index)) == true
                    }
                }

                it("returns the correct values for hasKey(_:)") {
                    for elem in elementsOnly {
                        expect(args.subject.hasKey(elem.key)) == true
                    }
                }

                it("returns a sequence of tuples in the correct order for sequence()") {
                    let seq         = Array(subject.sequence())
                    let shouldMatch = elementsOnly.map { ($0.key, $0.value) }

                    let zipped = zipseq(seq, shouldMatch)
                    for (one, two) in zipped {
                        expect(one.0).to(equal(two.0))
                        expect(one.1).to(equal(two.1))
                    }
                }
            }
        }
    }
}



