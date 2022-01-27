//
//  GeometryPreferenceKeyBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 27/01/22.
//

import SwiftUI

struct GeometryPreferenceKeyBootcamp: View {
    @State private var rectSize: CGSize = .zero
    var body: some View {
        VStack {
            Text("Hello world")
                .frame(width: rectSize.width, height: rectSize.height)
                .background(.blue)
            Spacer()
            HStack {
                Rectangle()
                GeometryReader{geo in
                    Rectangle()
                        .updateRectangleGeoSize(geo.size)
                }
                
                Rectangle()
            }
            .frame(height: 55)
            
        }
        .onPreferenceChange(RectangleGeometryPreferenceKey.self) { value in
            self.rectSize = value
        }
    }
}

struct GeometryPreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GeometryPreferenceKeyBootcamp()
    }
}

extension View {
    
    func updateRectangleGeoSize(_ size: CGSize) -> some View {
        preference(key: RectangleGeometryPreferenceKey.self, value: size)
    }
}

struct RectangleGeometryPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
