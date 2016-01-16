//
//  Operators.fmap.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


/**
    fmap operator (functors) (A -> B  <^>  A?)
*/
infix operator <^> { associativity left precedence 101 }

public func <^>
    <A, B>
    (f: A -> B, maybeValue: A?) -> B?
{
    switch maybeValue
    {
        case .Some(let x): return f(x)
        case .None: return .None
    }
}

public func <^>
    <A, B>
    (f: A -> B, values: [A]) -> [B]
{
    return values.map(f)
}


public func <^>
    <A, B, E>
    (f: A -> B, values: Result<A, E>) -> Result<B, E>
{
    return values.map(f)
}


