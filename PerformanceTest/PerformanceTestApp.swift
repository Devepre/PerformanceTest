//
//  PerformanceTestApp.swift
//  PerformanceTest
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import SwiftUI

@main
struct PerformanceTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
