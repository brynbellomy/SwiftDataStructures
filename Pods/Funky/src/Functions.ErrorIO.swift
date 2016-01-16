//
//  Functions.ErrorIO.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 14.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


public func coalesce
    <T, E: NSError>
    (arr: [Result<T, E>]) -> Result<[T], ErrorIO>
{
    let failures = selectFailures(arr)
    if failures.count > 0 {
        let errorIO = failures.reduce(ErrorIO(), combine: <~)
        return errorIO |> asResult
    }
    else {
        return success(rejectFailures(arr))
    }
}

public func coalesce2
    <T, U, E: NSError>
    (arr: [(Result<T, E>, Result<U, E>)]) -> Result<[(T, U)], ErrorIO>
{
    let errorIO = arr |> reducer(ErrorIO()) { (into, each) in
        let (left, right) = each

        if let error = left.error  { into <~ error }
        if let error = right.error { into <~ error }
        return into
    }

    if errorIO.hasErrors {
        return errorIO.asResult()
    }
    else {
        return arr.map { ($0.0.value!, $0.1.value!) } |> success
    }
}


public func failure <T> (message: String, file: String = __FILE__, line: Int = __LINE__) -> Result<T, ErrorIO> {
//    let err = ErrorIO.defaultError(message, file:file, line:line)
//    let res: Result<T, ErrorIO> = err |> asResult
    return ErrorIO.defaultError(message:message, file:file, line:line)
                  .asResult()
}

public func failure <T> (nserror:NSError, file: String = __FILE__, line: Int = __LINE__) -> Result<T, ErrorIO> {
//    let err = ErrorIO.defaultError(message, file:file, line:line)
//    let res: Result<T, ErrorIO> = err |> asResult
    let err = ErrorIO()
    err <~ nserror
    return err.asResult()
}


public func asResult <T, E> (error:E) -> Result<T, E> {
    return Result<T, E>.Failure(Box(error))
}


//public func failure <T, E> (file: String = __FILE__, line: Int = __LINE__) -> Result<T, E> {
//    return failure("", file: file, line: line)
//}



