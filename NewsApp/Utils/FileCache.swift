//
//  FileCache.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import Foundation

final class FileCache<D: Codable>: Cacheable {
    typealias T = D

    private let filesManager: IFilesManager

    init(filesManager: IFilesManager) {
        self.filesManager = filesManager
    }

    // MARK: - Cacheable

    func data(key: String) -> D? {
        guard
            let key = makeKey(for: key),
            let fileData = try? filesManager.read(fileNamed: key),
            let decoded = try? JSONDecoder().decode(D.self, from: fileData)
        else {
            return nil
        }
        return decoded
    }

    func setData(_ data: D?, for key: String) {
        guard let key = makeKey(for: key) else { return }

        if let data = data,
           let encoded = try? JSONEncoder().encode(data) {
            try? filesManager.save(fileNamed: key, data: encoded)
        } else {
            try? filesManager.delete(fileNamed: key)
        }
    }

    func allData() -> [D] {
        guard let datas = try? filesManager.getAllData() else {
            return []
        }
        var result: [D] = []
        for data in datas {
            if let decoded = try? JSONDecoder().decode(D.self, from: data) {
                result.append(decoded)
            }
        }
        return result
    }
    
    private func makeKey(for key: String) -> String? {
        guard !key.isEmpty else { return nil }
        return key
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: "&", with: "")
    }
}
