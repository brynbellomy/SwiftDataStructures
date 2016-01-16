//
//  Operators.misc.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//



infix operator =?? { associativity left precedence 99 }
infix operator ??= { associativity left precedence 99 }
infix operator ?± { associativity right precedence 110 }

// look, i made a face operator!
// prefix operator °¿° {}


/**
    The set-if-non-nil operator.  Will only set `lhs` to `rhs` if `rhs` is non-nil.
 */
public func =?? <T>(inout lhs:T, maybeRhs: T?) {
    if let rhs = maybeRhs {
        lhs = rhs
    }
}


/**
    The set-if-non-nil operator.  Will only set `lhs` to `rhs` if `rhs` is non-nil.
 */
public func =?? <T>(inout lhs:T?, maybeRhs: T?) {
    if let rhs = maybeRhs {
        lhs = rhs
    }
}


/**
    The set-if-non-failure operator.  Will only set `lhs` to `rhs` if `rhs` is not a `Result<T>.Failure`.
 */
public func =?? <T, E: ErrorType> (inout lhs:T, result: Result<T, E>) {
    lhs =?? result.value
}


/**
    The set-if-non-failure operator.  Will only set `lhs` to `rhs` if `rhs` is not a `Result<T>.Failure`.
 */
public func =?? <T, E: ErrorType> (inout lhs:T?, result: Result<T, E>) {
    lhs =?? result.value
}


/**
    The initialize-if-nil operator.  Will only set `lhs` to `rhs` if `lhs` is nil.
 */
public func ??= <T: Any> (inout lhs:T?, @autoclosure rhs: () -> T)
{
    if lhs == nil {
        lhs = rhs()
    }
}


/**
    The initialize-if-nil operator.  Will only set `lhs` to `rhs` if `lhs` is nil.
 */
public func ??= <T: Any> (inout lhs:T?, @autoclosure rhs: () -> T?)
{
    if lhs == nil {
        lhs = rhs()
    }
}






//public func |> <T, U> (lhs: T -> Result<U>, rhs: U -> Void) -> T -> Result<U> {
//    return { arg in lhs(arg).map { rhs($0); return $0 } }
//}






/**
    Nil coalescing operator for `Result<T, E>`.
 */
public func ?± <T, E: ErrorType>
    (lhs: T?, @autoclosure rhs: () -> Result<T, E>) -> Result<T, E>
{
    if let lhs = lhs {
        return success(lhs)
    }
    else {
        return rhs()
    }
}

public func ?± <T, E: ErrorType>
    (lhs: Result<T, E>, @autoclosure rhs: () -> Result<T, E>) -> Result<T, E>
{
    switch lhs {
        case .Success: return lhs
        case .Failure: return rhs()
    }
}





postfix operator ‡ {}


/**
   The reverse-args-and-curry operator (type shift+option+7).  Useful in bringing the Swift stdlib collection functions into use in functional pipelines.

   For example: `let lowercaseStrings = someStrings |> mapTo { $0.lowercaseString }`
*/

//public postfix func ‡
//    <T, U, V, R>
//    (f: (T, U, V) -> R) -> V -> ((T, U) -> R) {
//        return { v in { t, u in f(t, u, v) }}
//}


public postfix func ‡
    <T, U, R>
    (f: (T, U) -> R) -> U -> T -> R {
        // @@XYZZY
//        return currySwap(f)
        return { x in { y in f(y, x) }}
}













