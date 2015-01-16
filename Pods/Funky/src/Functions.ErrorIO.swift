//
//  Functions.ErrorIO.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 14.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit


public func coalesce <T> (arr:[Result<T>]) -> Result<[T]>
{
    let failures = selectFailures(arr)
    if failures.count > 0 {
        let errorIO = failures.reduce(ErrorIO(), <~)
        return failure(errorIO)
    }
    else {
        return success(rejectFailures(arr))
    }
}


public func failure <T> (message: String, file: String = __FILE__, line: Int = __LINE__) -> Result<T>
{
    let userInfo: [NSObject: AnyObject] = [
        NSLocalizedDescriptionKey: message,
        "file": file,
        "line": line,
    ]
    return failure(ErrorIO.defaultError(userInfo))
}


public func failure <T> (file: String = __FILE__, line: Int = __LINE__) -> Result<T> {
    return failure("", file: file, line: line)
}



