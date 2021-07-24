//
//  DownloadProvider.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 27.07.21.
//

import Foundation
import Combine

/**

 Tiny wrapper around `URLSession.shared.dataTaskPublisher(url:)`

 This is mostly here in order to prevent a direct dependency on `URLSession` in
 other code.

 The `DataProviderError` is there, but isn't really handled specifically anywhere yet.
 I mostly just wanted something to throw right away if we didn't get a 200.

 */

struct DataProvider: DataProviderProtocol {
    enum DataProviderError: Error {
        case unexpectedResponseStatus
    }

    func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw DataProviderError.unexpectedResponseStatus }
                return data
            }.eraseToAnyPublisher()
    }
}
