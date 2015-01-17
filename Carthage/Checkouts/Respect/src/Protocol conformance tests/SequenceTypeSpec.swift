//
//  SequenceTypeSpec.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 14.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Quick
import Nimble


public class SequenceTypeSpecArgs <S: SequenceType>
{
    let subject:      S
    let shouldMatch: [S.Generator.Element]

    public init(_ subj: S, shouldMatch s:[S.Generator.Element]) {
        subject = subj
        shouldMatch = s
    }
}


public class SequenceTypeSpec <S: SequenceType>
{
    public typealias Args = SequenceTypeSpecArgs<S>

    public class func registerSharedExamples(forType type:ISpecType, equality: (S.Generator.Element, S.Generator.Element) -> Bool)
    {
        sharedExamples(.SequenceType, forType:type) { context in
            if let args = context()["args"] as? Args {

                let (subject, shouldMatch) = (args.subject, args.shouldMatch)

                it("has a generator that returns values in the right order") {
                    var arr = Array<S.Generator.Element>()

                    var gen = args.subject.generate()
                    while let next = gen.next() {
                        arr.append(next)
                    }
                    let subjSequence: [S.Generator.Element] = Array(args.subject)

                    expect(equal(arr, shouldMatch, equality)).to(beTrue())
                }
            }
        }
    }
}






