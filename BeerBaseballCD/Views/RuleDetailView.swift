//
//  RuleDetailView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 04/07/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct RuleDetailView: View {
    
    var rule:Rule
    
    var body: some View {
        VStack{
            Text(rule.name).font(.largeTitle)
            Spacer()
            Text(rule.description).font(.title)
            Spacer()
        }
        
    }
}

struct RuleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RuleDetailView(rule: rulesData[1])
    }
}
