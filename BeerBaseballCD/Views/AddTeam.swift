//
//  AddTeam.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 16/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

/* EXAMPLE CODE TO TEST CREATING TEAMS */
/*
struct Person: Identifiable {
    var id = UUID()
    var name: String
    var team: Int {didSet {
        // Added to show that state is being modified
        print("\(name) just changed team")
        }}
}

class Team: ObservableObject {
    @Published var persons: [Person]

    init(persons: [Person]) {
        self.persons = persons
    }
}
*/

struct AddTeam: View {
    /*
    Example Code to test creating teams
    @ObservedObject var team: Team
    */
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
                                Button(action: {
                                    if !self.activeGame {
                                        self.usersCD[p].team = "1"
                                        try? self.moc.save()
                                        self.teamRedCount += 1
                                        UserDefaults.standard.set(self.teamRedCount, forKey: "teamRedCount")
                                    }
                                    
                                }){
                                  Image(systemName: "circle")
                                    .imageScale(.large)
                                }
                               
                            } else {
                                Button(action: {
                                    if !self.activeGame {
                                        self.usersCD[p].team = "0"
                                        try? self.moc.save()
                                        self.teamRedCount -= 1
                                        UserDefaults.standard.set(self.teamRedCount, forKey: "teamRedCount")
                                    }
                                    
                                }){
                                  Image(systemName: "r.circle.fill")
                                    .imageScale(.large)
                                }
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
                                Button(action: {
                                    if !self.activeGame {
                                        self.usersCD[p].team = "2"
                                        try? self.moc.save()
                                        self.teamBlueCount += 1
                                        UserDefaults.standard.set(self.teamBlueCount, forKey: "teamBlueCount")
                                    }
                                    
                                }){
                                  Image(systemName: "circle")
                                    .imageScale(.large)
                                }
                               
                            } else {
                                Button(action: {
                                    if !self.activeGame {
                                        self.usersCD[p].team = "0"
                                        try? self.moc.save()
                                        self.teamBlueCount -= 1
                                        UserDefaults.standard.set(self.teamBlueCount, forKey: "teamBlueCount")
                                    }
                                    
                                }){
                                  Image(systemName: "b.circle.fill")
                                    .imageScale(.large)
                                }
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
                }){
                    Text("Reset Teams")
                    .frame(width: 250, height: 50)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
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
