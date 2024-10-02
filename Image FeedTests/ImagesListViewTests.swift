//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Богдан Топорин on 26.09.2024.
//

import XCTest
@testable import ImageFeed
class ImagesListViewControllerSpy: ImagesListViewControllerProtocol{
    var presenter: ImagesListPresenterProtocol!
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func updateTableViewAnimated() {
        
    }
    
}

class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    
    var photos: [ImageFeed.Photo] = []
    
    var didLike = false
    var didFetch = false
    
    func loadData(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) {
        
    }
    
    func getPhoto(for indexPath: IndexPath) -> ImageFeed.Photo {
        return photos[indexPath.row]
    }
    
    func getPhotoCount() -> Int {
        return photos.count
    }
    
    func toggleLike(for photoId: String, isLiked: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        didLike = !isLiked
    }
    
    func fetchPhotoNextPage() {
        didFetch = true
    }
    
    
}

final class Image_FeedTests_ImagesListTests: XCTestCase {
    
    func testControllerCreatePresenter() {
        let sut = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        sut.configure(presenter)
        
        XCTAssertNotNil(presenter)
    }
    
    func testPresenterDidToggleLike() {
        let sut = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        sut.configure(presenter)
        
        presenter.toggleLike(for: "test" , isLiked: false){_ in }
        
        XCTAssertTrue(presenter.didLike)
    }
    
    func testPresenterFetchPhoto() {
        let sut = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        sut.configure(presenter)
        
        presenter.fetchPhotoNextPage()
        
        XCTAssertTrue(presenter.didFetch)
    }
    
    
}
