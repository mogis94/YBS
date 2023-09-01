//
//  PhotoSearchResponse.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 30/08/2023.
//

import Foundation

struct PhotoSearchResponse: Decodable {
    let photos: PhotosContainer
}

struct PhotosContainer: Decodable {
    let photo: [Photo]
}
