//
//  PhotoListViewModelTests.swift
//  FlickrPhotoAppTests
//
//  Created by Mogis A on 31/08/2023.
//

import XCTest
import Combine
@testable import FlickrPhotoApp

class PhotoListViewModelTests: XCTestCase {
    
    var sut: PhotoListViewModel!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        sut = PhotoListViewModel(apiService: mockAPIService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchPhotos() {
        let fetchPhotosExpectation = expectation(description: "Fetch photos")
        
        sut.fetchPhotos(searchTerm: "car")
        
        sut.$photosInfo
            .sink { photos in
                if !photos.isEmpty {
                    XCTAssertEqual(photos, self.mockAPIService.mockedPhotos.map { PhotoInfo(id: $0.id, photo: $0) })
                    fetchPhotosExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchUserDetails() {
        let fetchUserDetailsExpectation = expectation(description: "Fetch user details")
        
        sut.fetchPhotos(searchTerm: "car")
        
        sut.$photosInfo
            .sink { photos in
                if let firstPhoto = photos.first,
                   let personDetails = firstPhoto.personDetails {
                    XCTAssertEqual(personDetails, self.mockAPIService.mockedPersonDetails)
                    fetchUserDetailsExpectation.fulfill()
                    self.cancellables.first?.cancel()
                }
            }
            .store(in: &cancellables)
                    
        waitForExpectations(timeout: 5)
    }

    func testAPIError() {
        let apiErrorExpectation = expectation(description: "API Error")
        
        // Update the mock service to return an error
        mockAPIService.shouldReturnError = true
        
        sut.fetchPhotos(searchTerm: "car")
        
        sut.$apiError
            .sink { error in
                if error != nil {
                    apiErrorExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
    }
}

