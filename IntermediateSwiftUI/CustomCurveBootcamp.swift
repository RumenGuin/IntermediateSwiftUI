//
//  CustomCurveBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/12/21.
//

import SwiftUI

struct CustomCurveBootcamp: View {
    var body: some View {
        WaterDrop()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.3),Color.teal]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .ignoresSafeArea()
           
           // .stroke(lineWidth: 5)
            //.frame(width: 200, height: 200)
    }
}

struct CustomCurveBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CustomCurveBootcamp()
    }
}

struct ArcSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path{path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 40), //positive is bottom
                        clockwise: true)
            
        }
    }
}

struct ShapeWithArc: Shape {
    func path(in rect: CGRect) -> Path {
        Path{path in
            //top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            //top right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            //mid right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            //mid bottom
           // path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), //like center of compass
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            //mid left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
        }
    }
}


struct QuadSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path{path in
            path.move(to: .zero)
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY),
                              control: CGPoint(x: rect.minX, y: rect.maxY))
           
        }
    }
}

struct WaterDrop: Shape {
    func path(in rect: CGRect) -> Path {
        Path{path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY),
                              control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.25))
            
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                              control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.75))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}
