//
//  UserDetail.swift
//  BeerBaseballCD
//
//  Created by Alejandro Terrazas on 07/06/20.
//  Copyright © 2020 Alejandro Terrazas. All rights reserved.
//

import SwiftUI
import CoreData


struct UserDetail: View {
    
    let userCD: UserCD
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack{
                    Text("\(userCD.name ?? "Unknown name")")
                        .font(.largeTitle)
                    VStack<MyPieChartView>{
                        let percentage = (Double(userCD.numHits)+Double(userCD.numRuns)) / Double(userCD.swing) * 100
                        let stringPercentage = String(format: "%.1f", percentage)
                        return MyPieChartView(data: [Double(userCD.numHits),Double(userCD.numRuns),Double(userCD.numStrikes),Double(userCD.fouls),Double(userCD.numOutsByCatch)], elements: ["Hit \(userCD.numHits)","HR \(userCD.numRuns)","Strike \(userCD.numStrikes)","Fouls \(userCD.fouls)","Outs \(userCD.numOutsByCatch)"], colors: [Color.blue,Color.green, Color.red,Color.orange, Color.gray], title: "Batting: \(percentage >= 0 ? stringPercentage + " %" : "No throws")", legend: "# Throws \(userCD.swing)")
                    }
                    VStack{
                        MyPieChartView(data: [Double(userCD.firstBase),Double(userCD.secondBase),Double(userCD.thirdBase)], elements: ["First Bse: \(userCD.firstBase)","Second Base: \(userCD.secondBase)","Thrid Base: \(userCD.thirdBase)"], colors: [Color.blue, Color.orange, Color.gray], title: "Bases %",legend: "# Hits: \(userCD.firstBase + userCD.secondBase + userCD.thirdBase)")
                        
                        MyPieChartView(data: [Double(userCD.numOutsByCatch),Double(userCD.numOutsByStrikes)], elements: ["Outs By Catch: \(userCD.numOutsByCatch)","Outs by Strike: \(userCD.numOutsByStrikes)"], colors: [Color.blue, Color.orange], title: "Outs %",legend: "Outs: \(userCD.numOutsByCatch + userCD.numOutsByStrikes)")
                        
                        MyPieChartView(data: [Double(userCD.stealSuccess),Double(userCD.stealAttempts - userCD.stealSuccess)], elements: ["Steals Won \(userCD.stealSuccess)","Steals lost\(userCD.stealAttempts - userCD.stealSuccess)"], colors: [Color.blue, Color.orange], title: "Base Steal %",legend: "# Steal attempts \(userCD.stealAttempts)")
                        
                        MyPieChartView(data: [Double(userCD.defendSuccess),Double(userCD.defendAttempts - userCD.defendSuccess)], elements: ["Defends Won \(userCD.defendSuccess)","Defends lost \(userCD.defendAttempts - userCD.defendSuccess)"], colors: [Color.blue, Color.orange], title: "Base Defend %",legend: "# Base defends \(userCD.defendAttempts)")
                    }
                    
                }
                VStack {
                
                    Text("# of Outs Made: \(userCD.numCatchs)")
                        .padding(.bottom)
    
                }
                
            }
        }
        .navigationBarTitle(userCD.username ?? "Unknown username")
    }
}

struct UserDetail_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let newUser = UserCD(context: self.moc)
        newUser.name = "cameflow"
        newUser.username = "Alejandro Terraas"
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
        return UserDetail(userCD: newUser)
    }
}
