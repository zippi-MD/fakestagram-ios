//
//  Comment.swift
//  fakestagram
//
//  Created by LuisE on 10/12/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let content: String
    let author: Author?
}
