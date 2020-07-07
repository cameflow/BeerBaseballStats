//
//  RulesGroupView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 04/07/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct RulesGroupView: View {
    
    var categoryName:String
    var rules:[Rule]
    
    
    var body: some View {
            ForEach (self.rules) { rule  in
                NavigationLink(destination: RuleDetailView(rule: rule), label: {
                    Text(rule.name)
                })
            }
        
        
    }
}

struct RulesGroupView_Previews: PreviewProvider {
    static var previews: some View {
        RulesGroupView(categoryName: "Attack", rules: rulesData)
    }
}
