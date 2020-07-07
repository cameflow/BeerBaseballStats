//
//  TeamButtonView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 06/07/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct TeamButtonView: View {
    
    var teamNumber: String
    var teamName: String
    var activeGame: Bool
    var user: UserCD
    var imageName: String
    @Binding var teamCounter: Int
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Button(action: {
            if !self.activeGame {
                self.user.team = self.teamNumber
                try? self.moc.save()
                if self.teamNumber == "0" {
                    self.teamCounter -= 1
                } else {
                   self.teamCounter += 1
                }
                if self.teamName == "BLUE" {
                    UserDefaults.standard.set(self.teamCounter, forKey: "teamBlueCount")
                } else {
                    UserDefaults.standard.set(self.teamCounter, forKey: "teamRedCount")
                }
                
            }
            
        }){
            Image(systemName: self.imageName)
            .resizable()
            .frame(width: 25, height: 25)
        }
    }
}

struct TeamButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        TeamButtonView(teamNumber: "2", teamName: "BLUE", activeGame: true, user: UserCD(), imageName: "circle", teamCounter: .constant(2))
    }
}
