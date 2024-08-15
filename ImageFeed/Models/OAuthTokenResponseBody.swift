//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 14.08.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable{
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Int
}
