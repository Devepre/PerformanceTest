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
    
    func save(objects: [UUID: Data], folder: String) async throws {
        for (key, value) in objects {
            try await storeToDisk(value, name: key.uuidString, folder: folder)
        }
    }
    
    func synchronouslySave(objects: [UUID: Data], folder: String) {
        for (key, value) in objects {
            _storeToDisk(value, name: key.uuidString, folder: folder)
        }
    }
    
    func loadAll(from folder: String) async throws -> [Album] {
        let path = documentsDirectory.appendingPathComponent(folder, isDirectory: true)
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil) else {
            throw GeneralError.folderIsAbsent
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
            try! fileManager.removeItem(at: $0)
        }
    }
    
    func getNumberOfFiles(folder: String) -> Int {
        let path = documentsDirectory.appendingPathComponent(folder, isDirectory: true)
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil) else {
            return 0
        }
        
        return fileURLs.count
    }
    
    private func storeToDisk(_ data: Data, name: String, folder: String) async throws {
        let folderURL = documentsDirectory
            .appendingPathComponent(folder, isDirectory: true)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try! fileManager.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true)
        }
        let fileURL = folderURL.appendingPathComponent(name, isDirectory: false)
        try data.write(to: fileURL)
    }
    
    private func _storeToDisk(_ data: Data, name: String, folder: String) {
        let folderURL = documentsDirectory
            .appendingPathComponent(folder, isDirectory: true)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try! fileManager.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true)
        }
        let fileURL = folderURL.appendingPathComponent(name, isDirectory: false)
        try? data.write(to: fileURL)
    }
}

enum GeneralError: Error {
    case folderIsAbsent
}
