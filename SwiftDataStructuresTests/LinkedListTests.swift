//
//  LinkedListTests.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Dec 17.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftDataStructures


class LinkedListTests: XCTestCase
{
    func testEmptyInitializer()
    {
        let list = LinkedList<Int>()
        XCTAssert(list.count == 0)
    }

    func testSequenceInitializer()
    {
        let list = LinkedList<Int>(SequenceOf([10, 20, 30]))

        XCTAssert(list.count == 3)
        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 30)
        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 20)
        XCTAssert(list[2].item == 30)
    }

    func testArrayLiteralConvertible()
    {
        let list : LinkedList<Int> = [10, 20, 30]

        XCTAssert(list.count == 3)
        XCTAssert(list.first?.item == 10)
        XCTAssert(list.last?.item  == 30)
        XCTAssert(list[0].item == 10)
        XCTAssert(list[1].item == 20)
        XCTAssert(list[2].item == 30)
    }
}


class LinkedListMutatingTests : XCTestCase
{
    func testSubscriptSetter()
    {
        var list : LinkedList<Int> = [9, 8, 7]

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
        var list : LinkedList<Int> = [10, 20]

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
        var list : LinkedList<Int> = [20, 30]

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
        var list : LinkedList<Int> = [10, 30]

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
        var list : LinkedList<Int> = [10, 20, 30]

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
        var list : LinkedList<Int> = [10, 20, 30]

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
        var list : LinkedList<Int> = [10, 20, 30]

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
}





