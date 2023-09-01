//
//  ContentView.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 27/08/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var photoListViewModel = CommandLine.arguments.contains("--uitesting") ? PhotoListViewModel(apiService: MockAPIService()) : PhotoListViewModel()
    
    var body: some View {
        NavigationView {
            PhotoListView(viewModel: photoListViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
