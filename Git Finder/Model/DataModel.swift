//
//  DataModel.swift
//  Git Finder
//
//  Created by Asif Mimi Rabbi on 2/11/21.
//

import Foundation

struct Movie: Codable {
    let results : [Results]

}

struct Results : Codable {
    let originalTitle : String?
    let backdropPath : String?
    let overview : String?
}

