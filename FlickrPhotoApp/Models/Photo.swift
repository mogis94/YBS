//
//  Photo.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 27/08/2023.
//

import Foundation

struct Photo: Decodable, Equatable {
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id // and other properties that you consider make it equatable
    }
    
    let id: String
    let title: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let isfamily: Int
    let isfriend: Int
    let ispublic: Int

    // Computed property to form the URL for the photo
    var photoURL: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    // Conform to Identifiable protocol
    var identifier: String {
        return id
    }
}

struct PhotoInfo: Identifiable, Equatable {
    static func == (lhs: PhotoInfo, rhs: PhotoInfo) -> Bool {
        return lhs.id == rhs.id && lhs.photo == rhs.photo
    }
    
    let id: String 
    let photo: Photo
    var personDetails: PersonDetails?
}
