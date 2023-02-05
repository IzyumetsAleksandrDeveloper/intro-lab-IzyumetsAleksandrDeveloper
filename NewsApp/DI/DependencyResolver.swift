//
//  DependencyResolver.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 05.02.2023.
//

import Foundation

final class DependencyResolver {
    
    var newsAssembly: INewsAssembly = {
        NewsAssembly()
    }()
    
    var newsDetailsAssembly: INewsDetailsAssembly = {
        NewsDetailsAssembly()
    }()
}
