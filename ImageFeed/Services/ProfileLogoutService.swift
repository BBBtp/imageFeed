//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 13.09.2024.
//

import Foundation

import WebKit

final class ProfileLogoutService{
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    
    func logout() {
        storage.deleteToken()
        profileService.clearProfile()
        profileImageService.clearAvatar()
        imagesListService.clearImagesList()
        cleanCookies()
        showSplash()
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
   
}

extension ProfileLogoutService{
    func showSplash(){
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}
