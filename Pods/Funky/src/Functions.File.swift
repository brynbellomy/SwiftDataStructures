//
//  Functions.File.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Feb 9.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation

private let kPathSeparator: Character = "/"

//
// MARK: - File functions
//

/**
    Equivalent to the Unix `basename` command.  Returns the last path component of `path`.
 */
public func basename(path:String) -> String {
    return (path as NSString).lastPathComponent
}


/**
    Equivalent to the Unix `extname` command.  Returns the path extension of `path`.
 */
public func extname(path:String) -> String {
    return (path as NSString).pathExtension
}


/**
    Equivalent to the Unix `dirname` command.  Returns the parent directory of the
    file or directory residing at `path`.
 */
public func dirname(path:String) -> String {
    return (path as NSString).stringByDeletingLastPathComponent
}


/**
    Returns an array of the individual components of `path`.  The path separator is
    assumed to be `/`, as Swift currently only runs on OSX/iOS.
 */
public func pathComponents(path:String) -> [String] {
    return path.characters.split { $0 == kPathSeparator }.map(String.init)
}


/**
    Returns the relative path (`from` -> `to`).
 */
public func relativePath(from from:String, to:String) -> String
{
    let fromParts = pathComponents(from)
    let toParts   = pathComponents(to)

//    let sharedParts = zipseq(fromParts, toParts)
//                    |> takeWhile(==)
//                    |> mapTo(takeLeft)

    let relativeFromParts = Array(fromParts.suffix(Int.max))
    let relativeToParts   = Array(toParts.suffix(Int.max))

    var relativeParts: [String] = []
    for _ in relativeFromParts {
        relativeParts.append("..")
    }

    relativeParts.appendContentsOf(relativeToParts)

    return relativeParts |> joinWith("\(kPathSeparator)")
}





