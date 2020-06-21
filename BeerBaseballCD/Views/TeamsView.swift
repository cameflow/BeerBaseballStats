//
//  TeamsView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 15/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct TeamsView: View {
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        NavigationView {
            List{
            Text("Team 1")
            Text("Team 2")
            }
        .navigationBarTitle("Teams", displayMode: .inline)
        .navigationBarItems(trailing: Button(action:{
            //
        }){
            Image(systemName: "plus.circle.fill").imageScale(.large)
        })
        }
        
    }
}

struct TeamsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView()
    }
}
