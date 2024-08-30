//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 14.08.2024.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    var token: String? {
        get{
            return KeychainWrapper.standard.string(forKey: Constants.Token.tokenKey)
        }
        set{
            KeychainWrapper.standard.set(newValue ?? " ", forKey: Constants.Token.tokenKey)
        }
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: Constants.Token.tokenKey)
        
        }
}

