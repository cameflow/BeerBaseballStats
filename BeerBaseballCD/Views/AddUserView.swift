//
//  AddUserView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI


struct AddUserView: View {
    
    @ObservedObject var users: Users
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: UserCD.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserCD.username, ascending: true)]) var usersCD: FetchedResults<UserCD>
    
    @State private var username = ""
    @State private var fullName = ""
    @State private var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        VStack{
            
            Text("CREATE NEW USER")
                .fontWeight(.thin)
                .padding(.top, 50)
                .font(.largeTitle)
                
            Spacer()
            
            TextField("Username", text: $username)
                .frame(width: 300, height: 50)
                .padding(.leading, 10)
                .border(Color.black, width: 5)
                .cornerRadius(10)
                
            
            TextField("Full Name", text: $fullName)
                .frame(width: 300, height: 50)
                .padding(.leading, 10)
                .border(Color.black, width: 5)
                .cornerRadius(10)
            
            Button(action: {
                //let user = User(name: self.fullName, username: self.username)
                if (self.username != "")
                {
                    if (self.fullName != "")
                    {
                        if self.uniqueUsername(users: self.usersCD, username: self.username){
                            
                            // Creating new user for Core Data
                            let newUser = UserCD(context: self.moc)
                            newUser.name = self.fullName
                            newUser.username = self.username
                            newUser.defendAttempts = 0
                            newUser.defendSuccess = 0
                            newUser.firstBase = 0
                            newUser.secondBase = 0
                            newUser.thirdBase = 0
                            newUser.fouls = 0
                            newUser.numCatchs = 0
                            newUser.numCurrentStrikes = 0
                            newUser.numRuns = 0
                            newUser.stealAttempts = 0
                            newUser.stealSuccess = 0
                            newUser.swing = 0
                            newUser.numStrikes = 0
                            newUser.team = 0

                            // Saving Created User in Core Data
                            try? self.moc.save()
                            
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.alertTitle = "Duplicate user"
                            self.alertMessage = "username already exist"
                            self.showAlert = true
                        }
                    } else {
                        self.alertTitle = "Empty name"
                        self.alertMessage = "Name can't be empty"
                        self.showAlert = true
                    }
                } else {
                    self.alertTitle = "Emtpy username"
                    self.alertMessage = "Username can't be empty"
                    self.showAlert = true
                }
                
            }) {
                Text("Create")
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray))
            }.padding(.top, 30)
            
            Spacer()
        }.alert(isPresented: $showAlert){
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton:.default(Text("OK")))
        }
        
    }
    
    
    // Function to check that the username is unique
    func uniqueUsername(users: FetchedResults<UserCD>, username: String) -> Bool
    {
        for user in users {
            if user.username?.lowercased() == username.lowercased() {
                return false
            }
        }
        return true
    }
    
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView(users: Users())
    }
}
