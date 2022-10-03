//
//  Album.swift
//  PerformanceTest
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import Foundation

struct Album: Codable {
    let id, type, href: String
    let attributes: Attributes
    let relationships: Relationship
    
    static func random(_ count: Int) -> [Album] {
        Array((0..<count).map { _ in
            Album(id: String.random(length: 6),
                         type: String.random(min: 6, max: 10),
                         href: String.random(min: 16, max: 30),
                         attributes: Attributes.random(),
                         relationships: Relationship.random())
        })
    }
    
    static func randomData(count: Int) -> [UUID: Data] {
        let input = Self.random(count)
        var objects: [UUID: Data] = [:]
        input.forEach {
            objects[UUID()] = $0.data()
        }
        return objects
    }
    
    func json() -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return "NULL"
        }
        return String(data: data, encoding: .utf8) ?? "NULL"
    }
    
    func data() -> Data {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return Data()
        }
        return data
    }
}

struct Attributes: Codable {
    static func random() -> Self {
        Attributes(trackCount: Int.random(in: 0...30),
                   genreNames: Array<String>.random(4),
                   releaseDate: String.random(length: 12),
                   name: String.random(min: 5, max: 15),
                   artistName: String.random(min: 5, max: 15),
                   artwork: Artwork.random(),
                   playParams: PlayParam.random(),
                   dateAdded: String.random(length: 20))
    }
    
    let trackCount: Int
    let genreNames: [String]
    let releaseDate: String
    let name: String
    let artistName: String
    let artwork: Artwork
    let playParams: PlayParam
    let dateAdded: String
}

struct Artwork: Codable {
    static func random() -> Self {
        .init(width: Int.random(in: 1000...2000), height: Int.random(in: 1000...2000), url: String.random(min: 15, max: 45))
    }
    let width, height: Int
    let url: String
}

struct PlayParam: Codable {
    static func random() -> Self {
        .init(id: String.random(length: 10), kind: String.random(min: 10, max: 20), isLibrary: Bool.random())
    }
    let id, kind: String
    let isLibrary: Bool
}

struct Relationship: Codable {
    static func random() -> Self {
        .init(tracks: Track.random())
    }
    let tracks: Track
}

struct Track: Codable {
    static func random() -> Self {
        .init(href: String.random(min: 15, max: 45),
              data: TrackData.random(),
              meta: Meta.random())
    }
    let href: String
    let data: [TrackData]
    let meta: Meta
}

struct TrackData: Codable {
    static func random() -> [Self] {
        Array(
            (0...17).map { _ in .init(id: String.random(length: 10),
                                      type: String.random(length: 7),
                                      href: String.random(min: 15, max: 45),
                                      attributes: AttributesData.random()) }
        )
    }
    let id: String
    let type: String
    let href: String
    let attributes: AttributesData
}

struct AttributesData: Codable {
    static func random() -> Self {
        .init(albumName: String.random(min: 5, max: 16),
              discNumber: Int.random(in: 2...20),
              genreNames: Array<String>.random(4),
              hasLyrics: Bool.random(),
              trackNumber: Int.random(in: 1...20),
              releaseDate: String.random(length: 8),
              durationInMillis: Int.random(in: 10_000...60_0000),
              name: String.random(min: 5, max: 20),
              artistName: String.random(min: 5, max: 20),
              artwork: Artwork.random(),
              playParams: PlayParams.random())
    }
    let albumName: String
    let discNumber: Int
    let genreNames: [String]
    let hasLyrics: Bool
    let trackNumber: Int
    let releaseDate: String
    let durationInMillis: Int
    let name: String
    let artistName: String
    let artwork: Artwork
    let playParams: PlayParams
}

struct PlayParams: Codable {
    static func random() -> Self {
        .init(id: String.random(length: 9),
              kind: String.random(length: 5),
              isLibrary: Bool.random(),
              reporting: Bool.random(),
              catalogID: String.random(length: 18),
              reportingID: String.random(min: 10, max: 16))
    }
    let id: String
    let kind: String
    let isLibrary, reporting: Bool
    let catalogID, reportingID: String
}

struct Meta: Codable {
    static func random() -> Self {
        .init(total: Int.random(in: 100...400))
    }
    let total: Int
}
