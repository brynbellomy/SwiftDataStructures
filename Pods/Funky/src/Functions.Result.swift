//
//  Functions.Result.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 April 18.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//



/**
    This function simply calls `result.isSuccess()` but is more convenient in functional pipelines.
 */
public func isSuccess <T, E> (result:Result<T, E>) -> Bool {
    return result.isSuccess
}


/**
    This function simply calls `!result.isSuccess()` but is more convenient in functional pipelines.
 */
public func isFailure <T, E> (result:Result<T, E>) -> Bool {
    return !isSuccess(result)
}


/**
    This function simply calls `result.value()` but is more convenient in functional pipelines.
 */
public func unwrapValue <T, E> (result: Result<T, E>) -> T? {
    return result.value
}


/**
    This function simply calls `result.error()` but is more convenient in functional pipelines.
 */
public func unwrapError <T, E> (result: Result<T, E>) -> E? {
    return result.error
}


public func selectFailures
    <T, E>
    (array: [Result<T, E>]) -> [E]
{
    return array |> mapFilter { $0.error }
}


public func rejectFailures <T, E>
    (source: [Result<T, E>]) -> [T]
{
    return source |> rejectIf({ !$0.isSuccess })
                  |> mapFilter(unwrapValue)
}


public func rejectFailuresAndDispose <T, E>
    (disposal:E -> Void) (source: [Result<T, E>]) -> [T]
{
    return source |> rejectIfAndDispose({ !isSuccess($0) })({ disposal($0.error!) })
                  |> mapFilter(unwrapValue)
}

