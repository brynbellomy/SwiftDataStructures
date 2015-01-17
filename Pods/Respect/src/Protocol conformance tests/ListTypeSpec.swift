//
//  ListTypeSpec.swift
//  Respect
//
//  Created by bryn austin bellomy on 2015 Jan 7.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Quick
import Nimble
import Funky


public class ListTypeSpecArgs <L: ListType where L.ListIndex.Distance == Int>
{
    let subject:      L
    let shouldMatch: [L.ListElement]

    public init(_ subj: L, shouldMatch s:[L.ListElement]) {
        subject = subj
        shouldMatch = s
    }
}


public class ListTypeSpec <L: ListType where L.ListIndex.Distance == Int>
{
    public typealias Args = ListTypeSpecArgs<L>

    public class func registerSharedExamples(forType type:ISpecType, equality:(L.ListElement?, L.ListElement?) -> Bool)
    {
        sharedExamples(.ListType, forType:type) { context in
            if let args = context()["args"] as? Args {
                let (subject, shouldMatch) = (args.subject, args.shouldMatch)

                it("returns the correct value for count") { expect(subject.count).to(equal(shouldMatch.count)) }
                it("returns the correct value for first") { expect(equality(subject.first, shouldMatch.first)) == true }
                it("returns the correct value for last")  { expect(equality(subject.last,  shouldMatch.last))  == true }

            }
        }
    }
}





