//
//  DiscoverViewModel.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 26.07.21.
//

import Foundation
import Combine

class DiscoverViewModel {
    private let radioRepository: SessionRepositoryProtocol
    private var fetchMoreSubject = PassthroughSubject<Void, Never>()
    private let maxFetches = 5

    init(radioRepository: SessionRepositoryProtocol) {
        self.radioRepository = radioRepository
    }

    @Published var loading = false

    func fetchMore() {
        fetchMoreSubject.send()
    }

    lazy var sessions = {
        fetchMoreSubject
            .prefix(maxFetches)
            .handleEvents(receiveOutput: { _ in self.loading = true })
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .flatMap { self.radioRepository.current() }
            .handleEvents(receiveOutput: { _ in self.loading = false })
            .eraseToAnyPublisher()
    }()
}
