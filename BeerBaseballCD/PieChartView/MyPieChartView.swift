//
//  MyPieChartView.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI


struct MyPieChartView: View {
    
    public var data: [Double]
    public var elements: [String]
    public var colors: [Color]
    public var title: String
    public var legend: String?
    
    var body: some View {
        ZStack{
            Rectangle().frame(width: 350, height: 250).foregroundColor(.white).cornerRadius(10).shadow(color: .gray, radius: 10)
            VStack {
            Text(self.title)
                .font(.title)
                .foregroundColor(.black)
            
            if(self.legend != nil) {
                Text(self.legend!)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            HStack{
                Spacer()
                MyPieChartRow(data: data, backgroundColor: Color.white, accentColor: colors).frame(width: 100, height: 100)
                Spacer()
                VStack(alignment: .leading, spacing: 0){
                    ForEach(0..<self.elements.count){element in
                        HStack{
                            RoundedRectangle(cornerRadius: 2.0)
                                .frame(width: 10, height: 10)
                                .foregroundColor(self.colors[element])
                            Text(self.elements[element])
                            .foregroundColor(.black)
                        }
                    }
                }
                Spacer()
            }
            
            
            }
        }.padding(.bottom)
        
        
    }
}

struct MyPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        MyPieChartView(data: [57,23], elements:["strikes","outs"],colors: [Color.red,Color.blue], title: "Title", legend: "Legend")
    }
}
