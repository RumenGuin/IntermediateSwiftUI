//
//  UIViewRepresentableBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 05/02/22.
//

import SwiftUI

// Convert a UIView from UIKit to SwiftUI
struct UIViewRepresentableBootcamp: View {
    @State private var text: String = ""
    var body: some View {
        VStack {
            Text(text)
            
            HStack {
                Text("SwiftUI: ")
                TextField("Type Here...", text: $text)
                    .frame(height: 55)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding()
            HStack {
                Text("UIKit:     ")
                UITextFieldViewRepresentable(text: $text)
                    .updatePlaceholder("New Placeholder")
                    .frame(height: 55)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding()
            
            
        }
    }
}

struct UIViewRepresentableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        UIViewRepresentableBootcamp()
    }
}

struct UITextFieldViewRepresentable: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    let placeholderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "Default Placeholder...", placeholderColor: UIColor = .green) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = getTextField()
        textfield.delegate = context.coordinator
        return textfield
    }
    
    //send data from SwiftUI to UIKit -> updateUIView
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    private func getTextField() -> UITextField {
        let textfield = UITextField(frame: .zero)
        let placeholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor
            ])
        textfield.attributedPlaceholder = placeholder
        //textfield.delegate
        return textfield
    }
    
    func updatePlaceholder(_ text: String) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    //Creates the custom instance that you use to communicate changes from your view to other parts of your SwiftUI interface. -> makeCoordinator
    //send data from UIKit to SwiftUI -> makeCoordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            self._text = text
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

struct BasicUIViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
