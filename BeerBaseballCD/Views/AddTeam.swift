//
//  AddTeam.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 16/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct AddTeam: View {

    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: UserCD.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserCD.team, ascending: false)]) var usersCD: FetchedResults<UserCD>
    
    @State private var teamRedCount = UserDefaults.standard.integer(forKey: "teamRedCount")
    @State private var teamBlueCount = UserDefaults.standard.integer(forKey: "teamBlueCount")
    @State private var activeGame = UserDefaults.standard.bool(forKey: "activeGame")
  
    var body: some View {
         return VStack{
            Text("Select Team Red").font(.largeTitle).padding(.top)
            ScrollView {
                ForEach(usersCD.indices) { p in
                    HStack{
                        if self.usersCD[p].team != "2" {
                            Image("UserLogo")
                            .resizable()
                            .frame(width: 70, height: 50)
                            Text("\(self.usersCD[p].username ?? "Username")")
                            Spacer()
                        
                            if self.usersCD[p].team == "0"{
                                TeamButtonView(teamNumber: "1", teamName: "RED", activeGame: self.activeGame, user: self.usersCD[p], imageName: "circle", teamCounter: self.$teamRedCount).environment(\.managedObjectContext,self.moc)
                               
                            } else {
                                TeamButtonView(teamNumber: "0", teamName: "RED", activeGame: self.activeGame, user: self.usersCD[p], imageName: "r.circle.fill", teamCounter: self.$teamRedCount).environment(\.managedObjectContext,self.moc)
                            }
                        }
                    }.padding([.leading,.trailing])
                }
            }
            Text("Select Team Blue").font(.largeTitle)
            ScrollView {
                ForEach(usersCD.indices) { p in
                    
                    HStack{
                        if self.usersCD[p].team != "1" {
                            Image("UserLogo")
                            .resizable()
                            .frame(width: 70, height: 50)
                            Text("\(self.usersCD[p].username ?? "Username")")

                            Spacer()
                            
                            if self.usersCD[p].team == "0"{

                                TeamButtonView(teamNumber: "2", teamName: "BLUE", activeGame: self.activeGame, user: self.usersCD[p], imageName: "circle", teamCounter: self.$teamBlueCount).environment(\.managedObjectContext,self.moc)
                               
                            } else {

                                TeamButtonView(teamNumber: "0", teamName: "BLUE", activeGame: self.activeGame, user: self.usersCD[p], imageName: "b.circle.fill", teamCounter: self.$teamBlueCount).environment(\.managedObjectContext,self.moc)
                            }
                        }
                    }.padding([.leading,.trailing])
                }
            }
            
            if !activeGame {
                Button(action: {
                    for i in self.usersCD {
                        i.team = "0"
                    }
                    try? self.moc.save()
                    UserDefaults.standard.set(0, forKey: "teamRedCount")
                    UserDefaults.standard.set(0, forKey: "teamBlueCount")
                    self.teamRedCount = 0
                    self.teamBlueCount = 0
                }){
                    Text("Reset Teams")
                    .fontWeight(.thin)
                    .frame(width: 250, height: 50)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .font(.headline)
                }.padding(.bottom)
            }
            
            
        }
    }
}

struct AddTeam_Previews: PreviewProvider {
    static var previews: some View {
        AddTeam()
    }
}
