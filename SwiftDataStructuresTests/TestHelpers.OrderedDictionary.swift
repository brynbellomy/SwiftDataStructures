//
//  TestHelpers.OrderedDictionary.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 11.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftDataStructures
import Respect

typealias OrderedDictionaryType = OrderedDictionary<String, String>

private class OrderedDictionarySharedExamplesConfiguration: QuickConfiguration
{
    override class func configure(configuration: Configuration)
    {
//              ListTypeSpec<OrderedDictionaryType>.registerSharedExamples(forType:TestTypes.OrderedDictionary, equality:==)
        CollectionTypeSpec<OrderedDictionaryType>.registerSharedExamples(forType:TestTypes.OrderedDictionary, equality:==)
          SequenceTypeSpec<OrderedDictionaryType>.registerSharedExamples(forType:TestTypes.OrderedDictionary, equality:==)

        OrderedDictionarySpec.registerSharedExamples(equality:==)
    }
}





