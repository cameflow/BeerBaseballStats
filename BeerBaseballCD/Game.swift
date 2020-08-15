//
//  Game.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 25/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import Foundation

class Game: ObservableObject {
    @Published var teamRedPoints = Int() {
           didSet {
            UserDefaults.standard.set(teamRedPoints, forKey: "TeamRedPoints")
           }
       }
    @Published var teamBluePoints = Int() {
              didSet {
               UserDefaults.standard.set(teamBluePoints, forKey: "teamBluePoints")
              }
          }
    @Published var blueBases = [false,false,false] {
        didSet {
         UserDefaults.standard.set(blueBases, forKey: "blueBases")
        }
    }
    @Published var redBases = [false,false,false] {
        didSet {
         UserDefaults.standard.set(redBases, forKey: "redBases")
        }
    }

       
       init() {
        self.teamRedPoints = UserDefaults.standard.integer(forKey: "TeamRedPoints")
        self.teamBluePoints = UserDefaults.standard.integer(forKey: "teamBluePoints")
        self.blueBases = UserDefaults.standard.array(forKey: "blueBases") as? [Bool] ?? [false,false,false]
        self.redBases = UserDefaults.standard.array(forKey: "redBases") as? [Bool] ?? [false,false,false]
       }
    
    func calculateScore(move: String, base: Int, team: String){
        if move == "HIT" {
            if team == "RED"{
                self.moveBases(bases: &redBases, hb: base, score: &teamRedPoints)
            } else {
                self.moveBases(bases: &blueBases, hb: base, score: &teamBluePoints)
            }
        } else if move == "HR" {
            if team == "RED" {
                let fullBases = redBases.filter{ base in
                    base == true
                }.count
                teamRedPoints += (fullBases + 1)
                redBases = [false,false,false]
            } else {
                let fullBases = blueBases.filter{ base in
                    base == true
                }.count
                teamBluePoints += (fullBases + 1)
                blueBases = [false,false,false]
            }
        } else if move == "SB" {
            if team == "RED" {
                self.stolenBase(bases: &redBases, sb: base, score: &teamRedPoints)
            } else {
                self.stolenBase(bases: &blueBases, sb: base, score: &teamBluePoints)
            }
        }
    }
    
    func moveBases(bases: inout [Bool], hb: Int, score: inout Int) {
        //Setup the new bases
        var newbases = [false,false,false]
        var newIndex = 0

        //Start of iteration through bases
        for (index, base) in bases.enumerated() {
            // Move base if it has player
            if base {
                // Get the new index of where pushed players will go
                newIndex = index + (hb - index)
                
                // Check if player will should not move unless pushed
                if (hb-index) <= 0 {
                    newIndex = index
                }
                
                // If a player is pushed outside the array add to the score
                if newIndex > (bases.count - 1){
                    score += 1
                } else {
                    // If player is pushed inside the array
                    
                    // Check if there would be a player in the position it will be pushed
                    if newbases[newIndex] {
                        // Push it one position more
                        newIndex += 1
                        
                        // Check if new position is outside the array to add to the score
                        if newIndex > (bases.count - 1){
                            score += 1
                        } else {
                            // Set player in new position
                            newbases[newIndex] = true
                        }
                    } else {
                        //If there was no player where it was going to be pushed
                        // Set player in new position
                        newbases[newIndex] = true
                    }
                }
            }
        }
        //Put new player in his final position
        newbases[hb-1]  = true
        bases           = newbases
    }
    
    func stolenBase(bases: inout [Bool], sb: Int, score: inout Int){
        if sb == 4 {
            score += 1
        } else if (!bases[sb - 1]){
            bases[sb - 1] = true
        }
    }
    	
    func clearGame(){
        blueBases       = [false,false,false]
        redBases        = [false,false,false]
        teamBluePoints  = 0
        teamRedPoints   = 0
    }
}
