//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 15.08.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private var screenImageView: UIImageView?
    private let storage = OAuth2TokenStorage()
    
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreenSegueIdentifier"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            guard let token = storage.token else {return}
            fetchProfile(token: token)
            
        } else {
            guard let navigationController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthNavigationController") as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                print("[SplashViewController]: Error to create for AuthViewController")
                return
            }
            
            viewController.delegate = self
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
}

extension SplashViewController{
    
    
    
    func showBarController(){
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
    }
}

extension SplashViewController:AuthViewControllerDelegate{
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.token else{
            return
        }
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String){
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) {
            [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else {return}
            switch result{
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(token: token,username: profile.username) {_ in}
                self.showBarController()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}

extension SplashViewController {
    func createView() {
        let screenImage = UIImage(named: "Vector")
        
        let screenImageView = UIImageView(image: screenImage)
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        view.addSubview(screenImageView)
        screenImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenImageView.widthAnchor.constraint(equalToConstant: 72),
            screenImageView.heightAnchor.constraint(equalToConstant: 76),
            screenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            screenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        self.screenImageView = screenImageView
    }
}
