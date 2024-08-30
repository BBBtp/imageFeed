//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 14.08.2024.
//

import Foundation
import UIKit

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
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
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard  let request = makeOAuthTokenRequest(code: code) else {completion(.failure(AuthServiceError.invalidRequest))
            return}
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let token):
                    completion(.success(token.access_token))
                case .failure(let error):
                    completion(.failure(error))
                    print("[OAuthService.fetchOAuthToken]: NetworkError - \(error.localizedDescription) for code: \(code)")
                }
                
                self?.lastCode = nil
                self?.task = nil
            }
            
        }
        
        task.resume()
    }
}


