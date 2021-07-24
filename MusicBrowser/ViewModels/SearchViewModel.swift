//
//  SearchViewModel.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 26.07.21.
//

import Foundation
import Combine

class SearchViewModel {
    private let sessionRepository: SessionRepositoryProtocol
    private let searchSubject = PassthroughSubject<String, Never>()

    @Published var loading = false

    init(sessionRepository: SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    lazy var searchResults = {
        searchSubject
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .flatMap { self.sessionRepository.search(for: $0) }
            .map { $0.shuffled() }
            .handleEvents(receiveOutput: { _ in self.loading = false })
            .eraseToAnyPublisher()
    }()

    func search(for term: String) {
        guard !term.isEmpty else {
            loading = false
            return
        }

        if loading == false {
            loading = true
        }

        searchSubject.send(term)
    }
}
