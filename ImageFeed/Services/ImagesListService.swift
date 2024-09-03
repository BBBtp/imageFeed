//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 02.09.2024.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

final class ImagesListService {
    
    static let shared  = ImagesListService()
    private init() {}
    private (set) var photos: [Photo] = []
    
    private var lastLoadPage: Int?
    private var task: URLSessionTask?
    
   
    private let storage = OAuth2TokenStorage()
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        guard task == nil else{
            return
        }
        
        let nextPage = (lastLoadPage ?? 0) + 1
        
        
        guard let token = storage.token else{
            print("[ImagesListService]:[fetchPhotosNextPage]: Error get token")
            return
        }
        
        let urlString = "https://api.unsplash.com/photos?page=\(nextPage)"
        
        guard let url = URL(string: urlString) else{
            print("[ImagesListService]:[fetchPhotosNextPage] Error get URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) {
            [weak self] (result: Result<[PhotoResult],Error>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let photosResult):
                    let newPhotos = photosResult.map({Photo(from: $0)})
                    
                    DispatchQueue.main.async {
                        self?.photos.append(contentsOf: newPhotos)
                        self?.lastLoadPage = nextPage
                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    }
                case .failure(let error):
                    print("[ImagesListService]:[fetchPhotosNextPage1]: Error: \(error.localizedDescription)")
                }
            }
            self?.task = nil
        }
        task.resume()
        
    }
    
}
