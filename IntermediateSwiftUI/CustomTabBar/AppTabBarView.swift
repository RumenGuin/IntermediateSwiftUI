//
//  AppTabBarView.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 02/02/22.
//

import SwiftUI

struct AppTabBarView: View {
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem  = .home
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            Color.purple
            // in TabBarItemsPreferenceKey file
                .tabBarItem(tab: .home, selection: $tabSelection)
              
            Color.pink
                .tabBarItem(tab: .favorites, selection: $tabSelection)
                
            
            Color.cyan
                .tabBarItem(tab: .profile, selection: $tabSelection)
            
            Color.green
                .tabBarItem(tab: .messages, selection: $tabSelection)
               
            
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppTabBarView()
    }
}
//
//extension AppTabBarView {
//    private var defaultTabView: some View {
//        TabView(selection: $selection) {
//            Color.red
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Home")
//                }
//
//            Color.blue
//                .tabItem {
//                    Image(systemName: "heart")
//                    Text("Favorites")
//                }
//
//            Color.orange
//                .tabItem {
//                    Image(systemName: "person")
//                    Text("Profile")
//                }
//        }
//    }
//}
