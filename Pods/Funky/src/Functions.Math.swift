//
//  Functions.Math.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 13.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


/**
    Returns a random Float value between min and max (inclusive).

    :param: min
    :param: max
    :returns: Random number
*/
public func random(min: Float = 0, #max: Float) -> Float
{
    let diff = max - min
    let rand = Float(arc4random() % (UInt32(RAND_MAX) + 1))
    return ((rand / Float(RAND_MAX)) * diff) + min
}


public func sum
    <S: SequenceType where S.Generator.Element: IntegerType>
    (nums: S) -> S.Generator.Element
{
    return reduce(nums, 0) { $0.0 + $0.1 }
}
