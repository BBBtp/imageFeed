//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 26.09.2024.
//

import Foundation
import Kingfisher
import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func updateAvatar()
    func loadProfile()
    func didTapLogout()
    func getAvatarUrl() -> URL
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    func getAvatarUrl() -> URL {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else {preconditionFailure("[ProfilePresenter]:[getAvatarUrl]: Error get url")}
        return url
    }
    func updateAvatar() {
        let url = getAvatarUrl()
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        view?.profileImage?.kf.indicatorType = .activity
        view?.profileImage?.kf.setImage(with: url,
                                        placeholder: UIImage(named: "Stub"),
                                        options: [.processor(processor),
                                                  .cacheSerializer(FormatIndicatedCacheSerializer.png),
                                                  .transition(.fade(0.2))]) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image)")
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadProfile() {
        guard let profile = ProfileService.shared.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }
    
    func didTapLogout() {
          let alertModel = AlertModel(
              title: "Пока, пока!",
              message: "Вы точно хотите выйти?",
              firstButtonText: "Да",
              secondButtonText: "Нет",
              completion: {
                  ProfileLogoutService.shared.logout()
              },
              secondCompletion: {}
          )
          
          
          view?.showAlert(model: alertModel)
      }
}
