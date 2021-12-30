//
//  ViewModifierBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/12/21.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    let bg: Color
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(bg)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
    }
}

extension View {
    func withDefaultButtonFormatting(bgColor: Color = .blue) -> some View {
        modifier(DefaultButtonViewModifier(bg: bgColor))
    }
}

struct ViewModifierBootcamp: View {
    var body: some View {
        VStack {
            Text("Hello World!")
                .withDefaultButtonFormatting()
            
            Text("Hello Bro")
                .withDefaultButtonFormatting(bgColor: .orange)
        }
    }
}

struct ViewModifierBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ViewModifierBootcamp()
    }
}
