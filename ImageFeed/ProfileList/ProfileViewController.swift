//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 26.07.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol! { get set }
    var profileImage: UIImageView? { get set }
    func createAllElements()
    func configure(_ presenter: ProfileViewPresenterProtocol)
    func updateProfileDetails(profile: Profile)
    func showAlert(model: AlertModel)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var profileImage: UIImageView?
    var logoutButton: UIButton?
    var nameLabel: UILabel?
    var loginLabel: UILabel?
    var descriptionLabel: UILabel?
    var presenter: ProfileViewPresenterProtocol!
    var profileImageServiceObserver: NSObjectProtocol?
    private let profileLogout = ProfileLogoutService.shared
    
    func showAlert(model: AlertModel) {
        AlertPresenter.shared.show(vc: self, model: model)
    }
    @objc
    private func didTapLogoutButton() {
        presenter.didTapLogout()
    }

    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createAllElements()
        configure(presenter)
        presenter.loadProfile()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.updateAvatar()
            }
        presenter?.updateAvatar()
    }
}

extension ProfileViewController {

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

    func createLabels() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White (iOS)")
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImage!.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP Gray (iOS)")
        loginLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)

        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World"
        descriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

        self.nameLabel = nameLabel
        self.loginLabel = loginLabel
        self.descriptionLabel = descriptionLabel
    }

    func createButton() {
        let logoutButton = UIButton.systemButton(with: UIImage(named: "Exit")!,
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
        self.logoutButton?.accessibilityIdentifier = "logout button"
    }

    func createAllElements() {
        createProfileImageView()
        createLabels()
        createButton()
    }
    func updateProfileDetails(profile: Profile) {
        self.descriptionLabel?.text = profile.bio
        self.nameLabel?.text = profile.name
        self.loginLabel?.text = profile.loginName
    }
}
