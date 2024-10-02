//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 30.09.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] {get set}
    func loadData(for cell: ImagesListCell, with indexPath: IndexPath)
    func getPhoto(for indexPath: IndexPath) -> Photo
    func getPhotoCount() -> Int
    func toggleLike(for photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchPhotoNextPage()
}


final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    var photos: [Photo] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func loadData(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let photoUrl = URL(string: photo.regularImgUrl)
        cell.dateLabel.isHidden = true
        cell.likeButton.isHidden = true
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: photoUrl,
                                   placeholder: UIImage(named: "load"),
                                   options: [
                                    .cacheSerializer(FormatIndicatedCacheSerializer.png),
                                    .transition(.fade(0.2))
                                   ]
        )
        {
            result in
            switch result{
            case .success(let value):
                print("Image: \(value.image)")
                print("Cache type: \(value.cacheType)")
                print("Sourse: \(value.source)")
                
                
                cell.dateLabel.isHidden = false
                cell.likeButton.isHidden = false
                
                
                cell.dateLabel.text = photo.createdAt != nil ? (self.dateFormatter.string(from: photo.createdAt ?? Date())) : ""
                let likedImage = photo.isLiked ? UIImage(named:"Active") : UIImage(named:"No Active")
                cell.likeButton.setImage(likedImage, for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getPhoto(for indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    func getPhotoCount() -> Int {
        return photos.count
    }
    
    func toggleLike(for photoId: String, isLiked: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLiked, completion)
    }
    
    func fetchPhotoNextPage(){
        imagesListService.fetchPhotosNextPage()
    }
}
