//
//  ProtocolImplementationSpec.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 13.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Quick


/**
    Represents a spec that tests whether `subject` conforms to `theProtocol`.
 */
public struct ProtocolImplementationSpec: ISpecType
{
    let subject: ISpecType
    let theProtocol: ISpecType

    public init(_ subj:ISpecType, implements proto:ISpecType) {
        subject = subj
        theProtocol = proto
    }

    public var specName: String { return "\(subject.specName) as a \(theProtocol.specName)" }
}





