//
//  CustomNavLink.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 02/02/22.
//

import SwiftUI

struct CustomNavLink<Label: View, Destination: View>: View { //see doc of Navigation Link
    let destination: Destination
    let label: Label
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
            }
            .navigationBarHidden(true)
        } label: {
            label
        }

    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView {
            CustomNavLink {
                Text("Destination")
            } label: {
                Text("Navigate")
            }
        }
        

    }
}
