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


class StackTests: XCTestCase
{
    func testEmptyInitializer()
    {
        let stack = Stack<Int>()
        XCTAssert(stack.count == 0)
    }

    func testSequenceInitializer()
    {
        let stack = Stack<Int>(SequenceOf([30, 20, 10]))

        XCTAssert(stack.count == 3)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
        XCTAssert(stack[2] == 30)
    }

    func testArrayLiteralConvertible()
    {
        let stack : Stack<Int> = [30, 20, 10]
        XCTAssert(stack.count == 3)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
        XCTAssert(stack[2] == 30)
    }

    func testFrontAndBackProperties()
    {
        let stack : Stack<Int> = [30, 20, 10]
        XCTAssert(stack.top == 10)
        XCTAssert(stack.bottom  == 30)
    }
}


class StackMutatingTests : XCTestCase
{
    func testEnstack()
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

    func testDestack()
    {
        var stack : Stack<Int> = [30, 20, 10]
        let element = stack.top!
        let removed  = stack.pop()!

        XCTAssert(removed == element)
        XCTAssert(removed == 10)
        XCTAssert(stack.count == 2)
        XCTAssert(stack.top == 20)
        XCTAssert(stack.bottom  == 30)
        XCTAssert(stack[0] == 20)
        XCTAssert(stack[1] == 30)
    }

    func testSubscriptSetter()
    {
        var stack : Stack<Int> = [9, 8, 7]

        stack[2] = 10
        stack[1] = 20
        stack[0] = 30

        XCTAssert(stack.count == 3)
        XCTAssert(stack.top == 10)
        XCTAssert(stack.bottom  == 30)
        XCTAssert(stack[0] == 10)
        XCTAssert(stack[1] == 20)
        XCTAssert(stack[2] == 30)
    }

    func testRemoveAtIndexFirst()
    {
        var stack : Stack<Int> = [30, 20, 10]

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
        var stack : Stack<Int> = [30, 20, 10]

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
        var stack : Stack<Int> = [30, 20, 10]

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



