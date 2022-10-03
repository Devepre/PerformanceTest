//
//  FileSysytemApproach.swift
//  PerformanceTest
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import Foundation

class FileSysytemApproach {
    static let shared = FileSysytemApproach()
    
    private let fileManager = FileManager.default
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private let decoder = JSONDecoder()
    
    func save(objects: [UUID: Data]) {
        Task {
            let start = Date().timeIntervalSince1970
            for (key, value) in objects {
                try await storeToDisk(value, name: key.uuidString)
            }
            let end = Date().timeIntervalSince1970
            print(end - start)
        }
    }
    
    func loadAll() -> [Album] {
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil) else {
            return []
        }
        var result: [Album] = []
        result.reserveCapacity(fileURLs.count)
        
        fileURLs.forEach {
            if let data = try? Data(contentsOf: $0),
               let object = try? decoder.decode(Album.self, from: data) {
                result.append(object)
            }
        }
        
        return result
    }
    
    func deleteAllFiles() {
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil) else {
            return
        }
        fileURLs.forEach {
            try? fileManager.removeItem(at: $0)
        }
    }
    
    private func storeToDisk(_ data: Data, name: String) async throws {
        let fileURL = documentsDirectory.appendingPathComponent(name)
        try data.write(to: fileURL)
    }
}
