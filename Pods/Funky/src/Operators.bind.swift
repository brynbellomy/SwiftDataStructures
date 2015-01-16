//
//  Operators.bind.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import LlamaKit


/**
    bind operators (A?  |>  A -> B?)
 */
infix operator >>- { associativity left precedence 150 }
infix operator -<< { associativity left precedence 150 }


public func >>-
    <A, B>
    (maybeValue: A?, f: A -> B?)
    -> B?
{
    switch maybeValue
    {
        case .Some(let x): return f(x)
        case .None: return .None
    }
}


public func >>-
    <A, B>
    (wrapped: [A], f: A -> [B])
    -> [B]
{
    return wrapped.map(f).reduce([], combine: +)
}


public func >>-
    <A, B>
    (maybeValue: Result<A>, f: A -> Result<B>)
    -> Result<B>
{
    switch maybeValue {
        case .Success(let box): return f(box.unbox)
        case .Failure(let err): return failure(err)
    }
}

public func >>-
    <E>
    (maybeValue: Result<()>, f: () -> Result<()>)
    -> Result<()>
{
    switch maybeValue {
        case .Success:          return f()
        case .Failure(let box): return failure(box)
    }
}


public func >>-
    <E>
    (maybeValue: Result<Bool>, f: () -> Result<Bool>)
    -> Result<Bool>
{
    switch maybeValue {
        case .Success:          return f()
        case .Failure(let err): return failure(err)
    }
}


public func -<< <A, B> (f:A -> Result<B>, maybeValue:Result<A>) -> Result<B>
{

    switch maybeValue {
        case .Success(let box): return f(box.unbox)
        case .Failure(let err): return failure(err)
    }
}



