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
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile Active"), selectedImage: nil)
        
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
