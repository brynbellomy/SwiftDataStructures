//
//  Operators.ErrorIO.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 14.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


infix operator <~ { associativity left }

public func <~ (var lhs:ErrorIO, rhs:NSError) -> ErrorIO {
    lhs.append(rhs)
    return lhs
}

public func <~ (var lhs:ErrorIO, rhs:ErrorIO) -> ErrorIO {
    lhs.extend(rhs)
    return lhs
}



