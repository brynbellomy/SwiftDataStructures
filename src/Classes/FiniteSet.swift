//
//  FiniteSet.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Feb 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation

public protocol IFiniteSetType: Hashable
{
    static var finiteSetMembers: Set<Self> { get }
}

public struct FiniteSet <T: IFiniteSetType>
{
    public private(set) var set = Set<T>()

    public init() {}

    public init(_ s:Set<T>) {
        set = s
    }

    public init <S: SequenceType where S.Generator.Element == T> (_ elems:S) {
        set = Set(elems)
    }
}
