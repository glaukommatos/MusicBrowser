//
//  SessionRepositoryProtocol.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation
import Combine

protocol SessionRepositoryProtocol {
    func current() -> AnyPublisher<[Session], Error>
    func search(for term: String) -> AnyPublisher<[Session], Error>
}
