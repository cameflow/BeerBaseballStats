//
//  AddOutView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct AddOutView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: UserCD.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserCD.username, ascending: true)]) var usersCD: FetchedResults<UserCD>
    
    var game:Game

    @Environment(\.presentationMode) var presentationMode
    @State private var showStrikeOutAlert = false
    @State private var showFoulAlert = false
    
    @State private var selectedUser = 0
    @State private var catcher = 0
    @State private var defender = 0
    
    @State private var selectedUser_un = "NONE"
    @State private var selectedCatcher_un = "NONE"
    @State private var selectedDefender_un = "NONE"
    
    
    let teams = ["RED","BLUE"]
    @State var attackingTeam = "RED"
    
    let options = ["HR", "STRIKE", "OUT", "HIT","SB"]
    @State private var option = "HR"
    
    @State private var base = 1
    @State private var stealBase = 1
    let stealOptions = ["STEAL", "NO STEAL"]
    @State private var stealResult = "STEAL"
    @State private var foul = false
    @State private var stealOut = false

    
    var body: some View {
        
        let redTeamArr = Array(usersCD).filter {$0.team == "1"}
        let blueTeamArr = Array(usersCD).filter {$0.team == "2"}
        
            return NavigationView {
                Form {
                    
                    Section(header: Text("Attacking Team")){
                        Picker("",selection: $attackingTeam) {
                            ForEach(teams,  id: \.self) {i in
                                Text(i)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        
                    }
                    Section(header: Text("Select Batter")){
                        if(self.attackingTeam == "RED"){
                            Picker("RED Team", selection: $selectedUser) {
                                ForEach(0..<redTeamArr.count) {
                                    Text(redTeamArr[$0].username ?? "Username").tag($0)
                                }
                            }.onReceive([self.selectedUser].publisher.first()) { (value) in
                                var index = 0
                                if value >= redTeamArr.count {
                                    index = 0
                                    self.selectedUser = 0
                                } else {
                                    index = value
                                }
                                self.selectedUser_un = redTeamArr[index].username!
                            }
                        } else {
                           
                           Picker("BLUE Team", selection: $selectedUser) {
                                ForEach(0..<blueTeamArr.count) {
                                    Text(blueTeamArr[$0].username ?? "Username").tag($0)
                                }
                            }.onReceive([self.selectedUser].publisher.first()) { (value) in
                                var index = 0
                                if value >= blueTeamArr.count {
                                    index = 0
                                    self.selectedUser = 0
                                } else {
                                    index = value
                                }
                                self.selectedUser_un = blueTeamArr[index].username!
                            }
                        }
                    }
                    
                    
                    Section(header: Text("Select move")){
                        Picker("",selection: $option) {
                            ForEach(options, id: \.self) {op in
                                Text(op)
                                
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    if (self.option == "HIT")
                    {
                        Section(header: Text("Select Base")){
                            Picker("Select Base", selection: $base) {
                                ForEach(1..<4) {
                                    Text("\($0)")
                                    
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    if (self.option == "STRIKE") {
                        Text("Current Number of Strikes: \(self.usersCD[self.selectedUser].numCurrentStrikes)")
                        Toggle("Foul", isOn: $foul)
                    }
                    
                    if (self.option == "OUT") {
                        Toggle("Out by Steal", isOn: $stealOut)
                        if (!stealOut) {
                            if(self.attackingTeam == "RED"){
                                Picker("BLUE Team", selection: $catcher) {
                                    ForEach(0..<blueTeamArr.count) {
                                        Text(blueTeamArr[$0].username ?? "Username").tag($0)
                                    }
                                }.onReceive([self.catcher].publisher.first()) { (value) in
                                    var index = 0
                                    if value >= blueTeamArr.count {
                                        index = 0
                                        self.catcher = 0
                                    } else {
                                        index = value
                                    }
                                    self.selectedCatcher_un = blueTeamArr[index].username!
                                }
                            } else {
                                Picker("RED Team", selection: $catcher) {
                                    ForEach(0..<redTeamArr.count) {
                                        Text(redTeamArr[$0].username ?? "Username").tag($0)
                                    }
                                }.onReceive([self.catcher].publisher.first()) { (value) in
                                    var index = 0
                                    if value >= redTeamArr.count {
                                        index = 0
                                        self.catcher = 0
                                    } else {
                                        index = value
                                    }
                                    self.selectedCatcher_un = redTeamArr[index].username!
                                }
                            }
                        }
                        

                    }
                    if (self.option == "SB") {
                        
                        Section(header: Text("Select Stolen Base")){
                            Picker("Select Base", selection: $stealBase) {
                                ForEach(2..<5) {
                                    Text("\($0)")
                                    
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        
                        if(self.attackingTeam == "RED"){
                            Picker("BLUE Team", selection: $defender) {
                                ForEach(0..<blueTeamArr.count) {
                                    Text(blueTeamArr[$0].username ?? "Username").tag($0)
                                }
                            }.onReceive([self.defender].publisher.first()) { (value) in
                                var index = 0
                                if value >= blueTeamArr.count {
                                    index = 0
                                    self.defender = 0
                                } else {
                                    index = value
                                }
                                self.selectedDefender_un = blueTeamArr[index].username!
                            }
                        } else {
                            Picker("RED Team", selection: $defender) {
                                ForEach(0..<redTeamArr.count) {
                                    Text(redTeamArr[$0].username ?? "Username").tag($0)
                                }
                            }.onReceive([self.defender].publisher.first()) { (value) in
                                var index = 0
                                if value >= redTeamArr.count {
                                    index = 0
                                    self.defender = 0
                                } else {
                                    index = value
                                }
                                self.selectedDefender_un = redTeamArr[index].username!
                            }
                        }

                        Picker("", selection: $stealResult) {
                            ForEach(stealOptions, id: \.self) {op in
                                    Text(op)
                                    
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        
                    }
                }
                    
                
            .navigationBarTitle("Add Play")
                    .alert(isPresented: $showStrikeOutAlert){
                            Alert(title: Text("Strike Out"), message: Text("You made 3 strikes"), dismissButton:Alert.Button.default(
                                Text("OK"), action: { self.presentationMode.wrappedValue.dismiss() }
                            ))
                    }
                .alert(isPresented: $showFoulAlert){
                    Alert(title: Text("Invalid Foul"), message: Text("You need 2 strikes before making a foul"), dismissButton: .default(Text("OK")))
                }
                .navigationBarItems(trailing: Button("Add"){
                    
                    var count = 0
                    for user in self.usersCD {
                        if user.username! == self.selectedUser_un {
                            self.selectedUser = count
                            break
                        }
                        count += 1
                    }
                    count = 0
                    for user in self.usersCD {
                        if user.username! == self.selectedCatcher_un {
                            self.catcher = count
                            break
                        }
                        count += 1
                    }
                    count = 0
                    for user in self.usersCD {
                        if user.username! == self.selectedDefender_un {
                            self.defender = count
                            break
                        }
                        count += 1
                    }
                    
                    if self.option == "STRIKE" {
                        
                        self.usersCD[self.selectedUser].swing += 1
                        if (self.foul == false) {
                            self.usersCD[self.selectedUser].numStrikes += 1
                            self.usersCD[self.selectedUser].numCurrentStrikes += 1
                            if (self.usersCD[self.selectedUser].numCurrentStrikes == 3) {
                                
                                self.usersCD[self.selectedUser].numOutsByStrikes += 1
                                self.usersCD[self.selectedUser].numCurrentStrikes = 0
                                self.showStrikeOutAlert = true
                            }
                            
                            if(self.showStrikeOutAlert == false) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            if (self.usersCD[self.selectedUser].numCurrentStrikes == 2)
                            {
                                self.usersCD[self.selectedUser].fouls += 1
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                self.showFoulAlert = true
                            }
                            
                        }
                        
                        
                        
                    } else if (self.option == "HR") {
                        
                        self.usersCD[self.selectedUser].swing += 1
                        self.usersCD[self.selectedUser].numRuns += 1
                        self.usersCD[self.selectedUser].numCurrentStrikes = 0
                        self.game.calculateScore(move: "HR", base: 0, team: self.attackingTeam)
                        
                        self.presentationMode.wrappedValue.dismiss()
                        
                    } else if (self.option == "OUT") {
                        
                        if(self.stealOut) {
                            self.usersCD[self.selectedUser].stealAttempts += 1
                            self.usersCD[self.selectedUser].numOutsBySteal += 1
                        } else {
                            self.usersCD[self.selectedUser].swing += 1
                            self.usersCD[self.selectedUser].numOutsByCatch += 1
                            self.usersCD[self.catcher].numCatchs += 1
                            self.usersCD[self.catcher].numCurrentStrikes = 0
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                        	
                    } else if (self.option == "HIT") {
                        
                        self.usersCD[self.selectedUser].swing += 1
                        self.usersCD[self.selectedUser].numHits += 1
                        self.usersCD[self.selectedUser].numCurrentStrikes = 0
                        
                        switch self.base {
                            case 0:
                                self.usersCD[self.selectedUser].firstBase += 1
                                self.game.calculateScore(move: "HIT", base: 1, team: self.attackingTeam)
                            case 1:
                                self.usersCD[self.selectedUser].secondBase += 1
                                self.game.calculateScore(move: "HIT", base: 2, team: self.attackingTeam)
                            default:
                                self.usersCD[self.selectedUser].thirdBase += 1
                                self.game.calculateScore(move: "HIT", base: 3, team: self.attackingTeam)
                            
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        
                    } else if (self.option == "SB") {
                        
                        self.usersCD[self.selectedUser].stealAttempts += 1
                        self.usersCD[self.defender].defendAttempts += 1
                        if self.stealResult == "STEAL" {
                            self.usersCD[self.selectedUser].stealSuccess += 1
                            self.game.calculateScore(move: "SB", base: self.stealBase+2, team: self.attackingTeam)
                        } else {
                            self.usersCD[self.defender].defendSuccess += 1
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    try? self.moc.save()
                    
                })
                
            }
    }
}

struct AddOutView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = Game()
        return AddOutView(game: game)
    }
}
