//
//  UnitTestingBootcampView.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 25/01/22.
//

/*
 1. Unit test
 - test the business logic in your app
 
 2. UI tests
 = tests the UI of your app
 */

import SwiftUI

struct UnitTestingBootcampView: View {
    @StateObject private var vm: UnitTestingBootcampViewModel
    
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingBootcampViewModel(isPremium: isPremium))
    }
    var body: some View {
        Text(vm.isPremium.description)
    }
}

struct UnitTestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTestingBootcampView(isPremium: true)
    }
}
