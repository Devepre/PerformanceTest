//
//  PerformanceTestTests.swift
//  PerformanceTestTests
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import XCTest
@testable import PerformanceTest

final class PerformanceTestTests: XCTestCase {
    private var fileSysytemApproach: FileSysytemApproach!
    private let albumsData3 = Album.randomData(count: 3)
    private let albumsData200 = Album.randomData(count: 200)
    private let albumsData1000 = Album.randomData(count: 1000)
//    private let albumsData9000 = Album.randomData(count: 9000)
    
    override func setUpWithError() throws {
        fileSysytemApproach = .init()
        print(NSHomeDirectory())
    }
    
    override func tearDownWithError() throws {
        fileSysytemApproach.deleteAllFiles()
    }
    
    
    func testCreate200() throws {
        self.measure {
            _ = Album.randomData(count: 200)
        }
    }
    
    func testCreate1000() throws {
        self.measure {
            _ = Album.randomData(count: 1000)
        }
    }
    
    func testSave200() throws {
        self.measure {
            let expectation = expectation(description: "Saved")
            Task {
                let id = UUID().uuidString
                let before = fileSysytemApproach.getNumberOfFiles(folder: id)
                print("Files in folder before test \(before)")
                try await fileSysytemApproach.save(objects: albumsData200, folder: id)
                let after = fileSysytemApproach.getNumberOfFiles(folder: id)
                print("Files in folder after \(after)")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10.0)
        }
    }
    
    func testSave1000() throws {
        self.measure {
            let expectation = expectation(description: "Saved")
            Task {
                let id = UUID().uuidString
                let before = fileSysytemApproach.getNumberOfFiles(folder: id)
                print("Files in folder before test \(before)")
                try await fileSysytemApproach.save(objects: albumsData1000, folder: id)
                let after = fileSysytemApproach.getNumberOfFiles(folder: id)
                print("Files in folder after \(after)")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10.0)
        }
    }
    
    // MARK: - Load
    
    func testLoad200() throws {
        let id = UUID().uuidString
        self.fileSysytemApproach.synchronouslySave(objects: self.albumsData1000, folder: id)
        
        self.measure {
            let expectation = expectation(description: "Loaded")
            Task {
                let before = fileSysytemApproach.getNumberOfFiles(folder: id)
                print("Files in folder before test \(before)")
                let albums = try await fileSysytemApproach.loadAll(from: id)
                print("Number of loaded albums \(albums.count)")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10.0)
        }
    }
}
