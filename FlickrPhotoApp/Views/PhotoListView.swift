//
//  PhotoListView.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 27/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI

// Main Photo List View
struct PhotoListView: View {
    @StateObject var viewModel: PhotoListViewModel // ViewModel for fetching and holding photo data
    @State private var searchText: String = "" // Search bar text
    @State private var hasSearched: Bool = false // Flag for whether the search button was clicked
    
    var body: some View {
        VStack {
            // Display search bar only if username is empty
            if viewModel.searchUsernameText.isEmpty {
                // Custom SearchBar view
                SearchBar(text: $searchText, onSearchButtonClicked: {
                    hasSearched = true // User clicked search button
                    viewModel.fetchPhotos(searchTerm: searchText)
                })
            }
            // Custom Photo List View
            PhotoList(photosInfo: $viewModel.photosInfo, hasSearched: $hasSearched, isLoading: $viewModel.isLoading)
        }
        .navigationTitle(viewModel.searchUsernameText.isEmpty ? "Flickr Photos" : viewModel.searchUsernameText)
        .navigationBarTitleDisplayMode(.large)
    }
}

// Subview to show either a loading state, a no results state, or the list of photos
struct PhotoList: View {
    @Binding var photosInfo: [PhotoInfo]
    @Binding var hasSearched: Bool // Flag to check if search button clicked
    @Binding var isLoading: Bool // Loading state flag
    
    var body: some View {
        
        if isLoading {
            // Loading view
            List {
                ProgressView("Loading...")
            }
        } else {
            // No Results state
            if hasSearched && photosInfo.isEmpty {
                List {
                    Text("No Results")
                        .foregroundColor(.gray)
                        .italic()
                }
            } else {
                // List of Photos
                List($photosInfo, id: \.id) { photoInfo in
                    PhotoRow(photoInfo: photoInfo)
                }
                .accessibilityIdentifier("photoListViewTable")
            }
        }
    }
}

// Single Photo Row View
struct PhotoRow: View {
    @Binding var photoInfo: PhotoInfo
    @State private var isActive: Bool = false // Flag for navigation state
    
    var body: some View {
        NavigationLink(destination: PhotoDetailView(photoInfo: photoInfo)) {
            HStack(spacing: 16) {
                // Show image from URL
                if let url = URL(string: photoInfo.photo.photoURL) {
                    WebImage(url: url)
                        .resizable()
                    // Placeholder for loading state
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .opacity(0.3)
                        }
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                                        
                    // User Info display
                    HStack {
                        // Display user profile icon
                        if let iconURL = URL(string: photoInfo.personDetails?.userIconURL ?? "") {
                            WebImage(url: iconURL)
                                .resizable()
                                .placeholder {
                                    Circle().foregroundColor(.gray)
                                    Image(systemName: "photo")
                                        .imageScale(Image.Scale.small)
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.white)
                                }
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                                .shadow(radius: 1)
                                .onTapGesture {
                                    isActive = true
                                }
                        }
                        Text("UserID: \(photoInfo.photo.owner)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Hidden navigation link for programmatic navigation
                        NavigationLink("", destination: PhotoListView(viewModel: PhotoListViewModel(searchByUsername: photoInfo.personDetails?.userName ?? "")), isActive: $isActive)
                            .opacity(0)
                            .frame(width: 0, height: 0)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
