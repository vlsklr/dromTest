//
//  FetchImageService.swift
//  DromTest
//
//  Created by v.sklyarov on 29.10.2025.
//

import Foundation

protocol FetchImageServiceProtocol {
    func fetchImage(from url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class FetchImageService {
    
    private let fetchQueue = DispatchQueue(label: "FetchImageService.fetchQueue", qos: .userInitiated)
    
    // MARK: - Properties
    
    private let session: URLSession
    
    // MARK: - Singletone
    
    static let shared = FetchImageService()
    
    // MARK: - Init
    
    private init() {
        // Отключил кэширование для URLSession, чтобы продемонсрировать кэширование на уровне Interactor
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        session = URLSession(configuration: config)
    }
}

// MARK: - FetchImageServiceProtocol

extension FetchImageService: FetchImageServiceProtocol {
    
    func fetchImage(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        fetchQueue.async { [weak self] in
            self?.session.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }.resume()
        }
    }
    
}
