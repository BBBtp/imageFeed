//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 30.09.2024.
//

import Foundation


struct AlertModel {
    let title: String
    let message: String
    let firstButtonText: String
    let secondButtonText: String?
    let completion: () -> Void
    let secondCompletion: (() -> Void)?
}
