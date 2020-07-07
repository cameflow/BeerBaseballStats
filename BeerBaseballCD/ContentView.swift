//
//  ContentView.swift
//  BeerBaseball
//
//  Created by Alejandro Terrazas on 02/05/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UserCD.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserCD.username, ascending: true)]) var usersCD: FetchedResults<UserCD>
    
    @State var showAddUser = false
    @State var showAddOut = false
    @State var showUsers = false
    @State var coinSoundEffect: AVAudioPlayer?
    
    @State private var animationAmount = 0.0
    @State private var startingTeam = "SPIN"
    @State private var coinColor = Color.gray
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var activeGame = UserDefaults.standard.bool(forKey: "activeGame")

    @State var showAlert = false
    @State var tossCoin = false
    @State private var selection = 0
    @ObservedObject var game = Game()

    var body: some View {
        
        
        TabView(selection: $selection) {
            ZStack{
                VStack(spacing: 0) {
                    Spacer()
                    if (self.activeGame) {
                        VStack{
                            
                            Text("Score:")
                                .fontWeight(.thin)
                                .font(.largeTitle)
                            Text("\(game.teamRedPoints) - \(game.teamBluePoints)")
                                .fontWeight(.thin)
                                .font(.largeTitle)
                            Text("Red       Blue")
                                .fontWeight(.thin)
                                .font(.caption)
                            
                        }
                            
                    } else {
                        Text("Welcome!")
                            .fontWeight(.thin)
                            .font(.largeTitle)
                        Spacer()
                    }
                        Image("BeerBaseball2")
                            .resizable()
                            .frame(width: 350, height: 200)
                            .shadow(color: .gray, radius: 20)
                            .padding(.bottom, 50)
                            .padding(.top, 30)

                     
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
                                    for i in 0..<self.usersCD.count {
                                        self.usersCD[i].numCurrentStrikes = 0
                                    }
                                    self.game.clearGame()
                                    self.alertTitle = "Game Ended"
                                    if (self.game.teamRedPoints > self.game.teamBluePoints) {
                                        self.alertMessage = "TEAM RED WINS"
                                    } else if (self.game.teamBluePoints > self.game.teamRedPoints) {
                                        self.alertMessage = "TEAM BLUE WINS"
                                    } else {
                                        self.alertMessage = "GAME TIE"
                                    }
                                    
                                    self.showAlert = true
                                } else {
                                    self.alertTitle = "Game Started"
                                    self.alertMessage = "You are staring a game, have fun!"
                                    
                                    self.tossCoin = true
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
                                .cornerRadius(10)
                                .font(.headline)
                            } else {
                               Text("Start Game")
                                .fontWeight(.thin)
                                .frame(width: 250, height: 50)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .font(.headline)
                            }
                            
                        }
                        Spacer()
            }
                if self.tossCoin {
                ZStack{
                    Rectangle()
                        .frame(width: 300, height: 500, alignment: .center)
                        .opacity(0.6)
                        .cornerRadius(10)
 
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                self.tossCoin = false
                                self.showAlert = true
                            }) {
                                Image(systemName: "xmark.circle.fill").resizable().frame(width: 30, height: 30)
                            }.padding([.trailing,.top], 20.0)
                        }
                        Spacer()
                        Button(action: {
                            self.playSound()
                            withAnimation(.easeOut(duration: 2)) {
                                self.animationAmount += 1440
                                self.startingTeam = ["RED", "BLUE"].randomElement()!
                                if self.startingTeam == "RED" {
                                    self.coinColor = Color.red
                                } else {
                                    self.coinColor = Color.blue
                                }
                            }
                        }){
                            Text(startingTeam)
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .frame(width: 150, height: 150, alignment: .center)
                        }
                        .padding(50)
                        .background(self.coinColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .rotation3DEffect(.degrees(animationAmount), axis: (x: 1.0, y: 0.0, z: 0.0))
                        .onAppear(perform: {
                            self.playSound()
                            withAnimation(.easeOut(duration: 2)) {
                                self.animationAmount += 1440
                                self.startingTeam = ["RED", "BLUE"].randomElement()!
                                if self.startingTeam == "RED" {
                                    self.coinColor = Color.red
                                } else {
                                    self.coinColor = Color.blue
                                }
                            }
                            
                        })
                        Spacer()
                    }

                }.frame(width: 300, height: 500, alignment: .center)
                    
                }
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
    
     func playSound(){
        let path = Bundle.main.path(forResource: "coinsound.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            coinSoundEffect = try AVAudioPlayer(contentsOf: url)
            coinSoundEffect?.play()
        } catch {
            print("couldn't load file")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
