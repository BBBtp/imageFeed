//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 04.09.2024.
//

import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
