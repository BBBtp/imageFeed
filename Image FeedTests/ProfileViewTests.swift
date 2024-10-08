//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Богдан Топорин on 26.09.2024.
//

import XCTest
@testable import ImageFeed
import Kingfisher


final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    
    
    var view: ProfileViewControllerProtocol?
    var didLoadProfile: Bool = false
    
    var getUrl = false
    
    func getAvatarUrl() -> URL {
        getUrl = true
        return URL(string: "test url")!
    }
    
    func updateAvatar() {
        
    }
    
    func loadProfile() {
        didLoadProfile = true
    }
    
    func didTapLogout() {
        let alertModel = AlertModel(
            title: "test",
            message: "test",
            firstButtonText: "test",
            secondButtonText: nil,
            completion: {},
            secondCompletion: {}
        )
        
        view?.showAlert(model: alertModel)
    }
    
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    
    var presenter: ProfileViewPresenterProtocol!
    var profileImage: UIImageView?
    var didCreateAllElements: Bool = false
    var avatarUpdated = false
    var didShowAlert = false
    func createAllElements() {
        didCreateAllElements = true
    }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func showAlert(model: AlertModel) {
        didShowAlert = true
    }
    
    func updateProfileDetails(profile: Profile) {
        
    }
    
    
}
final class Image_FeedTests_ProfileTests: XCTestCase {
    
    
    func testControllerConfigPresenter() {
        let sut = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        sut.configure(presenter)
        
        XCTAssertNotNil(presenter)
    }
    
    func testControllerUpdateProfileDetails() {
        let sut = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        sut.configure(presenter)
        
        presenter.loadProfile()
        
        XCTAssertTrue(presenter.didLoadProfile)
        
    }
    
    func testControllerCreateAllElements() {
        let sut = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        sut.configure(presenter)
        
        sut.createAllElements()
        
        XCTAssertTrue(sut.didCreateAllElements)
    }
    
    func testPresenterGetURL() {
        let sut = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        sut.configure(presenter)
        
        let url = presenter.getAvatarUrl()
        
        XCTAssertTrue(presenter.getUrl)
        XCTAssertEqual(url, URL(string: "test url"))
    }
    
    func testPresenterUpdateAvatarError() {
        let sut = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        let url = URL(string: "Error url")
        sut.configure(presenter)
        
        presenter.updateAvatar()
        
        XCTAssertNil(sut.profileImage)
    }
    
    func testPresenterCreateAlertLogout() {
        let sut = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        sut.configure(presenter)
        
        presenter.didTapLogout()
        
        XCTAssertTrue(sut.didShowAlert)
    }
    
}
