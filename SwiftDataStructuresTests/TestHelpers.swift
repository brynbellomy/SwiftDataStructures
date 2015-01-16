//
//  TestHelpers.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 16.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick
import Respect

public enum TestTypes: String, ISpecType
{
    case OrderedDictionary = "OrderedDictionary"
    case LinkedList = "LinkedList"

    public var specName: String { return rawValue }
}

public func itBehavesLike(type:TestTypes) (specArgs:AnyObject) {
    itBehavesLike(type, specArgs: specArgs)
}


public func sharedExamples(spec:TestTypes, closure: SharedExampleClosure)
{
    // look up shared spec by name and run it
    sharedExamples(spec.specName, closure)
}



