//
//  DataProviderProtocol.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation
import Combine

protocol DataProviderProtocol {
    func download(url: URL) -> AnyPublisher<Data, Error>
}
