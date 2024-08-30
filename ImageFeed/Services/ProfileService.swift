//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 29.08.2024.
//

import Foundation
import UIKit

enum GetInfoError: Error {
    case invalidRequest
}

final class ProfileService {
    
    static let shared = ProfileService()
    private init(){}
    
    private var lastToken: String?
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    func createGetRequest(token:String)-> URLRequest?{
        guard let url = URL(string: "https://api.unsplash.com/me")
        else { preconditionFailure("Error get url!")}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        
        guard lastToken != token else {
            completion(.failure(GetInfoError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        lastToken = token
        
        guard let request = createGetRequest(token: token)
        else{
            completion(.failure(GetInfoError.invalidRequest))
            return
        }
        
        let task  = URLSession.shared.objectTask(for: request){
            [weak self] (result: Result<ProfileResult,Error>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let profileResult):
                    let profile = Profile(from: profileResult)
                    self?.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                    print("[ProfileService.fetchProfile]: NetworkError - \(error.localizedDescription) for token: \(token)")
                }
                self?.lastToken = nil
                self?.task = nil
            }
        }
        
        task.resume()
    }
    
}
