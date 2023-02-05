import UIKit

protocol IFilesManager: AnyObject {
    func save(fileNamed: String, data: Data) throws
    func delete(fileNamed: String) throws
    func read(fileNamed: String) throws -> Data
    func getAllData() throws -> [Data]
}

final class FilesManager: IFilesManager {
    enum Error: Swift.Error {
        case invalidDirectory
        case fileNotExists
        case readingFailed
        case writingFailed
        case deletingFailed
    }

    private let fileManager: FileManager
    private let dirName: String

    init(fileManager: FileManager = .default, dirName: String) {
        self.fileManager = fileManager
        self.dirName = dirName
    }

    func save(fileNamed: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        do {
            try data.write(to: url)
        } catch {
            debugPrint(error)
            throw Error.writingFailed
        }
    }

    func delete(fileNamed: String) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        do {
            try fileManager.removeItem(at: url)
        } catch {
            debugPrint(error)
            throw Error.deletingFailed
        }
    }

    func read(fileNamed: String) throws -> Data {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        guard fileManager.fileExists(atPath: url.path) else {
            throw Error.fileNotExists
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }

    func getAllData() throws -> [Data] {
        guard let url = makeURL(forFileNamed: "") else {
            throw Error.invalidDirectory
        }
        do {
            var allData: [Data] = []
            let fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if let data = try? read(fileNamed: url.lastPathComponent) {
                    allData.append(data)
                }
            }
            return allData
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    
    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let baseUrl = url.appendingPathComponent(dirName)
        if !fileManager.fileExists(atPath: baseUrl.path) {
            do {
                try fileManager.createDirectory(at: baseUrl, withIntermediateDirectories: true)
            } catch {
                debugPrint(error)
                return nil
            }
        }
        return baseUrl.appendingPathComponent(fileName)
    }
}
