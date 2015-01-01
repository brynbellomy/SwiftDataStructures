//
//  QueueTests.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Dec 18.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftDataStructures


class QueueTests: XCTestCase
{
    func testEmptyInitializer()
    {
        let queue = Queue<Int>()
        XCTAssert(queue.count == 0)
    }

    func testSequenceInitializer()
    {
        let queue = Queue<Int>(SequenceOf([10, 20, 30]))

        XCTAssert(queue.count == 3)
        XCTAssert(queue[0] == 10)
        XCTAssert(queue[1] == 20)
        XCTAssert(queue[2] == 30)
    }

    func testArrayLiteralConvertible()
    {
        let queue : Queue<Int> = [10, 20, 30]
        XCTAssert(queue.count == 3)
        XCTAssert(queue[0] == 10)
        XCTAssert(queue[1] == 20)
        XCTAssert(queue[2] == 30)
    }

    func testFrontAndBackProperties()
    {
        let queue : Queue<Int> = [10, 20, 30]
        XCTAssert(queue.front == 10)
        XCTAssert(queue.back  == 30)
    }

    func testGeneratorOrder()
    {
        let queue : Queue<Int> = [10, 20, 30]
        var array = [Int]()
        for item in queue {
            array.append(item)
        }
        XCTAssert(array.count == 3)
        XCTAssert(array[0] == 10)
        XCTAssert(array[1] == 20)
        XCTAssert(array[2] == 30)
    }
}


class QueueMutatingTests : XCTestCase
{
    func testEnqueue()
    {
        var queue = Queue<Int>()
        queue.enqueue(10)
        queue.enqueue(20)
        queue.enqueue(30)

        XCTAssert(queue.count == 3)
        XCTAssert(queue.front == 10)
        XCTAssert(queue.back  == 30)
        XCTAssert(queue[0] == 10)
        XCTAssert(queue[1] == 20)
        XCTAssert(queue[2] == 30)
    }

    func testDequeue()
    {
        var queue : Queue<Int> = [10, 20, 30]
        let element = queue.front!
        let removed  = queue.dequeue()!

        XCTAssert(removed == element)
        XCTAssert(removed == 10)
        XCTAssert(queue.count == 2)
        XCTAssert(queue.front == 20)
        XCTAssert(queue.back  == 30)
        XCTAssert(queue[0] == 20)
        XCTAssert(queue[1] == 30)
    }

    func testSubscriptSetter()
    {
        var queue : Queue<Int> = [9, 8, 7]

        queue[0] = 10
        queue[1] = 20
        queue[2] = 30

        XCTAssert(queue.count == 3)
        XCTAssert(queue.front == 10)
        XCTAssert(queue.back  == 30)
        XCTAssert(queue[0] == 10)
        XCTAssert(queue[1] == 20)
        XCTAssert(queue[2] == 30)
    }

    func testRemoveAtIndexFirst()
    {
        var queue : Queue<Int> = [10, 20, 30]

        let index = 0
        let element = queue[index]
        let removed = queue.removeAtIndex(index)

        XCTAssert(removed == element)
        XCTAssert(removed == 10)
        XCTAssert(queue.count == 2)
        XCTAssert(queue.front == 20)
        XCTAssert(queue.back  == 30)
        XCTAssert(queue[0] == 20)
        XCTAssert(queue[1] == 30)
    }

    func testRemoveAtIndexN()
    {
        var queue : Queue<Int> = [10, 20, 30]

        let index = 1
        let element = queue[index]
        let removed = queue.removeAtIndex(index)

        XCTAssert(removed == element)
        XCTAssert(removed == 20)
        XCTAssert(queue.count == 2)
        XCTAssert(queue.front == 10)
        XCTAssert(queue.back  == 30)
        XCTAssert(queue[0] == 10)
        XCTAssert(queue[1] == 30)
    }

    func testRemoveAtIndexLast()
    {
        var queue : Queue<Int> = [10, 20, 30]

        let index = 2
        let element = queue[index]
        let removed = queue.removeAtIndex(index)

        XCTAssert(removed == element)
        XCTAssert(removed == 30)
        XCTAssert(queue.count == 2)
        XCTAssert(queue.front == 10)
        XCTAssert(queue.back  == 20)
        XCTAssert(queue[0] == 10)
        XCTAssert(queue[1] == 20)
    }
}




