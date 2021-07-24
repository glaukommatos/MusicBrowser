//
//  Spy.swift
//  MusicBrowserTests
//
//  Created by Kyle Pointer on 27.07.21.
//

import Foundation

/**

 Make it a bit more straightforward to test publishers.

 */

class Spy<T> {
    var calls = [T]()

    func send(_ value: T) {
        calls.append(value)
    }
}
