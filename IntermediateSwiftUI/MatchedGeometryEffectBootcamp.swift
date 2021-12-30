//
//  MatchedGeometryEffectBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/12/21.
//

import SwiftUI

struct MatchedGeometryEffectBootcamp: View {
    @State private var isClicked: Bool = false
    @Namespace private var namespace
    var body: some View {
        VStack {
            if !isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 100, height: 100)
                    
            }
            
               // .offset(y: isClicked ? UIScreen.main.bounds.height * 0.75 : 0)
            Spacer()
            if isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 300, height: 200)
                    
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isClicked.toggle()
            }
        }
    }
}

struct MatchedGeometryEffectBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometryEffectExample2()
    }
}

struct MatchedGeometryEffectExample2: View {
    let categories: [String] = ["Home", "Popular", "Saved"]
    @State private var selected: String = ""
    @Namespace private var namespace2
    var body: some View{
        HStack {
            ForEach(categories, id: \.self) {category in
                ZStack(alignment: .bottom) {
                    if selected == category {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink)
                            .matchedGeometryEffect(id: "category_bg", in: namespace2)
                            .frame(width: 40, height: 2)
                            .offset(y: 10)
                    }
                   
                    Text(category)
                        .foregroundColor(selected == category ? .pink : .black)
                        
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selected = category
                    }
                }
            }
        }
        .padding()
    }
}
