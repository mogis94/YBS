//
//  FlickrUserResponse.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 30/08/2023.
//

import Foundation

struct FlickrUserResponse: Decodable {
    var person: Person
    let stat: String
    
    struct Person: Decodable {
        let iconfarm: Int
        let iconserver: String
        let id: String
        let photos: Photos
        let description: Content
        let username: Content
        
        struct Photos: Decodable {
            let firstdatetaken: ContentWrapper
            
            struct ContentWrapper: Decodable {
                let _content: String
            }
        }
    }
    
    struct Content: Decodable {
        let _content: String
    }
}
