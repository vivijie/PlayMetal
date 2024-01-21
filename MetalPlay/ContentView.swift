//
//  ContentView.swift
//  MetalPlay
//
//  Created by NEIL WANG on 2024/1/19.
//

import SwiftUI

struct ContentView: View {
    var preview = Preview()
     
    var body: some View {
        ZStack {
            Color.black
            
            preview
                .frame(width: 300, height: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
