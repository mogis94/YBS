//
//  APIEndpoint.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 30/08/2023.
//

import Foundation

enum APIEndpoint {
    case fetchPhotos(tags: String, username: String?)
    case fetchUserDetails(userID: String)
    
    var parameters: [String: Any] {
        var params = [
            "api_key": ConfigManager.shared.apiKey,
            "format": "json",
            "nojsoncallback": 1
        ] as [String : Any]
        
        switch self {
        case .fetchPhotos(let tags, let username):
            params["method"] = "flickr.photos.search"
            params["tags"] = tags
            params["tag_mode"] = "all"
            if let username = username {
                params["username"] = username
            }
        case .fetchUserDetails(let userID):
            params["method"] = "flickr.people.getInfo"
            params["user_id"] = userID
        }
        
        return params
    }
}
