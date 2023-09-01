//
//  APIError.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 30/08/2023.
//

import Foundation

enum APIError: Error {
    case decodingError
    case httpError
    case unknown
}
