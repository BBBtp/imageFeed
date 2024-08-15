//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 14.08.2024.
//

import Foundation
import UIKit

final class OAuth2TokenStorage {
    
    var token: String? {
        get{
            return UserDefaults.standard.string(forKey: Constants.Token.tokenKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: Constants.Token.tokenKey)
        }
    }
}

