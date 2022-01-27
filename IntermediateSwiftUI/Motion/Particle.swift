//
//  Particle.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 27/01/22.
//

import Foundation

struct Particle: Hashable {
    let x: Double
    let y: Double
    let creationDate = Date.now.timeIntervalSinceReferenceDate
    let hue: Double
}
