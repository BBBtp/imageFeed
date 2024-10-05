//
//  UserResultBody.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 29.08.2024.
//

import Foundation


struct UserResult: Codable{
    let profileImage: ProfileImage
    
    
}

struct ProfileImage: Codable{
    let large: String
}
