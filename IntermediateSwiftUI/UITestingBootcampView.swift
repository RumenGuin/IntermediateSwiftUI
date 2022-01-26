//
//  UITestingBootcampView.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 26/01/22.
//

import SwiftUI

class UITestingBootcampViewModel: ObservableObject {
    
    let placeholdertext: String = "Add Your Name..."
    @Published var textFieldText: String = ""
    @Published var currentUserIsSignedIn: Bool = false
    
    init(currentUserIsSignedIn: Bool) {
        self.currentUserIsSignedIn = currentUserIsSignedIn
    }
    
    func signUpButtonPressed() {
        guard !textFieldText.isEmpty else {return} //if empty return(do nothing)
        currentUserIsSignedIn = true //if not empty
    }
    
}

struct UITestingBootcampView: View {
    @StateObject private var vm: UITestingBootcampViewModel
    
    init(currentUserIsSignedIn: Bool) {
        //_vm because we're referencing the stateobject
        _vm = StateObject(wrappedValue: UITestingBootcampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.brown, Color.white,Color.gray]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ZStack {
                if vm.currentUserIsSignedIn {
                    //content
                    SignedInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                }
                if !vm.currentUserIsSignedIn {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
}

struct UITestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UITestingBootcampView(currentUserIsSignedIn: true)
    }
}

extension UITestingBootcampView {
    private var signUpLayer: some View {
        VStack {
            TextField(vm.placeholdertext, text: $vm.textFieldText)
                .font(.headline)
                .padding()
                .background(Color.purple.opacity(0.3))
                .cornerRadius(10)
                .padding(.vertical,20)
                .padding(.horizontal,20)
                .accessibilityIdentifier("SignUpTextfield")
            Button {
                withAnimation {
                    vm.signUpButtonPressed()
                }
                
            } label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
            }
            .accessibilityIdentifier("SignUpButton")

        }
    }
}

struct SignedInHomeView: View {
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show Welcome Alert!")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(.red)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("ShowAlertButton")
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text("Welcome to app"))
                }

                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(.yellow)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("NavigationLinkToDestination")

            }
            .navigationTitle("Welcome")
        }
    }
}
