//
//  CustomShapesBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/12/21.
//

import SwiftUI

//point (0,0) is the TOP LEFT on iPhone
/*
 
 (minX, minY)  (midX, minY)    (maxX, minY)
 
 (minX, midY)  (midX, midY)    (maxX, midY)
 
 (minX, maxY)  (midX, maxY)    (maxX, maxY)
 
  */


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path {path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY)) //move the cursor only
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY)) //not needed(debug purpose)
        }
    }
   
    
}

struct Kite: Shape {
    func path(in rect: CGRect) -> Path {
        Path {path in
            let horizontalOffset: CGFloat = rect.width * 0.2  //width == x
            path.move(to:  CGPoint(x: rect.midX , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
                         
         
        }
    }
    
    
}


struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path{path in
            let horizontalOffset: CGFloat = rect.width * 0.2  //width == x
            let verticalOffset: CGFloat = rect.height * 0.2 //height == y
            path.move(to:  CGPoint(x: rect.minX + horizontalOffset , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + verticalOffset))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + verticalOffset))
        }
    }
    
    
}
struct CustomShapesBootcamp: View {
    var body: some View {
        ZStack{
            
//            Image("GameScreen")
//                .resizable()
//                .scaledToFit()
            //Triangle()
            //Kite()
            Diamond()
//                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10]))
           //     .trim(from: 0, to: 0.5)
                //.fill(.red)
//            Rectangle()
                .frame(width: 300, height: 300)
              //  .clipShape(Triangle().rotation(Angle(degrees: 180)))
        }
    }
}

struct CustomShapesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CustomShapesBootcamp()
    }
}
