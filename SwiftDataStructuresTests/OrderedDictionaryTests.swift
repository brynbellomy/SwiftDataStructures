//
//  OrderedDictionaryTests.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 7.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import Quick
import Nimble
import SwiftDataStructures
import Funky
import Respect


private typealias Element = OrderedDictionaryType.Element

class OrderedDictionaryTests: QuickSpec
{
    override func spec()
    {
        describe("a new OrderedDictionary") {

            context("initialized from a [K: V] dictionary literal") {
                var dict: OrderedDictionaryType = ["one":"first value", "two":"second value", "three":"third value",]

                itBehavesLike(.OrderedDictionary) <| OrderedDictionarySpec.Args(dict, shouldMatch:[(0, Element1), (1, Element2), (2, Element3),])
            }

            context("initialized from a sequence of Elements") {
                let arr  = [ Element1, Element2, Element3, ]
                let dict = OrderedDictionaryType(SequenceOf(arr))

                itBehavesLike(.OrderedDictionary) <| OrderedDictionarySpec.Args(dict, shouldMatch:[(0, Element1), (1, Element2), (2, Element3),])
            }
        }


        describe("an OrderedDictionary") {
            context("when an element is removed by index") {
                var dict    = createTestDictionary(4)
                let removed = dict.removeAtIndex(2)

                it("should return the removed element") {
                    expect(removed).toNot(beNil())
                    expect { removed == Element3 } == true
                }

                itBehavesLike(.OrderedDictionary) <| OrderedDictionarySpec.Args(dict, shouldMatch:[(0, Element1), (1, Element2), (2, Element4),])
            }


            context("when an element is removed by key") {
                var dict = createTestDictionary(4)
                let key = "three"
                let removed = dict.removeForKey(key)

                it("should return the removed element") {
                    expect(removed).toNot(beNil())
                    expect { removed == Element3 } == true
                }

                itBehavesLike(.OrderedDictionary) <| OrderedDictionarySpec.Args(dict, shouldMatch:[(0, Element1), (1, Element2), (2, Element4),])
            }


            context("when an element is appended") {
                var dict = createTestDictionary(3)
                dict.append(Element4)

                itBehavesLike(.OrderedDictionary) <| OrderedDictionarySpec.Args(dict, shouldMatch:[(0, Element1), (1, Element2), (2, Element3), (3, Element4),])
            }
        }
    }
}

private let Element1 = Element(key:"one",   value:"first value")
private let Element2 = Element(key:"two",   value:"second value")
private let Element3 = Element(key:"three", value:"third value")
private let Element4 = Element(key:"four",  value:"fourth value")

private func itConformsTo (proto:ProtocolSpecType) (specArgs:AnyObject) {
    itConformsTo(TestTypes.OrderedDictionary, proto, specArgs)
}

func createTestDictionary(count:Int) -> OrderedDictionaryType
{
    let testDictionary: OrderedDictionaryType = [
        "one": "first value",
        "two": "second value",
        "three": "third value",
        "four": "fourth value",
    ]

    var dict = OrderedDictionaryType()
    for i in 0 ..< count {
        dict.append(testDictionary[i])
    }
    return dict
}




