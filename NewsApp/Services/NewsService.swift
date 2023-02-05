//
//  NewsService.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import Foundation
import UIKit

protocol INewsService: AnyObject {
    func fetchNews(page: Int, cachedOnly: Bool, completion: @escaping(Result<[Article], Error>) -> Void)
    func fetchImage(for article: Article, completion: @escaping (UIImage?) -> Void)
    func readCounter(for article: Article) -> Int
    func writeCounter(value: Int, for article: Article)
}

enum NewsServiceError: Error {
    case decodingError
}

final class NewsService: INewsService {
    
    private enum Const {
        static let pageSize = 20
        static let apiKey = "91a90b4764f94bd6afd9a97aeccf86f7"
        static let baseUrl = "https://newsapi.org/v2/everything?domains=wsj.com"
    }
    
    private let networkManager: NetworkManager
    private let articleCache: FileCache<Article>
    private let imageCache: FileCache<Data>
    private let counterCache: FileCache<ViewCounter>
    
    init(
        networkManager: NetworkManager,
        articleCache: FileCache<Article>,
        imageCache: FileCache<Data>,
        counterCache: FileCache<ViewCounter>
    ) {
        self.networkManager = networkManager
        self.articleCache = articleCache
        self.imageCache = imageCache
        self.counterCache = counterCache
    }
    
    func fetchNews(page: Int, cachedOnly: Bool, completion: @escaping (Result<[Article], Error>) -> Void) {
        if cachedOnly {
            // в режиме загрузки кэшированных новостей читаем все файлы из кэша
            let articles = articleCache.allData()
            
            completion(.success(articles))
            return
        }
        
        let url = getBaseUrl(page: page)
        
        networkManager.fetchData(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let news = try JSONDecoder().decode(News.self, from: data)
                    
                    for article in news.articles {
                        // сохраняем статьи в кэш
                        self.articleCache.setData(article, for: article.url)
                    }
                    
                    completion(.success(news.articles))
                } catch {
                    completion(.failure(NewsServiceError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImage(for article: Article, completion: @escaping (UIImage?) -> Void) {
        // если есть картинка в кэше, читаем оттуда
        if let data = imageCache.data(key: article.urlToImage) {
            completion(UIImage(data: data))
            return
        }
        
        networkManager.fetchData(from: article.urlToImage) { [weak self] result in
            switch result {
            case .success(let data):
                guard !data.isEmpty else {
                    completion(nil)
                    return
                }
                completion(UIImage(data: data))
                // сохраняем картинку в кэш
                self?.imageCache.setData(data, for: article.urlToImage)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func readCounter(for article: Article) -> Int {
        if let counter = counterCache.data(key: article.url) {
            return counter.value
        }
        return 0
    }
    
    func writeCounter(value: Int, for article: Article) {
        counterCache.setData(ViewCounter(value: value), for: article.url)
    }
    
    private func getBaseUrl(page: Int) -> String {
        return Const.baseUrl
            .appending("&apiKey=\(Const.apiKey)")
            .appending("&pageSize=\(Const.pageSize)")
            .appending("&page=\(page)")
    }
}
