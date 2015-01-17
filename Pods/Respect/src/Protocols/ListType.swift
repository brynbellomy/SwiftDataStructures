//
//  ListType.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Jan 7.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


public protocol ListType
{
    typealias ListElement
    typealias ListIndex: ForwardIndexType = Int

    var first: ListElement? { get }
    var last:  ListElement? { get }
    var count: ListIndex.Distance { get }
}


extension Array: ListType {}



