//
//  ErrorIO.swift
//  Funky
//
//  Created by bryn austin bellomy on 2015 Jan 6.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation

private func formatError(error:ErrorType) -> String
{
    if let errorIO = error as? ErrorIO {
        return errorIO.localizedDescription
    }
    else {
        let error = error as NSError
        if let file = error.userInfo["file"] as? String, line = error.userInfo["line"] as? Int {
            return "[\(file) : \(line)] \(error.localizedDescription)"
        }
        return "\(error.localizedDescription)"
    }
}


/**
    The primary purpose of `ErrorIO` (which conforms to `ErrorType`) is to attempt to standardize a
    method for coalescing multiple errors.  For example, a task with multiple subtasks might
    return a `Result<T>` the error type of which is an `ErrorIO` containing multiple errors
    from multiple failed subtasks.  `ErrorIO` implements `SequenceType`, `CollectionType`,
    `ExtensibleCollectionType`, and `ArrayLiteralConvertible`.
 */
public class ErrorIO: ErrorType, ArrayLiteralConvertible
{
    public struct Constants {
        public static let FileKey = "__file__"
        public static let LineKey = "__line__"
    }

    /** The default error domain for `ErrorIO` objects. */
    public class var defaultDomain: String { return "com.illumntr.ErrorIO" }

    /** The default error code for `ErrorIO` objects. */
    public class var defaultCode: Int { return 1 }

    /** The `Element` of `ErrorIO` when considered as a sequence/collection. */
    public typealias Element = ErrorType

    /** The type of the underlying collection that holds the `ErrorType`s contained by this `ErrorIO`. */
    public typealias UnderlyingCollection = [Element]

    /** The errors contained by this `ErrorIO`. */
    public private(set) var errors = UnderlyingCollection()

    public var hasErrors: Bool { return errors.count > 0 }

    public var localizedDescription: String {
        let localizedErrors = describe(errors) { formatError($0) |> indent }
        return "<ErrorIO: errors = \(localizedErrors)>"
    }
    
    public init() {
    }

    convenience required public init(arrayLiteral errors: Element...) {
        self.init()
        extend(errors)
    }

    public class func defaultError(userInfo: [NSObject: AnyObject]) -> ErrorIO {
        return ErrorIO() <~ NSError(domain: ErrorIO.defaultDomain, code: ErrorIO.defaultCode, userInfo: userInfo)
    }

    public class func defaultError(message message: String, file: String = __FILE__, line: Int = __LINE__) -> ErrorIO
    {
        let userInfo: [NSObject: AnyObject] = [
            NSLocalizedDescriptionKey: message,
            Constants.FileKey:         file,
            Constants.LineKey:         line,
        ]
        return defaultError(userInfo)
    }

    public class func defaultError(file: String = __FILE__, line: Int = __LINE__) -> ErrorIO {
        let userInfo: [NSObject: AnyObject] = [ Constants.FileKey: file, Constants.LineKey: line, ]
        return defaultError(userInfo)
    }

    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func asResult <T> () -> Result<T, ErrorIO> {
        return Result<T, ErrorIO>.Failure(Box(self))
    }
}


//-
// MARK: - Error: SequenceType
//__

extension ErrorIO: SequenceType
{
    public func generate() -> AnyGenerator<Element>
    {
        var generator = errors.generate()
        return anyGenerator { return generator.next() }
    }
}


//-
// MARK: - Error: CollectionType
//__

extension ErrorIO: CollectionType
{
    public typealias Index = UnderlyingCollection.Index
    public var startIndex : Index { return errors.startIndex }
    public var endIndex   : Index { return errors.endIndex }

    /** Retrieves the `ErrorType` at the specified `index`. */
    public subscript(position:Index) -> Element {
        return errors[position]
    }
}


//-
// MARK: - Error: ExtensibleCollectionType
//__

extension ErrorIO //: RangeReplaceableCollectionType
{
    public func reserveCapacity(n: Index.Distance) {
        errors.reserveCapacity(n)
    }

    /**
        This method is simply an alias for `push()`, included for `ExtensibleCollectionType` conformance.
     */
    public func append(newElement:Element) {
        errors.append(newElement)
    }


    /**
        Element order is [bottom, ..., top], as if one were to iterate through the sequence in forward order, calling `stack.push(element)` on each element.
     */
    public func extend <S: SequenceType where S.Generator.Element == Element> (sequence: S) {
        errors.appendContentsOf(sequence)
    }
}




//-
