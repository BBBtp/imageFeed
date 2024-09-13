//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 02.09.2024.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

enum ImageLikeError: Error{
    case invalidLike
}

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
    func changeLike(photoId: String, isLike: Bool,_ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = storage.token else{
            print("[ImagesListService]:[fetchPhotosNextPage]: Error get token")
            completion(.failure(ImageLikeError.invalidLike))
            return
        }
        
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        
        guard let url = URL(string: urlString) else{
            print("[ImagesListService]:[fetchPhotosNextPage] Error get URL")
            completion(.failure(ImageLikeError.invalidLike))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "DELETE" : "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.data(for:request) {
            [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    if let index = self.photos.firstIndex(where: {$0.id == photoId}){
                        
                            let photo = self.photos[index]
                            let newPhoto = Photo(from: photo )
                            
                            self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
    func clearImagesList() {
        self.photos = []
    }
}
