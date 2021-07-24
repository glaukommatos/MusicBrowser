//
//  MockDataProvider.swift
//  MusicBrowserTests
//
//  Created by Kyle Pointer on 27.07.21.
//

import Foundation
import Combine
@testable import MusicBrowser

struct MockDataProvider: DataProviderProtocol {
    enum MockDataProviderErrors: Error {
        case noResponseForRequest
    }

    var responses: [URL: Data]

    func download(url: URL) -> AnyPublisher<Data, Error> {
        guard let data = responses[url] else {
            return Fail<Data, Error>(error: MockDataProviderErrors.noResponseForRequest)
                .eraseToAnyPublisher()
        }

        return Future { promise in
            promise(Result.success(data))
        }.eraseToAnyPublisher()
    }
}
