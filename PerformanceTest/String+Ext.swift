//
//  String+Ext.swift
//  PerformanceTest
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import Foundation

extension String {
    static func random(length: Int) -> String {
        let letters = "abcde fghi jklmno pqrstuvwxyz ABCDEF GHIJK LMNOP QRSTUV WXYZ"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    static func random(min: Int, max: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let length = abs(max - min)
        return String(
            (0..<length)
                .map { _ in letters.randomElement()! } +
            (0..<min)
                .map { _ in letters.randomElement()! }
        )
    }
}

extension Array where Element == String {
    static func random(_ number: Int) -> [String] {
        Array((0...number).map { _ in String.random(min: 10, max: 20) })
    }
}
