//
//  APIServiceTests.swift
//  FlickrPhotoAppTests
//
//  Created by Mogis A on 31/08/2023.
//

import XCTest
import Combine
@testable import FlickrPhotoApp

class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        apiService = APIService()
        cancellables = []
    }

    override func tearDown() {
        apiService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchPhotos() {
        let expectation = self.expectation(description: "Fetch photos succeeds")
        
        apiService.fetchPhotos(tags: "testTag")
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Failed with error \(error)")
                }
            } receiveValue: { photos in
                XCTAssertFalse(photos.isEmpty, "No photos received")
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
    }

    func testFetchUserDetails() {
        let expectation = self.expectation(description: "Fetch user details succeeds")

        apiService.fetchUserDetails(userID: "49509109@N02")
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Failed with error \(error)")
                }
            } receiveValue: { userDetails in
                XCTAssertNotNil(userDetails, "No user details received")
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
    }
}
