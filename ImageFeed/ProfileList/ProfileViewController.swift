//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 26.07.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var profileImage: UIImageView?
    private var logoutButton: UIButton?
    private var nameLabel: UILabel?
    private var emailLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    @objc
    private func didTapLogoutButton() {
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        
        emailLabel?.removeFromSuperview()
        emailLabel = nil
        
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
    }
}

extension ProfileViewController{
    
    func createProfileImageView() {
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
        
        let emailLabel = UILabel()
        
        emailLabel.text = "@ekaterina_nov"
        emailLabel.textColor = UIColor(named: "YP Gray (iOS)")
        emailLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let descriptionLabel = UILabel()
        
        descriptionLabel.text = "Hello, World"
        descriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        self.nameLabel = nameLabel
        self.emailLabel = emailLabel
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
}
