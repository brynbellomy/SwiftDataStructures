//
//  Operators.bind.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//



/**
    bind operators (A?  |>  A -> B?)
 */
infix operator >>- { associativity left precedence 150 }
infix operator -<< { associativity left precedence 150 }


public func >>-
    <A, B> (maybeValue: A?, f: A -> B?) -> B?
{
    return maybeValue.flatMap(f)
}


public func >>-
    <A, B> (wrapped: [A], f: A -> [B]) -> [B]
{
    return wrapped.map(f).reduce([], combine: +)
}


public func >>-
    <A, B, E>
    (maybeValue: Result<A, E>, f: A -> Result<B, E>) -> Result<B, E>
{
    switch maybeValue {
        case .Success(let box): return f(box.unbox)
        case .Failure(let err): return Result.Failure(err)
    }
}


public func >>- <E>
    (maybeValue: Result<(), E>, f: () -> Result<(), E>) -> Result<(), E>
{
    switch maybeValue {
        case .Success:          return f()
        case .Failure(let box): return Result.Failure(box)
    }
}


public func >>- <E>
    (maybeValue: Result<Bool, E>, f: () -> Result<Bool, E>) -> Result<Bool, E>
{
    switch maybeValue {
        case .Success:          return f()
        case .Failure(let err): return Result.Failure(err)
    }
}


public func -<< <A, B, E> (f:A -> Result<B, E>, maybeValue:Result<A, E>) -> Result<B, E>
{

    switch maybeValue {
        case .Success(let box): return f(box.unbox)
        case .Failure(let err): return Result.Failure(err)
    }
}



