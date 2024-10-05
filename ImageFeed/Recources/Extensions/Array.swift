//
//  Array.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 04.09.2024.
//

import Foundation

extension Array {
    mutating func withReplaced(itemAt index: Int, newValue: Element) -> [Element]{
        
        if index >= 0 && index < self.count{
            self[index] = newValue
        }
        return self
    }
}
