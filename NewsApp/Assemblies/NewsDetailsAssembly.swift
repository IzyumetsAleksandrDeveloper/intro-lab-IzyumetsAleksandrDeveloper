//
//  NewsDetailsAssembly.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 05.02.2023.
//

import Foundation

protocol INewsDetailsAssembly {
    func assemble(article: Article) -> NewsDetailsViewController
}

final class NewsDetailsAssembly: INewsDetailsAssembly {
    func assemble(article: Article) -> NewsDetailsViewController {
        let networkManager = NetworkManager()
        let articleFilesManager = FilesManager(dirName: "Articles")
        let articleCache = FileCache<Article>(filesManager: articleFilesManager)
        let imageFilesManager = FilesManager(dirName: "Images")
        let imageCache = FileCache<Data>(filesManager: imageFilesManager)
        let counterFilesManager = FilesManager(dirName: "Counters")
        let counterCache = FileCache<ViewCounter>(filesManager: counterFilesManager)
        let newsService = NewsService(
            networkManager: networkManager,
            articleCache: articleCache,
            imageCache: imageCache,
            counterCache: counterCache
        )
        let viewController = NewsDetailsViewController(newsService: newsService, article: article)
        
        return viewController
    }
}
