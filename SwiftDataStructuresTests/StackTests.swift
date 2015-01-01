//
//  StackTests.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2014 Dec 17.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftDataStructures


class StackIndexTests: XCTestCase
{
    func testStackIndex() {
        var stack = Stack<Int>()
        stack.push(10)
        stack.push(20)
        stack.push(30)
        stack.push(40)
        stack.push(50)

        let index : Stack<Int>.Index = 1
        XCTAssertEqual(stack[index], 40)
        XCTAssertEqual(stack[index], stack[1])

        let index2 = Stack<Int>.Index(3)
        XCTAssertEqual(stack[index2], 20)
        XCTAssertEqual(stack[index2], stack[3])

        XCTAssertEqual(stack[stack.startIndex], stack.top!)
        XCTAssertEqual(stack[stack.endIndex.predecessor()], stack.bottom!)
    }
}


class StackTests: XCTestCase
{
    func testEmptyInitializer()
    {
        let stack = Stack<Int>()
        XCTAssert(stack.count == 0)
    }

    func testSequenceInitializer()
    {
        let stack = Stack<Int>(SequenceOf([10, 20, 30]))

        XCTAssert(stack.count == 3)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
        XCTAssert(stack[2] == 30)
    }

    func testArrayLiteralConvertible()
    {
        let stack : Stack<Int> = [10, 20, 30]
        XCTAssert(stack.count == 3)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
        XCTAssert(stack[2] == 30)
    }

    func testFrontAndBackProperties()
    {
        let stack : Stack<Int> = [10, 20, 30]
        XCTAssertEqual(stack.top!, 10)
        XCTAssert(stack.bottom  == 30)
    }

    func testGeneratorOrder()
    {
        let stack : Stack<Int> = [10, 20, 30]
        var array = [Int]()
        for item in stack {
            array.append(item)
        }
        XCTAssert(array.count == 3)
        XCTAssert(array[0] == 10)
        XCTAssert(array[1] == 20)
        XCTAssert(array[2] == 30)
    }

    func testOperators() {
        let stack1: Stack<Int> = [30, 40]
        let stack2: Stack<Int> = [10, 20] + stack1 + [50]
        XCTAssert(stack2.count == 5)
        XCTAssertEqual(stack2.top!, stack2[0])
        XCTAssertEqual(stack2[0], 10)
        XCTAssertEqual(stack2[1], 20)
        XCTAssertEqual(stack2[2], 30)
        XCTAssertEqual(stack2[3], 40)
        XCTAssertEqual(stack2[4], 50)
        XCTAssertEqual(stack2.bottom!, stack2[4])
    }
}


class StackMutatingTests : XCTestCase
{
    func testPush()
    {
        var stack = Stack<Int>()
        stack.push(30)
        stack.push(20)
        stack.push(10)

        XCTAssert(stack.count == 3)
        XCTAssert(stack.top == 10)
        XCTAssert(stack.bottom  == 30)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
        XCTAssert(stack[2] == 30)
    }

    func testPop()
    {
        var stack : Stack<Int> = [10, 20, 30]
        let element = stack.top!
        let removed = stack.pop()!

        XCTAssert(removed == element)
        XCTAssertEqual(removed, 10)
        XCTAssert(stack.count == 2)
        XCTAssert(stack.top == 20)
        XCTAssert(stack.bottom  == 30)
        XCTAssert(stack[0] == 20)
        XCTAssert(stack[1] == 30)
    }

    func testSubscriptSetter()
    {
        var stack : Stack<Int> = [9, 8, 7]

        stack[2] = 30
        stack[1] = 20
        stack[0] = 10

        XCTAssert(stack.count == 3)
        XCTAssert(stack.top == 10)
        XCTAssert(stack.bottom  == 30)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
        XCTAssert(stack[2] == 30)
    }

    func testRemoveAtIndexFirst()
    {
        var stack : Stack<Int> = [10, 20, 30]

        let index = 0
        let element = stack[index]
        let removed = stack.removeAtIndex(index)

        XCTAssert(removed == element)
        XCTAssert(removed == 10)
        XCTAssert(stack.count == 2)
        XCTAssert(stack.top == 20)
        XCTAssert(stack.bottom  == 30)
        XCTAssert(stack[0] == 20)
        XCTAssert(stack[1] == 30)
    }

    func testRemoveAtIndexN()
    {
        var stack : Stack<Int> = [10, 20, 30]

        let index = 1
        let element = stack[index]
        let removed = stack.removeAtIndex(index)

        XCTAssert(removed == element)
        XCTAssert(removed == 20)
        XCTAssert(stack.count == 2)
        XCTAssert(stack.top == 10)
        XCTAssert(stack.bottom  == 30)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 30)
    }

    func testRemoveAtIndexLast()
    {
        var stack : Stack<Int> = [10, 20, 30]

        let index = 2
        let element = stack[index]
        let removed = stack.removeAtIndex(index)

        XCTAssert(removed == element)
        XCTAssert(removed == 30)
        XCTAssert(stack.count == 2)
        XCTAssert(stack.top == 10)
        XCTAssert(stack.bottom  == 20)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
    }
}



