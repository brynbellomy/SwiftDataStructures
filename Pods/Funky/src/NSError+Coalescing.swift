//
//  NSError+Coalescing.swift
//  Funky
//
//  Created by bryn austin bellomy on 2014 Dec 9.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


public extension NSError
{


    public class func multiError(errors:[NSError]) -> NSError {
        var errorIO = ErrorIO()
        errorIO.extend(errors)
        return NSError(domain:"com.illumntr.multi-error", code:1, userInfo: [Keys.IsMultiError: true, Keys.ErrorIO: errorIO])
    }

//    public var isMultiError: Bool     { return (userInfo?[Keys.IsMultiError] as? Bool) ?? false }
    public var errorIO:      ErrorIO? { return userInfo?[Keys.ErrorIO] as? ErrorIO }


//    public var multiErrorDescription: String {
//        if isMultiError { return errorIO?.localizedDescription ?? localizedDescription }
//        else            { return localizedDescription }
//    }


    public class func coalesce(errors:[NSError]) -> NSError
    {
        return errors |> reducer([NSError]()) { (var into, error) in
                             if let io = error.errorIO {
                                 into.extend(io)
                             }
                             else {
                                 into.append(error)
                             }
                             return into
                         }

                     |> { NSError.multiError($0) }
    }


    private struct Keys {
        static let IsMultiError = "is multi error"
        static let ErrorIO = "ErrorIO"
    }
}


