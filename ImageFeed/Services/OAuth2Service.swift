//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 14.08.2024.
//

import Foundation
import UIKit


final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        
        guard var urlComponents = URLComponents(string: Constants.Token.baseAuthUrl)
        else{
            preconditionFailure("Сouldn't get the final url ❌")
            
        }
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: Constants.Auth.accessKey),
                                    URLQueryItem(name: "client_secret", value: Constants.Auth.secretKey),
                                    URLQueryItem(name: "redirect_uri", value: Constants.Auth.redirectURI),
                                    URLQueryItem(name: "code", value: code),
                                    URLQueryItem(name: "grant_type", value: Constants.Auth.grant_type)
        ]
        
        
        guard let url = urlComponents.url else{
            preconditionFailure("Error get url ❌")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do{
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(tokenResponse.access_token))
                }
                catch{
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


