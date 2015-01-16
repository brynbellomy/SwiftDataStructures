//
//  Functions.Strings.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public func stringify <T> (something:T) -> String {
    return "\(something)"
}


public func lines (str:String) -> [String] {
    return str |> splitOn("\n")
}


public func dumpString<T>(value:T) -> String {
    var msg = ""
    dump(value, &msg)
    return msg
}


public func pad(string:String, length:Int, #padding:String) -> String {
    return string.stringByPaddingToLength(length, withString:padding, startingAtIndex:0)
}

public func pad(string:String, length:Int) -> String {
    return string.stringByPaddingToLength(length, withString:" ", startingAtIndex:0)
}


//public func padr(length:Int, padding:String = " ") (string:String) -> String {
//    return pad(string, length, padding:padding)
//}


public func padToSameLength <S: SequenceType where S.Generator.Element == String> (strings:S) -> [S.Generator.Element]
{
    let maxLength = strings |> map‡ (countElements)
                            |> maxElement

    return strings |> map‡ (pad‡ (maxLength))
}


public func padKeysToSameLength <V> (dict: [String: V]) -> [String: V]
{
    let maxLength = dict |> map‡ (takeLeft >>> countElements)
                         |> maxElement

    return dict |> mapKeys(pad‡ (maxLength))
}


public func substringFromIndex (index:Int) (string:String) -> String
{
    let newStart = advance(string.startIndex, index)
    return string[newStart ..< string.endIndex]
}



public func substringToIndex (index:Int) (string:String) -> String
{
    let newEnd = advance(string.startIndex, index)
    return string[string.startIndex ..< newEnd]
}


public func describe <T> (array:[T]) -> String
{
    return describe(array) { stringify($0) }
}


public func describe <T> (array:[T], formatElement:(T) -> String) -> String
{
    return array |> map‡ (formatElement >>> indent)
                 |> joinWith(",\n")
                 |> { "[\n\($0)\n]" }
}


public func describe <K, V> (dict:[K: V]) -> String
{
    func renderKeyValue(key:String, value:V) -> String { return "\(key)  \(value)," }

    return dict |> mapKeys { "\($0):" }
                |> padKeysToSameLength
                |> map‡ (renderKeyValue >>> indent)
                |> joinWith("\n")
                |> { "{\n\($0)\n}" }
}


public func describe <K, V> (dict:[K: V], formatClosure:(K, V) -> String) -> String
{
    return dict |> map‡ (formatClosure)
                |> map‡ (indent)
                |> joinWith(",\n")
                |> { "\n\($0)\n" }
}


public func indent(string:String) -> String
{
    let spaces = "    "
    return string |> splitOn("\n")
                  |> map‡   { "\(spaces)\($0)" }
                  |> joinWith("\n")
}


public func basename(path:String) -> String {
    return path.lastPathComponent
}


public func extname(path:String) -> String {
    return path.pathExtension
}


public func dirname(path:String) -> String {
    return path.stringByDeletingLastPathComponent
}


/**
    Generates an NS- or UIColor from a hex color string.

    :param: hex The hex color string from which to create the color object.  '#' sign is optional.
 */
public func rgbaFromHexCode(hex:String) -> (r:UInt32, g:UInt32, b:UInt32, a:UInt32)?
{
    let trimmed = hex["[^a-fA-F0-9]"] ~= "" |> stringify
    let strLen  = countElements(trimmed)

    if strLen != 6 && strLen != 8 {
        return nil
    }

    let groups = String(trimmed)["([:xdigit:][:xdigit:])"].matches()
    if groups.count < 3 {
        return nil
    }

    let (red, green, blue) = (readHexInt(groups[0]), readHexInt(groups[1]), readHexInt(groups[2]))
    var alpha: UInt32?
    if groups.count >= 4 {
        alpha = readHexInt(groups[3])
    }

    if let (r, g, b) = all(red, green, blue)
    {
        if let a = alpha {
            return (r:r, g:g, b:b, a:a)
        }
        else {
            return (r:r, g:g, b:b, a:255)
        }

    }
    return nil
}



/**
    Given a palette of `n` colors and a tuple `(r, g, b, a)` of `UInt32`s, this function will return a tuple (r/n, g/n, b/n, a/n)
 */
public func normalizeRGBA (colors c:UInt32) (r:UInt32, g:UInt32, b:UInt32, a:UInt32) -> (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
    return (r:CGFloat(r/c), g:CGFloat(g/c), b:CGFloat(b/c), a:CGFloat(a/c))
}



public func readHexInt(str:String) -> UInt32? {
    var i: UInt32 = 0
    let success = NSScanner(string:str).scanHexInt(&i)
    return success ? i : nil
}


public func trim(str:String) -> String {
    return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
}


public func rgbaFromRGBAString(string:String) -> (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)?
{
    let sanitized = string["[^0-9,\\.]"] ~= ""
    let parts: [String] = String(sanitized) |> splitOn(",") |> map‡ (trim)
    if parts.count != 4 {
        return nil
    }

    if let (red, green, blue, alpha) = all(parts[0].toCGFloat(), parts[1].toCGFloat(), parts[2].toCGFloat(), parts[3].toCGFloat()) {
        return (r:red, g:green, b:blue, a:alpha)
    }

    return nil
}


private extension String
{
    func toCGFloat() -> CGFloat? {
        return CGFloat((self as NSString).floatValue)
    }
}




