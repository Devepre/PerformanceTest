//
//  ContentView.swift
//  PerformanceTest
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.albumId, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private let decoder = JSONDecoder()

    var body: some View {
//        MainView()
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
        VStack {
            Button("Core data save") {
                let albums = Album.randomData(count: 1000)
                for (key, value) in albums {
                    let newItem = Item(context: viewContext)
                    newItem.albumId = key.uuidString
                    newItem.albumData = value
                }
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            .padding()
            
            Button("Delete all") {
                for object in items {
                    viewContext.delete(object)
                }
            }
            
            Button("Load all") {
                let start = DispatchTime.now()
                let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
                let objects = try! viewContext.fetch(req) as! [Item]
                
                var result: [Album] = []
                result.reserveCapacity(objects.count)
                
                objects.forEach {
                    if let data = $0.albumData,
                       let object = try? decoder.decode(Album.self, from: data) {
                        result.append(object)
                    }
                }
                
                let end = DispatchTime.now()
                let dif = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                print("\(dif)")
            }
            .padding()
            
            List {
                ForEach(items) { item in
                    Text(item.albumId ?? "NULL")
                }
            }
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
