//
//  Regex.swift
//  Regex
//
//  Created by John Holdsworth on 26/06/2014.
//  Copyright (c) 2014 John Holdsworth.
//
//  $Id: //depot/Regex/Regex.swift#37 $
//
//  This code is in the public domain from:
//  https://github.com/johnno1962/SwiftRegex
//

import Foundation


private var swiftRegexCache = [String: NSRegularExpression]()

public class Regex: NSObject, BooleanType
{
    public private(set) var target: NSString
    public private(set) var regex:  NSRegularExpression


    public init(target t:NSString, pattern:String, options:NSRegularExpressionOptions = nil)
    {
        target = t

        if let r = swiftRegexCache[pattern] {
            regex = r
        }
        else
        {
            var error: NSError?

            if let r = NSRegularExpression(pattern: pattern, options:options, error:&error) {
                swiftRegexCache[pattern] = r
                regex = r
            }
            else {
                Regex.failure("Error in pattern: \(pattern) - \(error)")
                regex = NSRegularExpression()
            }
        }
        super.init()
    }


    private class func failure(message: String) {
        println("Regex: "+message)
        //assert(false,"Regex: failed")
    }


    public final var targetRange: NSRange {
        return NSRange(location:0, length:target.length)
    }


    public final func substring(range: NSRange) -> NSString!
    {
        if range.location != NSNotFound {
            return target.substringWithRange(range)
        }
        else { return nil }
    }


    public func doesMatch(options: NSMatchingOptions = nil) -> Bool {
        return range(options: options).location != NSNotFound
    }


    public func range(options: NSMatchingOptions = nil) -> NSRange {
        return regex.rangeOfFirstMatchInString(target, options: nil, range: targetRange)
    }


    public func match(options: NSMatchingOptions = nil) -> String! {
        return substring(range(options: options))
    }


    public func groups(options: NSMatchingOptions = nil) -> [String]! {
        return groupsForMatch(regex.firstMatchInString(target, options:options, range:targetRange))
    }


    public func groupsForMatch(match: NSTextCheckingResult!) -> [String]!
    {
        if match != nil
        {
            var groups = [String]()
            for groupno in 0 ... regex.numberOfCaptureGroups
            {
                if let group = substring(match.rangeAtIndex(groupno)) as String! {
                    groups += [group]
                }
                else {
                    groups += ["_"] // avoids bridging problems
                }
            }
            return groups
        }
        else { return nil }
    }


    public subscript(groupno: Int) -> String!
    {
        get { return groups()[groupno] }
        set {
            if let mutableTarget = target as? NSMutableString
            {
                for match in matchResults().reverse() {
                    let replacement = regex.replacementStringForResult(match, inString:target, offset:0, template:newValue)
                    mutableTarget.replaceCharactersInRange(match.rangeAtIndex(groupno), withString:replacement)
                }
            }
            else { Regex.failure("Group modify on non-mutable") }
        }
    }


    public func matchResults(options: NSMatchingOptions = nil) -> [NSTextCheckingResult] {
        return regex.matchesInString(target, options: options, range: targetRange) as [NSTextCheckingResult]
    }


    public func ranges(options: NSMatchingOptions = nil) -> [NSRange] {
        return matchResults(options: options).map { $0.range }
    }


    public func matches(options: NSMatchingOptions = nil) -> [String] {
        return matchResults(options: options).map { self.substring($0.range) }
    }


    public func allGroups(options: NSMatchingOptions = nil) -> [[String]] {
        return matchResults(options: options).map { self.groupsForMatch($0) }
    }


    public func dictionary(options: NSMatchingOptions = nil) -> [String: String]
    {
        var out = [String: String]()
        for match in matchResults(options: options) {
            out[ substring(match.rangeAtIndex(1)) ] = substring(match.rangeAtIndex(2))
        }
        return out
    }


    public func substituteMatches(substitution: (NSTextCheckingResult, UnsafeMutablePointer<ObjCBool>) -> String,
                                       options:  NSMatchingOptions = nil)
        -> NSMutableString
    {
        let out = NSMutableString()
        var pos = 0

        regex.enumerateMatchesInString(target, options:options, range:targetRange) {
            (match:NSTextCheckingResult!, flags:NSMatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) in

            let matchRange = match.range
            out.appendString(self.substring( NSRange(location:pos, length:matchRange.location-pos) ))
            out.appendString(substitution(match, stop))
            pos = matchRange.location + matchRange.length
        }

        out.appendString(substring(NSRange(location:pos, length:targetRange.length - pos)))

        if let mutableTarget = target as? NSMutableString {
            mutableTarget.setString(out)
            return mutableTarget
        }
        else {
            Regex.failure("Modify on non-mutable")
            return out
        }
    }

    public var boolValue: Bool {
        return doesMatch()
    }
}


extension NSString {
    public subscript(pattern:String, options:NSRegularExpressionOptions) -> Regex {
        return Regex(target:self, pattern:pattern, options:options)
    }
}


extension NSString {
    public subscript(pattern:String) -> Regex {
        return Regex(target:self, pattern:pattern)
    }
}


extension String {
    public subscript(pattern:String, options:NSRegularExpressionOptions) -> Regex {
        return Regex(target:self, pattern:pattern, options:options)
    }
}


extension String {
    public subscript(pattern:String) -> Regex {
        return Regex(target:self, pattern:pattern)
    }
}


public func RegexMutable(string: NSString) -> NSMutableString {
    return NSMutableString(string:string)
}


public func ~= (left: Regex, right:String) -> NSMutableString
{
    return left.substituteMatches {
        (match: NSTextCheckingResult, stop: UnsafeMutablePointer<ObjCBool>) in
        return left.regex.replacementStringForResult(match, inString:left.target, offset:0, template:right)
    }
}


public func ~= (left: Regex, right: [String]) -> NSMutableString
{
    var matchNumber = 0
    return left.substituteMatches {
        (match: NSTextCheckingResult, stop: UnsafeMutablePointer<ObjCBool>) in

        if ++matchNumber == right.count {
            stop.memory = true
        }

        return left.regex.replacementStringForResult(match, inString:left.target, offset:0, template:right[matchNumber - 1])
    }
}


public func ~= (left: Regex, right: (String) -> String) -> NSMutableString
{
    return left.substituteMatches {
        (match: NSTextCheckingResult, stop: UnsafeMutablePointer<ObjCBool>) in
        return right(left.substring(match.range))
    }
}


public func ~= (left: Regex, right: ([String]) -> String) -> NSMutableString
{
    return left.substituteMatches {
        (match: NSTextCheckingResult, stop: UnsafeMutablePointer<ObjCBool>) in
        return right(left.groupsForMatch(match))
    }
}



