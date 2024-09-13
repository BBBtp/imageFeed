//
//  PhotoBody.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 02.09.2024.
//

import Foundation



struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}

struct UrlsResult: Codable{
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
}

struct Photo:Codable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let regularImgUrl: String
    let fullImgUrl: String
    var isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = {
            let date = DateFormatter()
            date.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            return date.date(from: photoResult.createdAt)
        }()
        self.welcomeDescription = photoResult.description
        self.regularImgUrl = photoResult.urls.regular ?? ""
        self.fullImgUrl = photoResult.urls.full ?? ""
        self.isLiked = photoResult.likedByUser
    }
    
    init(from photo: Photo){
        self.id = photo.id
        self.size = photo.size
        self.createdAt = photo.createdAt
        self.welcomeDescription = photo.welcomeDescription
        self.regularImgUrl = photo.regularImgUrl
        self.fullImgUrl = photo.fullImgUrl
        self.isLiked = !photo.isLiked
    }
}
