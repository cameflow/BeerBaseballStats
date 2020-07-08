//
//  UsersView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI
import CoreData


struct UsersView: View {
    
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UserCD.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserCD.username, ascending: true)]) var usersCD: FetchedResults<UserCD>
    
    @State var txt = ""
    @State var showAddUser = false
    
    @State var showAlert = false

    var body: some View {
        VStack {
            NavigationView {
                List {
                    searchView(txt: $txt)
                    ForEach(usersCD.filter{txt == "" ? true : $0.username!.localizedCaseInsensitiveContains(txt)}, id: \.self){ person in
                        NavigationLink(destination: UserDetail(userCD: person)){
                            HStack{
                                Image("UserLogo")
                                    .resizable()
                                    .frame(width: 70, height: 50)
                                Text(person.username ?? "Unknown Username")
                                    .font(.headline)
                                Spacer()
                                Text(person.name ?? "Unknown Name")
                                    .foregroundColor(.secondary)
                                    
                            }
                            
                        }
                    }.onDelete(perform: deleteUser)
                }.sheet(isPresented: self.$showAddUser) {
                    AddUserView().environment(\.managedObjectContext,self.moc)
                }
                .navigationBarTitle("Users", displayMode: .inline)
                .navigationBarItems(trailing: Button(action:
                    {self.showAddUser = true})
                    {
                        Image(systemName: "person.badge.plus.fill").imageScale(.large)	
                        
                })
               
            }
        }.alert(isPresented: $showAlert){
            Alert(title: Text("Can't delete user"), message: Text("User is assigned to a team, remove from team before deleting"), dismissButton: .default(Text("Ok")))}
        
        
    }
    func deleteUser(at offsets: IndexSet) {
        for offset in offsets {
            // find this user in our fetch request
            let user = usersCD[offset]
            if user.team != "0"{
                self.showAlert = true
            } else {
                // delete it from the context
                moc.delete(user)
            }

            
        }

        // save the context
        try? moc.save()

       
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}


struct searchView : UIViewRepresentable {
    
    @Binding var txt: String
    
    func makeCoordinator() -> searchView.Coordinator {
        return searchView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<searchView>) -> UISearchBar {
        let searchbar = UISearchBar()
        searchbar.barStyle = .default
        searchbar.searchBarStyle = .minimal
        searchbar.showsCancelButton = true
        searchbar.autocapitalizationType = .none
        searchbar.delegate = context.coordinator
        searchbar.endEditing(true)
        return searchbar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<searchView>) {
        //
    }
    
    class Coordinator : NSObject,UISearchBarDelegate {
        
        var parent : searchView!
        init(parent1: searchView) {
            
            parent = parent1
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.txt = searchText
            
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            searchBar.endEditing(true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
        }
    }
    
    
   

}

