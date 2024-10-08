//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 30.08.2024.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        // Создаем экземпляр ImagesListViewController и передаем презентер
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else {
            fatalError("Could not instantiate ImagesListViewController")
        }
        
        let presenter = ImagesListPresenter()
        imagesListViewController.configure(presenter)
        
        imagesListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Main Active"), selectedImage: nil)
        
        // Создаем экземпляр ProfileViewController и передаем презентер
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter()
        profileViewController.configure(profilePresenter)
        
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile Active"), selectedImage: nil)
        
        // Добавляем оба контроллера во вкладки
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
