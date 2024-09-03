//
//  ProfileResultBody.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 29.08.2024.
//

import Foundation


struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    
}

struct Profile{
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from ProfileResult: ProfileResult){
        self.username = ProfileResult.username
        self.name = "\(ProfileResult.firstName) " + "\(ProfileResult.lastName)"
        self.loginName = "@\(ProfileResult.username)"
        self.bio = ProfileResult.bio
    }
}
