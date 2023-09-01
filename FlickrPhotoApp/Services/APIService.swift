//
//  APIService.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 27/08/2023.
//

import Foundation
import Alamofire
import Combine

class APIService {
    
    private let baseURL = "https://api.flickr.com/services/rest/"
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError> {
        return Future<T, APIError> { promise in
            AF.request(self.baseURL, parameters: endpoint.parameters)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure:
                        if response.response?.statusCode == 404 {
                            promise(.failure(.httpError))
                        } else {
                            promise(.failure(.decodingError))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchPhotos(tags: String, username: String? = nil) -> AnyPublisher<[Photo], APIError> {
        return request(.fetchPhotos(tags: tags, username: username))
            .map { (response: PhotoSearchResponse) in response.photos.photo }
            .eraseToAnyPublisher()
    }
    
    func fetchUserDetails(userID: String) -> AnyPublisher<PersonDetails, APIError> {
        return request(.fetchUserDetails(userID: userID))
            .compactMap { PersonDetails(from: $0, userID: userID) }
            .eraseToAnyPublisher()
    }
}
