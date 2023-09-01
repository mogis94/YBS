//
//  ConfigManager.swift
//  FlickrPhotoApp
//
//  Created by Mogis A on 27/08/2023.
//

import Foundation

struct ConfigManager {
    
    static let shared = ConfigManager()
    
    private init() {
        // Perform any one-time setup here
    }
    
    var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String, !apiKey.isEmpty else {
            fatalError("API_KEY not set in plist file or is empty")
        }
        return apiKey
    }
}
