//
//  Model.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//


import Foundation

struct News: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
