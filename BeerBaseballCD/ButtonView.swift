//
//  ButtonView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI


struct ButtonView: View {
    
    var text:String
    @Binding var showView:Bool
    
    var body: some View {
        Button(action:{
            self.showView = true
        }) {
            Text(text)
            .fontWeight(.thin)
            .frame(width: 300, height: 70)
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .font(.largeTitle)
            
        }
        
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Add User", showView: Binding.constant(true))
    }
}
