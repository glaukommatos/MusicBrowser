//
//  Session.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 26.07.21.
//

import Foundation

/**

 This is the model used to represent a session in the UI.

 I'm not sure exactly how I feel about it actually having imageData on it
 directly, but it was convenient to let the `SessionRepository` handle
 image fetching and keep it out of the views– in addition I wanted to
 avoid having to show any placeholders to the user when the data
 is loaded.

 */

struct Session: Hashable {
    let uuid = UUID()
    let name: String
    let genres: [String]
    let listenerCount: Int
    let imageData: Data?
}
