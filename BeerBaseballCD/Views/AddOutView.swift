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

    
    

    @Environment(\.presentationMode) var presentationMode
    @State private var showStrikeOutAlert = false
    @State private var showFoulAlert = false
    
    @State private var selectedUser = 0
    @State private var catcher = 0
    @State private var defender = 0
    
    let teams = ["RED","BLUE"]
    @State var attackingTeam = "RED"
    
    let options = ["HR", "STRIKE", "OUT", "HIT","SB"]
    @State private var option = "HR"
    
    @State private var base = 1
    let stealOptions = ["STEAL", "NO STEAL"]
    @State private var stealResult = "STEAL"
    @State private var foul = false

    
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
                                    print("HELLO")
                            }
                        } else {
                           Picker("BLUE Team", selection: $selectedUser) {
                                ForEach(0..<blueTeamArr.count) {
                                    Text(blueTeamArr[$0].username ?? "Username").tag($0)
                                }
                            }.onReceive([self.selectedUser].publisher.first()) { (value) in
                                    print("HELLO")
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
                    if (self.option == "STRIKE"){
                        Text("Current Number of Strikes: \(self.usersCD[self.selectedUser].numCurrentStrikes)")
                        Toggle("Foul", isOn: $foul)
                    }
                    
                    if (self.option == "OUT"){
                        Picker("Select Catcher", selection: $catcher) {
                            ForEach(0..<usersCD.count) {
                                if($0 != self.selectedUser) {
                                Text(self.usersCD[$0].username ?? "Username").tag($0)
                                }
                                
                            }
                        }
                    }
                    if (self.option == "SB"){
                        Picker("Select Defender", selection: $defender) {
                            ForEach(0..<usersCD.count) {
                                Text(self.usersCD[$0].username ?? "Username").tag($0)
                                
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
                        self.presentationMode.wrappedValue.dismiss()
                        print(self.attackingTeam)
                        
                    } else if (self.option == "OUT") {
                        self.usersCD[self.selectedUser].swing += 1
                        self.usersCD[self.selectedUser].numOutsByCatch += 1
                        self.usersCD[self.catcher].numCatchs += 1
                        self.usersCD[self.catcher].numCurrentStrikes = 0
                        self.presentationMode.wrappedValue.dismiss()
                    } else if (self.option == "HIT") {
                        
                        self.usersCD[self.selectedUser].swing += 1
                        self.usersCD[self.selectedUser].numHits += 1
                        self.usersCD[self.selectedUser].numCurrentStrikes = 0
                        
                        switch self.base {
                            case 0:
                                self.usersCD[self.selectedUser].firstBase += 1
                            case 1:
                                self.usersCD[self.selectedUser].secondBase += 1
                            default:
                                self.usersCD[self.selectedUser].thirdBase += 1
                            
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    } else if (self.option == "SB") {
                        self.usersCD[self.selectedUser].stealAttempts += 1
                        self.usersCD[self.defender].defendAttempts += 1
                        if self.stealResult == "STEAL" {
                            self.usersCD[self.selectedUser].stealSuccess += 1
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
        AddOutView()
    }
}
