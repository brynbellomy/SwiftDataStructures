//
//  Operators.compose.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import LlamaKit

infix operator >>> { associativity right precedence 170 }
infix operator />> { associativity right precedence 170 }
infix operator |>> { associativity left  precedence 170 }
infix operator •   { associativity left }



/// Returns the left-to-right composition of unary `g` on unary `f`.
///
/// This is the function such that `(f >>> g)(x)` = `g(f(x))`.
public func >>> <T, U, V> (f: T -> U, g: U -> V) -> T -> V {
    return { g(f($0)) }
}

/// Returns the left-to-right composition of unary `g` on binary `f`.
///
/// This is the function such that `(f >>> g)(x, y)` = `g(f(x, y))`.
public func >>> <T, U, V, W> (f: (T, U) -> V, g: V -> W) -> (T, U) -> W {
    return { g(f($0, $1)) }
}

/// Returns the left-to-right composition of binary `g` on unary `f`.
///
/// This is the function such that `(f >>> g)(x, y)` = `g(f(x), y)`.
public func >>> <T, U, V, W> (f: T -> U, g: (U, V) -> W) -> (T, V) -> W {
    return { g(f($0), $1) }
}

// MARK: - Left-to-right composition
public func />> <T, U, V> (f: T -> Result<U>, g: U -> Result<V>) -> T -> Result<V> {
    return {
        f($0).flatMap { x in g(x) }
    }
}

public func />> <T, U, V> (f: T -> Result<U>, g: Result<U> -> V) -> T -> V {
    return {
        g(f($0))
    }
}

public func />> <T, U, V> (f: T -> Result<U>, g: U -> V) -> T -> Result<V> {
    return {
        f($0).flatMap { x in success(g(x)) }
    }
}

public func >>> <T, U> (f: T -> U, g: U -> Void) -> T -> Void {
    return {
        f($0) |> g
        return
    }
}


public func |>> <T, U> (f: T -> Result<U>, g: Result<U> -> Void) -> T -> Void {
    return {
        f($0) |> g
        return
    }
}


/**
    The function composition operator.

    :param: g The outer function, called second and passed the return value of f(x).
    :param: f The inner function, called first and passed some value x.
    :returns: A function that takes some argument x, calls g(f(x)), and returns the value.
 */
public func •
    <T, U, V>
    (g: U -> V, f: T -> U)
    -> T -> V
{
    return { x in g(f(x)) }
}


