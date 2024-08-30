//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 15.08.2024.
//

import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
} 
