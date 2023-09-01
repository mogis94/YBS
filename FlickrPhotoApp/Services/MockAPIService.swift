//
//  MockAPIService.swift
//  FlickrPhotoAppTests
//
//  Created by Mogis A on 31/08/2023.
//

import Combine
import Foundation

class MockAPIService: APIService {
    
    var shouldReturnError: Bool = false
    
    // Mocked Photos
    var mockedPhotos: [Photo] = [
        Photo(id: "53153696416", title: "Jaguar XKE", owner: "49509109@N02", secret: "78acae1269", server: "65535", farm: 66, isfamily: 0, isfriend: 0, ispublic: 0),
        Photo(id: "53153123382", title: "State Theatre", owner: "74939715@N05", secret: "94f8f647c5", server: "65535", farm: 66, isfamily: 0, isfriend: 0, ispublic: 0)
    ]
    
    // Mocked Person Details
    var mockedPersonDetails: PersonDetails = {
        let mockPerson = FlickrUserResponse.Person(iconfarm: 1, iconserver: "iconserver", id: "49509109@N02", photos: .init(firstdatetaken: .init(_content: "someDate")), description: .init(_content: "description"), username: .init(_content: "John"))
        
        let mockResponse = FlickrUserResponse(person: mockPerson, stat: "ok")
        
        return PersonDetails(from: mockResponse, userID: mockPerson.id)
    }()
    
    override func fetchPhotos(tags: String, username: String?) -> AnyPublisher<[Photo], APIError> {
        if shouldReturnError {
            // Return a failure with an APIError
            return Fail(error: APIError.unknown)
                .eraseToAnyPublisher()
        } else {
            // Return successful data
            return Just(mockedPhotos)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
    
    override func fetchUserDetails(userID: String) -> AnyPublisher<PersonDetails, APIError> {
        return Just(mockedPersonDetails)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
