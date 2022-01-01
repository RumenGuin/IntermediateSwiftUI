//
//  ProtocolsBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 01/01/22.
//

//A protocol is a set of rules or requirements that a struct or class needs to have
//eg. View is a Protocol and the requirement of the View protocol that the struct has a BODY
//Protocols can inherit from other protocols
import SwiftUI


protocol ColorThemeProtocol {
    //requirements
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }
}

struct DefaultColorTheme: ColorThemeProtocol {
    let primary: Color = .blue
    let secondary: Color = .white
    let tertiary: Color = .gray
}


struct AlternatativeColorTheme: ColorThemeProtocol {
    let primary: Color = .red
    let secondary: Color = .white
    let tertiary: Color = .green
}


struct AnotherColorTheme: ColorThemeProtocol {
    var primary: Color = .blue
    var secondary: Color = .red
    var tertiary: Color = .purple
}




protocol ButtonTextProtocol {
    var buttonText: String { get }
    
}

protocol ButtonPressedProtocol {
    func buttonPressed()
}

//Protocols can inherit from other protocols
protocol ButtonDataSourceProtocol: ButtonTextProtocol, ButtonPressedProtocol {
    
}

class DefaultDataSource: ButtonDataSourceProtocol {
    var buttonText: String = "Protocals are awesome"
    
    func buttonPressed() {
        print("Button Pressed")
    }
}

class AltDataSource: ButtonTextProtocol {
  
    var buttonText: String = "Rumen Guin"
}

 
struct ProtocolsBootcamp: View {
   
    let colorTheme: ColorThemeProtocol
    let datasource: ButtonDataSourceProtocol
    
    
    var body: some View {
        ZStack {
            colorTheme.tertiary.ignoresSafeArea()
            
            Text(datasource.buttonText)
                .foregroundColor(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .cornerRadius(10)
                .onTapGesture {
                    datasource.buttonPressed()
                }
        }
    }
}

struct ProtocolsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ProtocolsBootcamp(colorTheme: DefaultColorTheme(), datasource: DefaultDataSource())
    }
}
