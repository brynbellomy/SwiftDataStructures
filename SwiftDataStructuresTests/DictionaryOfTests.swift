//
//  DictionaryOfTests.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 May 18.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import XCTest
import SwiftDataStructures

struct Something {
    let id: Int
    let val: String
    init(id:Int, val:String) {
        self.id = id
        self.val = val
    }
}

class DictionaryOfTests: XCTestCase
{
    var dict = DictionaryOf<Int, Something>(array:[]) { $0.id }
    
    override func setUp() {
        dict = makeDict()
    }
    
    func makeDict() -> DictionaryOf<Int, Something> {
        let one = Something(id:5, val:"why")
        let two = Something(id:2, val:"so")
        let three = Something(id:99, val:"trap")
        return DictionaryOf<Int, Something>(array:[one, two, three]) { $0.id }
    }
    
    func testSubscripting() {
        XCTAssert(dict[5].val == "why")
        XCTAssert(dict[2].val == "so")
        XCTAssert(dict[99].val == "trap")
    } 
    
    func testSequenceType() {
        var gen = dict.generate()
        XCTAssert(gen.next()!.val == "why")
        XCTAssert(gen.next()!.val == "so")
        XCTAssert(gen.next()!.val == "trap")
        XCTAssert(gen.next() == nil)
    }
}


