//
//  Operators.pipe.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import LlamaKit


infix operator |> { associativity left }
infix operator <| { associativity left precedence 101 }



/** The pipe-forward operator. */
public func |>
    <T, U>
    (t: T, f: T -> U)
    -> U
{
    return f(t)
}



/** The pipe-backward operator. */
public func <|
    <T, U>
    (f: T -> U, t: T)
    -> U
{
    return f(t)
}




// @@TODO: figure out a different operator for this
public func <|
    <T, U>
    (f: (T -> U)?, t: T)
    -> U?
{
    return f.map { fn in fn(t) }
}


// @@TODO: figure out a different operator for this
public func <|
    <T, U>
    (f: Result<T -> U>, t: T)
    -> Result<U>
{
    return f.map { fn in fn(t) }
}