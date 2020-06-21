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
  
    var body: some View {
         return VStack{
            Text("Select Team Red").font(.largeTitle).padding(.top)
            ScrollView {
                ForEach(usersCD.indices) { p in
                    HStack{
                        if self.usersCD[p].team != 2 {
                            Image("UserLogo")
                            .resizable()
                            .frame(width: 70, height: 50)
                            Text("\(self.usersCD[p].username ?? "Username")")
                            Spacer()
                        
                            if self.usersCD[p].team == 0{
                                Button(action: {
                                    self.usersCD[p].team = 1
                                    try? self.moc.save()
                                }){
                                  Image(systemName: "circle")
                                    .imageScale(.large)
                                }
                               
                            } else {
                                Button(action: {
                                    self.usersCD[p].team = 0
                                    try? self.moc.save()
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
                        if self.usersCD[p].team != 1 {
                            Image("UserLogo")
                            .resizable()
                            .frame(width: 70, height: 50)
                            Text("\(self.usersCD[p].username ?? "Username")")

                            Spacer()
                            
                            if self.usersCD[p].team == 0{
                                Button(action: {
                                    self.usersCD[p].team = 2
                                    try? self.moc.save()
                                }){
                                  Image(systemName: "circle")
                                    .imageScale(.large)
                                }
                               
                            } else {
                                Button(action: {
                                    self.usersCD[p].team = 0
                                    try? self.moc.save()
                                }){
                                  Image(systemName: "b.circle.fill")
                                    .imageScale(.large)
                                }
                            }
                        }
                    }.padding([.leading,.trailing])
                }
            }
            
            Button(action: {
                for i in self.usersCD {
                    i.team = 0
                }
                try? self.moc.save()
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

struct AddTeam_Previews: PreviewProvider {
    static var previews: some View {
        AddTeam()
    }
}
