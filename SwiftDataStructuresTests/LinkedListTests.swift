//
//  LinkedListTests.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Dec 17.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import Quick
import Nimble
import SwiftDataStructures
import Funky
import Respect


class LinkedListTests: QuickSpec
{
    override func spec()
    {
        typealias CollectionSpec = CollectionTypeSpec<LinkedListType>
        typealias SequenceSpec   =   SequenceTypeSpec<LinkedListType>
//        typealias ListSpec       =       ListTypeSpec<LinkedListType>

        describe("a new LinkedList") {

            context("initialized empty") {
                let list = LinkedListType()

                itBehavesLike(.LinkedList) <| LinkedListSpec.Args(list, shouldMatch:[])
            }

            context("initialized from an array literal") {
                let list = LinkedListType([ "one", "two", "three", ])

                itBehavesLike(.LinkedList) <| LinkedListSpec.Args(list, shouldMatch:[(0, Node1), (1, Node2), (2, Node3),])
            }

            context("initialized from a sequence of LinkedListNodes") {
                let seq  = AnySequence([ Node1, Node2, Node3, ])
                let list = LinkedListType(seq)

                itBehavesLike(.LinkedList) <| LinkedListSpec.Args(list, shouldMatch:[(0, Node1), (1, Node2), (2, Node3),])
            }

            context("initialized from a sequence of Ts") {
                let arr  =  [ "one", "two", "three", ]
                let list = LinkedListType(AnySequence(arr))

                itBehavesLike(.LinkedList) <| LinkedListSpec.Args(list, shouldMatch:[(0, Node1), (1, Node2), (2, Node3),])
            }
        }

        describe("a LinkedList") {
            it("returns the correct indices when find() is called and an element satisfies predicate") {
                let list = LinkedListType([ "one", "two", "three", ])
                let node = list[1]
                let index = list.find { $0 === node }
                expect(index) == 1
            }

            it("returns nil when find() is called and no elements satisfy the predicate") {
                let list = LinkedListType([ "one", "two", "three", ])
                let index = list.find { $0.item == "xyzzy" }
                expect(index).to(beNil())
            }

        }
    }
}


// @@TODO: convert these to Quick/Nimble/Respect
class LinkedListMutatingTests : XCTestCase
{
    func testSubscriptSetter()
    {
        var list = LinkedList([9, 8, 7])

        list[0] = LinkedListNode(10)
        list[1] = LinkedListNode(20)
        list[2] = LinkedListNode(30)

        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 20)
        XCTAssert(list[2].item == 30)

        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 30)
    }

    func testAppend()
    {
        var list = LinkedList([10, 20])

        list.append(LinkedListNode(30))

        XCTAssert(list.count == 3)
        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 20)
        XCTAssert(list[2].item == 30)
        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 30)
    }

    func testPrepend()
    {
        var list = LinkedList([20, 30])

        list.prepend(LinkedListNode(10))

        XCTAssert(list.count == 3)
        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 20)
        XCTAssert(list[2].item == 30)
        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 30)
    }

    func testInsert()
    {
        var list = LinkedList([10, 30])

        let index = 1
        list.insert(LinkedListNode(20), atIndex:index)

        XCTAssert(list.count == 3)
        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 20)
        XCTAssert(list[2].item == 30)
        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 30)
    }

    func testRemoveAtIndexFirst()
    {
        var list = LinkedList([10, 20, 30])

        let index = 0
        let element = list[index]
        let removed = list.removeAtIndex(index)

        XCTAssert(removed.item == element.item)
        XCTAssert(removed.item == 10)
        XCTAssert(list.count == 2)
        XCTAssert(list.first?.item == 20)
        XCTAssert(list.last?.item  == 30)
        XCTAssert(list[0].item == 20)
        XCTAssert(list[1].item == 30)
    }

    func testRemoveAtIndexN()
    {
        var list = LinkedList([10, 20, 30])

        let index = 1
        let element = list[index]
        let removed = list.removeAtIndex(index)

        XCTAssert(removed.item == element.item)
        XCTAssert(removed.item == 20)
        XCTAssert(list.count == 2)
        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 30)
        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 30)
    }

    func testRemoveAtIndexLast()
    {
        var list = LinkedList([10, 20, 30])

        let index = 2
        let element = list[index]
        let removed = list.removeAtIndex(index)

        XCTAssert(removed.item == element.item)
        XCTAssert(removed.item == 30)
        XCTAssert(list.count == 2)
        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 20)
        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 20)
    }

    func testSplice()
    {
        var list = LinkedListType([Node1.item, Node2.item, Node3.item,])
        let newElements = LinkedListType([Node4.item, Node1.item,])

        list.insertContentsOf(newElements, at:1)
        let expected = LinkedListType([Node1.item, Node4.item, Node1.item, Node2.item, Node3.item])
        XCTAssert(list == expected)
    }
}





private typealias Node = LinkedListType.NodeType
private let Node1 = Node("one")
private let Node2 = Node("two")
private let Node3 = Node("three")
private let Node4 = Node("four")






