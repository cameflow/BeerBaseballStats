//
//  Users.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import Foundation


struct User: Identifiable, Codable, Hashable{
    let id = UUID()
    let name: String
    let username: String
    var numOutsByStrikes = 0
    var numOutsByCatch = 0
    var numRuns = 0
    var numStrikes = 0
    var numCurrentStrikes = 0
    var numCatchs = 0
    var firstBase = 0
    var secondBase = 0
    var thirdBase = 0
    var numHits = 0
    var stealAttempts = 0
    var stealSuccess = 0
    var defendAttempts = 0
    var defendSuccess = 0
    var swing = 0
    var fouls = 0
}


class Users: ObservableObject {
    @Published var users = [User]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try?
                encoder.encode(users) {
                UserDefaults.standard.set(encoded, forKey: "Users")
            }

        }
    }
    
    init() {
        if let users = UserDefaults.standard.data(forKey: "Users") {
            let decoder = JSONDecoder()
            
            if let decoded = try?
                decoder.decode([User].self, from: users) {
                self.users = decoded
                return
            }
        }
        self.users = []
    }
}
