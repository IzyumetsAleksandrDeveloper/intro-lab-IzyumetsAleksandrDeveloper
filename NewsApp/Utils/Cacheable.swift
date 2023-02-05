//
//  Cacheable.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import Foundation

protocol Cacheable {
    associatedtype T

    func data(key: String) -> T?
    func setData(_ data: T?, for key: String)
    func allData() -> [T]
}
