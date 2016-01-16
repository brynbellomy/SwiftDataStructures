//
//  TestHelpers.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 11.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftDataStructures
import Funky
import Respect


internal typealias LinkedListType = LinkedList<String>
public typealias NodeType = LinkedList<String>.NodeType

internal class Box <T> {
    var unbox: T
    init(_ v: T) { unbox = v }
}



//
// MARK: - Test data
//

internal let testList = LinkedListType([ "one", "two", "three", "four", ])

internal func createTestList(count:Int) -> LinkedListType
{
    var dict = LinkedListType()
    for i in 0 ..< count {
        dict.append(testList[i])
    }
    return dict
}


//
// MARK: - Shared test examples
//

class LinkedListSharedExamplesConfiguration: QuickConfiguration
{
    override class func configure(configuration: Configuration)
    {
//              ListTypeSpec<LinkedListType>.registerSharedExamples(forType: TestTypes.LinkedList, equality:==)
        CollectionTypeSpec<LinkedListType>.registerSharedExamples(forType: TestTypes.LinkedList, equality:==)
          SequenceTypeSpec<LinkedListType>.registerSharedExamples(forType: TestTypes.LinkedList, equality:==)

        LinkedListSpec.registerSharedExamples(equality:==)
    }
}


public func == (lhs: LinkedListNode<String>, rhs: LinkedListNode<String>) -> Bool {
    return lhs.item == rhs.item
}


public func == (lhs: LinkedListNode<String>?, rhs: LinkedListNode<String>?) -> Bool {
    return lhs?.item == rhs?.item
}





