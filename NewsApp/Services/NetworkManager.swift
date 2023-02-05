//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import Foundation

enum NetworkError: Error {
    case noData
    case invalidUrl
}

protocol INetworkManager: AnyObject {
    func fetchData(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void)
}

final class NetworkManager: INetworkManager {
    
    init() {}
    
    func fetchData(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "")
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
