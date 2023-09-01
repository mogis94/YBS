import SwiftUI
import Combine

class PhotoListViewModel: ObservableObject {
    @Published var photosInfo: [PhotoInfo] = []
    @Published var searchText: String = ""
    @Published var searchUsernameText: String = ""
    @Published var apiError: APIError?
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    private var apiService: APIService
    
    init(apiService: APIService = APIService(), searchByUsername: String? = nil) {
        self.apiService = apiService
        if let searchByUsername = searchByUsername {
            self.searchUsernameText = searchByUsername
            self.fetchPhotos(searchTerm: nil, username: searchByUsername)
        }
    }
    
    func fetchPhotos(searchTerm: String?, username: String? = nil) {
        isLoading = true
        apiService.fetchPhotos(tags: searchTerm ?? "", username: username)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.apiError = error
                case .finished:
                    break
                }
            } receiveValue: { [weak self] photos in
                guard let self = self else { return }
                self.photosInfo = photos.map { PhotoInfo(id: $0.id, photo: $0) }
                self.getUsersProfileIcon()
            }
            .store(in: &cancellables)
    }
    
    private func getUsersProfileIcon() {
        // Initialize a set to keep track of userIDs being fetched
        var fetchingUserIDs = Set<String>()
        
        // Array to hold publishers that fetch user details
        var userDetailsPublishers = [AnyPublisher<PersonDetails, APIError>]()
        
        // Populate publishers array and fetchingUserIDs set
        for photoInfo in photosInfo {
            let userID = photoInfo.photo.owner
            guard !fetchingUserIDs.contains(userID) else { continue }
            
            fetchingUserIDs.insert(userID)
            userDetailsPublishers.append(apiService.fetchUserDetails(userID: userID))
        }
        
        // Execute the publishers and handle their results
        Publishers.MergeMany(userDetailsPublishers)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.apiError = error
                }
            } receiveValue: { [weak self] personDetails in
                guard let self = self else { return }
                
                // Find all indices with the same userID
                let matchingIndices = self.photosInfo.indices.filter {
                    self.photosInfo[$0].photo.owner == personDetails.userID
                }
                
                DispatchQueue.main.async {
                    matchingIndices.forEach { index in
                        self.photosInfo[index].personDetails = personDetails
                    }
                }
                
            }
            .store(in: &cancellables)
    }
}
