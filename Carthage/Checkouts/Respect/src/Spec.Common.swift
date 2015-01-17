//
//  Spec.Common.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 11.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import XCTest
import Quick


public protocol ISpecType {
    var specName: String { get }
}


public enum ProtocolSpecType: String, ISpecType
{
    case CollectionType = "CollectionType"
    case SequenceType   = "SequenceType"
    case ListType       = "ListType"
    public var specName: String { return rawValue }
}

public func sharedExamples(protocolSpec:ProtocolSpecType, forType type:ISpecType, closure: SharedExampleClosure)
{
    // figure out the name of the desired spec
    let spec = ProtocolImplementationSpec(type, implements:protocolSpec)

    // look up shared spec by name and run it
    sharedExamples(spec.specName, closure)
}

public func sharedExamples(spec:ISpecType, closure: SharedExampleClosure) {
    sharedExamples(spec.specName, closure)
}

public func makeExampleContext(specArgs:AnyObject) -> SharedExampleContext {
    return { [ "args": specArgs ] }
}

public func itConformsTo (object:ISpecType, protocolSpec:ProtocolSpecType, specArgs:AnyObject)
{
    // figure out the name of the desired spec
    let spec = ProtocolImplementationSpec(object, implements: protocolSpec)

    // look up shared spec by name and run it
    itBehavesLike(spec) { [ "args": specArgs ] }
}

//public func itBehavesLike(specName:String, context:SharedExampleContext) {
//    itBehavesLike(specName, context, flags:[:])
//}

public func itBehavesLike(specName:String, #specArgs:AnyObject) {
    itBehavesLike(specName, makeExampleContext(specArgs), flags:[:])
}

public func itBehavesLike(spec:ISpecType, #context:SharedExampleContext) {
    itBehavesLike(spec.specName, context)
}

public func itBehavesLike(spec:ISpecType, #specArgs:AnyObject) {
    itBehavesLike(spec) { [ "args": specArgs ] }
}









