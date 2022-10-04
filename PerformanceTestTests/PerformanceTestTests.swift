//
//  PerformanceTestTests.swift
//  PerformanceTestTests
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import XCTest
@testable import PerformanceTest
import CoreData
import SwiftUI

final class PerformanceTestTests: XCTestCase {
//    @Environment(\.managedObjectContext) private var viewContext
    
    private var fileSysytemApproach: FileSysytemApproach!
    private let albumsData3 = Album.randomData(count: 3)
    private let albumsData200 = Album.randomData(count: 200)
    private let albumsData1000 = Album.randomData(count: 1000)
//    private let albumsData9000 = Album.randomData(count: 9000)
    
    var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "PerformanceTest")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
      }()
    
    private let decoder = JSONDecoder()
    
    override func setUpWithError() throws {
        fileSysytemApproach = .init()
        print(NSHomeDirectory())
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let objects = try! context.fetch(req) as! [Item]
        for object in objects {
            context.delete(object)
        }
    }
    
    override func tearDownWithError() throws {
        fileSysytemApproach.deleteAllFiles()
    }
    
    func testCore() throws {
        for (key, value) in albumsData1000 {
            let newItem = Item(context: context)
            newItem.albumId = key.uuidString
            newItem.albumData = value
        }
        
        do {
            print(context)
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        self.measure {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            let objects = try! context.fetch(req) as! [Item]
            
            var result: [Album] = []
            result.reserveCapacity(objects.count)
            
            objects.forEach {
                if let data = $0.albumData,
                   let object = try? decoder.decode(Album.self, from: data) {
                    result.append(object)
                }
            }
        }
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
    
    func testLoad1000() throws {
        let id = UUID().uuidString
        self.fileSysytemApproach.synchronouslySave(objects: self.albumsData1000, folder: id)
        
        self.measure {
            let expectation = expectation(description: "Loaded")
            Task {
//                let before = fileSysytemApproach.getNumberOfFiles(folder: id)
//                print("Files in folder before test \(before)")
                let albums = try await fileSysytemApproach.loadAll(from: id)
//                print("Number of loaded albums \(albums.count)")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10.0)
        }
    }
    
    func testLoadInPara1000() throws {
        let id = UUID().uuidString
        self.fileSysytemApproach.synchronouslySave(objects: self.albumsData1000, folder: id)
        
        self.measure {
            let expectation = expectation(description: "Loaded")
            Task {
//                let before = fileSysytemApproach.getNumberOfFiles(folder: id)
//                print("Files in folder before test \(before)")
                let albums = try await fileSysytemApproach.loadAllParallel(from: id)
//                print("Number of loaded albums \(albums.count)")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10.0)
        }
    }
}
