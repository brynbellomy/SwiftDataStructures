//
//  LinkedListSpec.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 16.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import Quick
import Nimble
import SwiftDataStructures
import Funky
import Respect

private func itConformsTo (proto:ProtocolSpecType) (specArgs:AnyObject) {
    itConformsTo(TestTypes.LinkedList, proto, specArgs)
}


public class LinkedListSpecArgs <T>
{
    let subject:      LinkedList<T>
    let shouldMatch:  [(LinkedList<T>.Index, NodeType)]

    public init(_ subj: LinkedList<T>, shouldMatch s:[(LinkedList<T>.Index, NodeType)]) {
        subject = subj
        shouldMatch = s
    }
}


public class LinkedListSpec
{
    public typealias InnerType = LinkedListType.InnerType
    public typealias Args = LinkedListSpecArgs<InnerType>

    typealias CollectionSpec = CollectionTypeSpec<LinkedListType>
    typealias SequenceSpec   =   SequenceTypeSpec<LinkedListType>
//    typealias ListSpec       =       ListTypeSpec<LinkedListType>

    public class func registerSharedExamples(#equality:(InnerType?, InnerType?) -> Bool)
    {
        sharedExamples(.LinkedList) { context in
            if let args = context()["args"] as? Args {
                let (subject, shouldMatch) = (args.subject, args.shouldMatch)

                let elementsAndIndices = shouldMatch
                let elementsOnly       = shouldMatch |> map‡ (takeRight)

                itConformsTo(.CollectionType) <| CollectionSpec.Args(subject, shouldMatch:elementsAndIndices)
                itConformsTo(.SequenceType)   <|   SequenceSpec.Args(subject, shouldMatch:elementsOnly)
//                itConformsTo(.ListType)       <|       ListSpec.Args(subject, shouldMatch:elementsOnly)

                it("returns the correct values for subscripts passed to at()") {
                    if shouldMatch.count > 0 {
                        for (i, _) in enumerate(subject) {
                            expect(subject.at(i) == elementsOnly[i])
                        }
                    }
                    else {
                        expect(subject.at(0)).to(beNil())
                    }
                }

                it("returns the correct values for count") {
                    expect(subject.count) == shouldMatch.count
                }

                it("returns the correct values for first and last") {
                    let first = subject.at(subject.startIndex)
                    let last  = subject.at(subject.endIndex.predecessor())
                    expect(subject.first == first)
                    expect(subject.last  == last)
                }

            }
        }
    }
}



