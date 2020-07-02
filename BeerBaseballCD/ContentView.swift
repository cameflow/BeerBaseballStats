//
//  ContentView.swift
//  BeerBaseball
//
//  Created by Alejandro Terrazas on 02/05/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var users = Users()
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UserCD.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserCD.username, ascending: true)]) var usersCD: FetchedResults<UserCD>
    
    @State var showAddUser = false
    @State var showAddOut = false
    @State var showUsers = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var activeGame = UserDefaults.standard.bool(forKey: "activeGame")
    /*
    @State private var teamRedCount = UserDefaults.standard.integer(forKey: "teamRedCount")
    @State private var teamBlueCount = UserDefaults.standard.integer(forKey: "teamBlueCount")
    */
    @State var showAlert = false
    @State private var selection = 0
    
    @ObservedObject var game = Game()

    var body: some View {
        
        
        TabView(selection: $selection) {
                VStack(spacing: 0) {
                    Spacer()
                    VStack{
                        Text("Score:")
                            .font(.largeTitle)
                        Text("\(game.teamRedPoints) - \(game.teamBluePoints)")
                            .font(.largeTitle)
                        Text("Red       Blue").font(.caption)
                    }
                    
                    Spacer()
                        Image("BeerBaseball2")
                            .resizable()
                            .frame(width: 350, height: 200)
                            .shadow(color: .gray, radius: 20)
                            .padding(.bottom, 20)

                     
                        if (self.activeGame){
                            ButtonView(text: "Add Play", showView: $showAddOut)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $showAddOut) {
                                AddOutView(game: self.game).environment(\.managedObjectContext,self.moc)
                            }
                        }
                        
                     
                        Button(action: {
                           let teamRedCount = UserDefaults.standard.integer(forKey: "teamRedCount")
                           let teamBlueCount = UserDefaults.standard.integer(forKey: "teamBlueCount")
                            if teamBlueCount > 0 && teamRedCount > 0{
                                if self.activeGame{
                                    for i in 0..<self.users.users.count {
                                        self.users.users[i].numCurrentStrikes = 0	
                                    }
                                    self.game.clearGame()
                                    self.alertTitle = "Game Ended"
                                    self.alertMessage = "You have finished the game"
                                    self.showAlert = true
                                } else {
                                    self.alertTitle = "Game Started"
                                    self.alertMessage = "You are staring a game, have fun!"
                                    self.showAlert = true
                                }
                                self.activeGame.toggle()
                                UserDefaults.standard.set(self.activeGame, forKey: "activeGame")
                            } else {
                                self.alertTitle = "Create teams"
                                self.alertMessage = "Both teams need to have at least one player"
                                self.showAlert = true
                            }
                            
                        }){
                            if (self.activeGame){
                                Text("Stop Game")
                                    .fontWeight(.thin)
                                .frame(width: 250, height: 50)
                                .background(Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .font(.headline)
                            } else {
                               Text("Start Game")
                                .frame(width: 250, height: 50)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .font(.headline)
                            }
                            
                        }
                        
                        
                        
                        Spacer()
                    }.alert(isPresented: $showAlert){
                        Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("Ok")))
                        
                }.tabItem {
                VStack {
                    Image(systemName: "sportscourt")
                    Text("Game")
                }
            }.tag(0)
            
            VStack{
                UsersView().environment(\.managedObjectContext,self.moc)
                
            }.tabItem {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Users")
                }
            }.tag(1)
            
            VStack{
                AddTeam().environment(\.managedObjectContext,self.moc)
            }.tabItem {
                VStack {
                    Image(systemName: "person.3.fill")
                    Text("Teams")
                }
            }.tag(2)
            
            VStack{
                RulesView()
            }.tabItem {
                VStack {
                    Image(systemName: "book.fill")
                    Text("Rules")
                }
            }.tag(3)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
