//
//  PhotoDetailView.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 27/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoDetailView: View {
    
    var photoInfo: PhotoInfo
    @State private var isActive: Bool = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    // Computed Property for Image
    private var photoImage: some View {
        WebImage(url: URL(string: photoInfo.photo.photoURL))
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 300)
            .clipped()
            .cornerRadius(10)
    }
    
    // Computed Property for Metadata HStack
    private func metadata(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 17))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 17, weight: .semibold))
        }
        .padding(.vertical, 8)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // Photo Image
                photoImage
                
                // Photo Title
                Text(photoInfo.photo.title)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.vertical, 8)
                
                // Divider
                Divider()
                
                // Metadata Section
                metadata(label: "Date Taken:", value: "\(dateFormatter.string(from: dateFormatter.date(from: photoInfo.personDetails?.dateTaken ?? "") ?? Date()))")
                navigationLinkMetadata
                
                // Optional Description
                if let description = photoInfo.personDetails?.description, !description.isEmpty {
                    descriptionSection
                }
            }
            .padding()
        }
        .accessibilityIdentifier("detailView")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var navigationLinkMetadata: some View {
        HStack {
            // Metadata
            metadata(label: "User ID:", value: String(photoInfo.photo.owner))
            
            // Navigation Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
            
            // Navigation Link
            NavigationLink(
                "",
                destination: PhotoListView(viewModel: PhotoListViewModel(searchByUsername: photoInfo.personDetails?.userName ?? "")),
                isActive: $isActive
            )
        }
        .onTapGesture { isActive = true }
    }
    
    private var descriptionSection: some View {
        if let description = photoInfo.personDetails?.description, !description.isEmpty {
            return AnyView(
                VStack(alignment: .leading) {
                    Divider()
                        .padding(.vertical, 8)
                    Text("Description")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(description)
                        .font(.body)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }

}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photoInfo: PhotoInfo(id: "id1", photo: Photo(id: "id1", title: "Image Title", owner: "Owner", secret: "secret", server: "server", farm: 0, isfamily: 0, isfriend: 0, ispublic: 1)))
    }
}
