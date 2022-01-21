//
//  TimerBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 21/01/22.
//
//working on simulator only everything

import SwiftUI

struct TimerBootcamp: View {
    //every 3 sec it is publishing a value
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect() //timer is a publisher (every: 1 sec-> time we want to pass for each sec)
    //current time
    /*
     @State var currentDate: Date = Date() //current date
     var dateformatter: DateFormatter {
         let formatter = DateFormatter()
         formatter.dateStyle = .medium
         formatter.timeStyle = .medium
         return formatter
     }

     */
    
    //Countdown
  //  @State var count: Int = 10
   // @State var finishedText: String? = nil
    
    //countdown to date
    /*
    @State var timeRemaining: String = ""
    let futureDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date() //adding 1 hour from now
    
    func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureDate)
        //let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        //timeRemaining = "\(hour): \(minute): \(second)"
        timeRemaining = "\(minute) minutes, \(second) seconds"
    }
    */
    
    //animation counter
    @State var count: Int = 1
    
    
        var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.mint, Color.indigo]),
                           center: .center,
                           startRadius: 5,
                           endRadius: 500)
                           .ignoresSafeArea()
            
            
//            Text(timeRemaining)
//                .font(.system(size: 100,weight: .semibold,design: .rounded))
//                .foregroundColor(.white)
//                .lineLimit(1)
//                .minimumScaleFactor(0.1)
            
//            HStack(spacing: 15) {
//                Circle()
//                    .offset(y: count == 1 ? -20 : 0)
//                Circle()
//                    .offset(y: count == 2 ? -20 : 0)
//                Circle()
//                    .offset(y: count == 3 ? -20 : 0)
//            }
//            .frame(width: 150)
//            .foregroundColor(.white)
            
            TabView(selection: $count) {
                Rectangle()
                    .foregroundColor(.red)
                    .tag(1)
                Rectangle()
                    .foregroundColor(.brown)
                    .tag(2)
                Rectangle()
                    .foregroundColor(.orange)
                    .tag(3)
                Rectangle()
                    .foregroundColor(.purple)
                    .tag(4)
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle())
            
        }
            //subscribing to publisher(timer) by using .onReceive
        .onReceive(timer) { _ in
            //currentDate = value //working on simulator
            
//            if count <= 1 {
//                finishedText = "Wow"
//            } else {
//                count -= 1
//            }
            
            //updateTimeRemaining()
            withAnimation(.default) {
                //count == 3 ? (count = 1) : (count += 1)
                count == 4 ? (count = 1) : (count += 1)
            }
            
        }
    }
}

struct TimerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TimerBootcamp()
    }
}
