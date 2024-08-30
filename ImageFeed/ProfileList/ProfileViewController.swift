//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 26.07.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var profileImage: UIImageView?
    private var logoutButton: UIButton?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    private let storage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    @objc
    private func didTapLogoutButton() {
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        
        loginLabel?.removeFromSuperview()
        loginLabel = nil
        
        descriptionLabel?.removeFromSuperview()
        descriptionLabel = nil
        
        profileImage?.image = UIImage(systemName: "person.crop.circle.fill")
        profileImage?.tintColor = .gray
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createProfileImageView()
        createLabels()
        createButton()
        guard let profile = ProfileService.shared.profile else {return}
        updateProfileDetails(profile:profile )
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.didChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()                                 // 6
            }
        updateAvatar()                                              // 7
    }
    
    private func updateAvatar() {                                   // 8
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        self.profileImage?.kf.indicatorType = .activity
        self.profileImage?.kf.setImage(with: url,
                                       placeholder: UIImage(named: "Stub"),
                                       options: [.processor(processor),
                                                 .cacheSerializer(FormatIndicatedCacheSerializer.png),
                                        .transition(.fade(0.2))
                                       ]
        ){
            result in
            switch result{
            case .success(let value):
                print("Image: \(value.image)")
                print("Cache type: \(value.cacheType)")
                print("Sourse: \(value.source)")
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}


extension ProfileViewController{
    
    func createProfileImageView() {
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
        let profileImage = UIImage(named: "Photo")
        let profileImageView = UIImageView(image: profileImage)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        self.profileImage = profileImageView
    }
    
    func createLabels(){
        let nameLabel = UILabel()
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White (iOS)")
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        
        nameLabel.topAnchor.constraint(equalTo: profileImage!.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let loginLabel = UILabel()
        
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP Gray (iOS)")
        loginLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let descriptionLabel = UILabel()
        
        descriptionLabel.text = "Hello, World"
        descriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        self.nameLabel = nameLabel
        self.loginLabel = loginLabel
        self.descriptionLabel = descriptionLabel
    }
    
    func createButton() {
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: self,
            action: #selector(didTapLogoutButton))
        
        logoutButton.tintColor = UIColor(named: "YP Red (iOS)")
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage!.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.logoutButton = logoutButton
    }
    
    func updateProfileDetails(profile: Profile){
        self.descriptionLabel?.text = profile.bio
        self.nameLabel?.text = profile.name
        self.loginLabel?.text = profile.loginName
    }
}
