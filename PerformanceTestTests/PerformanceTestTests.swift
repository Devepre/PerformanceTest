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

    override func setUpWithError() throws {
        fileSysytemApproach = .init()
    }

    override func tearDownWithError() throws {
        fileSysytemApproach.deleteAllFiles()
    }

    func testPerformance100() throws {
        let albumsData = Album.randomData(count: 10)
        
        self.measure {
            fileSysytemApproach.save(objects: albumsData)
        }
    }

}
