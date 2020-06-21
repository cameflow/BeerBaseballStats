//
//  MyPieChartRow.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI


struct MyPieChartRow: View {
    var data: [Double]
    var backgroundColor: Color
    var accentColor: [Color]
    var slices: [PieSlice] {
        var tempSlices:[PieSlice] = []
        var lastEndDeg:Double = 0
        let maxValue = data.reduce(0, +)
        for slice in data {
            let normalized:Double = Double(slice)/Double(maxValue)
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice, normalizedValue: normalized))
        }
        return tempSlices
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(0..<self.slices.count){ i in
                    MyPieChartCell(rect: geometry.frame(in: .local), startDeg: self.slices[i].startDeg, endDeg: self.slices[i].endDeg, index: i, backgroundColor: self.backgroundColor,accentColor: self.accentColor[i])
                }
            }
        }
    }
}

struct MyPieChartRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyPieChartRow(data:[8,23], backgroundColor: Color.white, accentColor:[ Color.blue,Color.green]).frame(width: 100, height: 100)
        }
    }
}
