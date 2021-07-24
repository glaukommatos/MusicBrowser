//
//  SessionRepositoryResponseModels.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 25.07.21.
//

import Foundation

/**

 The Codable model for the API response.

 */

struct SessionResponseModel: Codable {
    let data: Data
}

extension SessionResponseModel {
    struct Data: Codable {
        let sessions: [Session]
    }
}

extension SessionResponseModel.Data {
    struct Session: Codable, Equatable {
        let name: String
        let genres: [String]
        let listenerCount: Int
        let currentTrack: Track
    }
}

extension SessionResponseModel.Data.Session {
    struct Track: Codable, Equatable {
        let title: String
        let artworkUrl: URL
    }
}
