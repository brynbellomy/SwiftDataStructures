////
////  Functions.Lazy.swift
////  Funky
////
////  Created by bryn austin bellomy on 2015 Jun 3.
////  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
////
//
//public struct Lazy
//{
//    public static func partition <S: SequenceType>
//        (seq: S, predicate: S.Generator.Element -> Bool)
//            -> (LazySequence<AnySequence<S.Generator.Element>>, LazySequence<AnySequence<S.Generator.Element>>)
//    {
//        let pass = seq.lazy.filter { predicate($0) == true } .map { $0 }
//        let fail = seq.lazy.filter { predicate($0) == false }
//        return (AnySequence(pass).lazy, AnySequence(fail).lazy)
//    }
//
//    
//    /**
//        Decomposes a `Dictionary` into a lazy sequence of key-value tuples.
//     */
//    public static func pairs <K: Hashable, V>
//        (dict:[K: V]) -> LazySequence<AnySequence<(K, V)>>
//    {
//        var gen = dict.lazy.generate()
//        return AnySequence(gen).lazy
//    }
//
//
//    public static func selectWhere <S: SequenceType>
//        (predicate: S.Generator.Element -> Bool) (seq: S) -> LazySequence<AnySequence<S.Generator.Element>>
//    {
//        return lazy(AnySequence(lazy(seq).filter(predicate)))
//    }
//
//
//}
//
