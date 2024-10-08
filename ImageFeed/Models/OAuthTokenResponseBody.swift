//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 14.08.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable{
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
