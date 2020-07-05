//
//  Rule.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 04/07/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import Foundation
import SwiftUI

struct Rule: Hashable, Codable, Identifiable {
    var id:Int
    var name:String
    var imageName:String
    var category:Category
    var description:String
    
    enum Category:String, CaseIterable, Codable, Hashable {
        case attack = "attack"
        case defense = "defense"
    }
}
