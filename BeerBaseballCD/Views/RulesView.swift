//
//  RulesView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 04/07/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI

struct RulesView: View {
    
    var categories:[String:[Rule]] {
        .init(grouping: rulesData, by: {$0.category.rawValue})
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories.keys.sorted(),id:\String.self) {key in
                    Section(header: Text(key.uppercased())){
                        RulesGroupView(categoryName: key.uppercased(), rules: self.categories[key]!)
                    }
                    
                }.navigationBarTitle(Text("Rules"))
            
            }.listStyle(GroupedListStyle())
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
