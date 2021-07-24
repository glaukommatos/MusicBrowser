//
//  SessionRepository.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 26.07.21.
//

import Foundation
import Combine

/**

 This repository provides access to the backend API and produces publishers
 for fully-formed `Session` objects (i.e., including their imageData).

 You'll notice that the `search(for:)` method doesn't really do anything
 with the search term, but this would be straightforward to change given
 an API that can actually handle it. :)

 The URLs are also just constants and aren't build per-request, but that's only
 because at the moment they're always going to be the same.

 Since I have not written any code to consume errors from these publishers,
 I have not implemented much error handling.

 */

struct SessionRepository: SessionRepositoryProtocol {
    private var imageCache = NSCache<NSURL, NSData>()
    private let currentUrl = URL(string: "https://www.mocky.io/v2/5df79a3a320000f0612e0115")!
    private let searchUrl = URL(string: "https://www.mocky.io/v2/5df79b1f320000f4612e011e")!

    private let dataProvider: DataProviderProtocol

    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    func current() -> AnyPublisher<[Session], Error> {
        fetchSessions(from: currentUrl)
    }

    func search(for term: String) -> AnyPublisher<[Session], Error> {
        fetchSessions(from: searchUrl)
    }

    private func fetchSessions(from url: URL) -> AnyPublisher<[Session], Error> {
        dataProvider.download(url: url)
            .decode(type: SessionResponseModel.self, decoder: Serialization.decoder)
            .map({ $0.data.sessions })
            .flatMap(maxPublishers: .max(5)) { sessions in
                sessions
                    .publisher
                    .flatMap(loadSessionWithImage(responseSession:))
                    .collect()
            }.eraseToAnyPublisher()
    }

    private func loadSessionWithImage(
        responseSession: SessionResponseModel.Data.Session
    ) -> AnyPublisher<Session, Never> {
        dataProvider.download(url: responseSession.currentTrack.artworkUrl)
            .map { imageData in
                mapSession(from: responseSession, with: imageData)
            }
            .replaceError(with:
                mapSession(from: responseSession, with: nil)
            )
            .eraseToAnyPublisher()
    }

    private func mapSession(
        from responseSession: SessionResponseModel.Data.Session, with imageData: Data?
    ) -> Session {
        Session(
            name: responseSession.name,
            genres: responseSession.genres,
            listenerCount: responseSession.listenerCount,
            imageData: imageData
        )
    }
}
