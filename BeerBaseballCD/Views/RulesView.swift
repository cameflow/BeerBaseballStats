//
//  RulesView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 15/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        VStack{
            Text("Rules")
                .font(.title)
                .padding(.bottom)
            Text("This are all the instructions of the game \n lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolemlorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem \n lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem lorem ipsum dolem ")
                .font(.body)
            
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
