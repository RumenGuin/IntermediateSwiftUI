//
//  AppNavBarView.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 02/02/22.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                CustomNavLink {
                    Text("Destination")
                        .customNavigationTitle("Second screen")
                        .customNavigationSubtitle("SubTTTT")
                } label: {
                    Text("Navigate")
                }

            }
//            .customNavigationTitle("Custom Title")
//            .customNavigationBackButtonHidden(true)
            .customNavBarItems(title: "New Title", subtitle: "Subtitlee", backButtonHidden: true)
        }
    }
}

struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}

//extension AppNavBarView {
//    private var defaultNavView: some View {
//        NavigationView {
//            ZStack {
//                Color.green.ignoresSafeArea()
//
//                NavigationLink {
//                    Text("Destination")
//                        .navigationTitle("Title 2")
//                        .navigationBarBackButtonHidden(false)
//                } label: {
//                    Text("Navigate")
//
//                }
//
//            }
//            .navigationTitle("Nav Title Here")
//        }
//    }
//}
