//
//  PersonDetails.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 30/08/2023.
//

import Foundation

struct PersonDetails: Equatable {
    let dateTaken: String
    let userIconURL: String
    let description: String
    let userName: String
    let userID: String
    
    init(from flickrUserResponse: FlickrUserResponse, userID: String) {
        let userName = flickrUserResponse.person.username._content
        let description = flickrUserResponse.person.description._content
        let iconFarm = flickrUserResponse.person.iconfarm
        let iconServer = flickrUserResponse.person.iconserver
        let firstDateTaken = flickrUserResponse.person.photos.firstdatetaken._content
        let iconURL = "https://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(userID).jpg"
        
        self.dateTaken = firstDateTaken
        self.userIconURL = iconURL
        self.description = description
        self.userName = userName
        self.userID = userID
    }
}

struct FlickrResponse: Decodable {
    let photo: PhotoContainer
    let stat: String
}

struct PhotoContainer: Decodable {
    let tags: TagsContainer
}

struct TagsContainer: Decodable {
    let tag: [Tag]
}

struct Tag: Decodable {
    let _content: String
}

struct PhotoTags: Decodable {
    var tags: [String]
}



