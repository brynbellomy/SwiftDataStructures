//
//  CollectionTypeSpec.swift
//  Respect
//
//  Created by bryn austin bellomy on 2015 Jan 7.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Respect


public class CollectionTypeSpecArgs <C: CollectionType>
{
    let collection:  C
    let shouldMatch: [(C.Index, C.Generator.Element)]

    public init(_ c: C, shouldMatch other: [(C.Index, C.Generator.Element)]) {
        collection = c
        shouldMatch = other
    }
}


public class CollectionTypeSpec <C: CollectionType where C.Index == Int>
{
    public typealias Args = CollectionTypeSpecArgs<C>

    public class func registerSharedExamples(forType type:ISpecType, equality: (C.Generator.Element, C.Generator.Element) -> Bool)
    {
        sharedExamples(.CollectionType, forType:type) { context in
            if let args = context()["args"] as? Args {

                it("returns the correct value for startIndex") {
                    expect { args.collection.startIndex } == args.shouldMatch.startIndex
                }

                it("returns the correct value for endIndex") {
                    expect { args.collection.endIndex } == args.shouldMatch.endIndex
                }

                it("returns the correct values at subscript indexes") {
                    for (index, element) in args.shouldMatch {
                        expect(equality(args.collection[index], element)) == true
                    }
                }
            }
        }
    }
}



