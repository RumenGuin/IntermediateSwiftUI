//
//  ParticleView.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 27/01/22.
//

import SwiftUI

struct ParticleView: View {
    //(@State) -> we're just saying keep it alive, act as a cache so when the view is recreated (which will be on a fairly regular basis) it won't destroy the particles and recreate them.
    @State private var particleSystem = ParticleSystem()
    @State private var motionHandler = MotionManager()
    //array of tuples
    let options: [(flipX: Bool, flipY: Bool)] = [
        (false,false),
        (true, false),
        (false, true),
        (true, true)
    ]
    
    var body: some View {
        //A view that updates according to a schedule that you provide -> TimelineView
        TimelineView(.animation) {timeline in
            //A view type that supports immediate mode drawing -> Canvas
            Canvas { context, size in
                //drawing code here
                let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                particleSystem.update(date: timelineDate)
                context.blendMode = .plusDarker
               // context.addFilter(.colorMultiply(.green))
                
                particleSystem.center = UnitPoint(x: 0.5 + motionHandler.roll, y: 0.5 + motionHandler.pitch)
                
                for particle in particleSystem.particles {
                    
                    var contextCopy = context
                    contextCopy.addFilter(.colorMultiply(Color(hue: particle.hue, saturation: 1.0, brightness: 1.0)))
                    contextCopy.opacity = 1 - (timelineDate - particle.creationDate)
                    
                    for option in options {
                        
                        var xPos = particle.x * size.width
                        var yPos = particle.y * size.height
                        
                        if option.flipX {
                            xPos = size.width - xPos
                        }
                        if option.flipY {
                            yPos = size.height - yPos
                        }
                        
                        contextCopy.draw(particleSystem.image, at: CGPoint(x: xPos, y: yPos))
                    }
                  
                }
                
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged({ drag in
                    particleSystem.center.x = drag.location.x / UIScreen.main.bounds.width
                    particleSystem.center.y = drag.location.y / UIScreen.main.bounds.height
                })
        )
        .ignoresSafeArea()
        .background(.black)
    }
}

struct ParticleView_Previews: PreviewProvider {
    static var previews: some View {
        ParticleView()
    }
}
