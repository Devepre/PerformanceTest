//
//  MainView.swift
//  PerformanceTest
//
//  Created by Serhii Kyrylenko on 03.10.2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Button("Tap me") {
                let result = Album.random(4)
                print(result.first!.json())
            }
            .padding()
            
            Button("Save") {
                let albumsData = Album.randomData(count: 5)
                FileSysytemApproach.shared.save(objects: albumsData)
            }
            .padding()
            
            Button("Load") {
                let albums = FileSysytemApproach.shared.loadAll()
                print(albums)
            }
            .padding()
        }
        .onAppear {
            print(NSHomeDirectory())
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
