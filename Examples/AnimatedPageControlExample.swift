//
//  CarouselView.swift
//  
//
//  Created by AFSE on 23/8/23.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = AnimatedPageControlViewModel()
    @State private var selection: Int = 0
    private let pageCount = 16

    var body: some View {
        VStack(spacing: 60) {
            TabView(selection: $selection) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Rectangle()
                        .fill(.gray)
                        .padding(.horizontal, 20)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 150)

            AnimatedPageControlView(viewModel: viewModel,
                                    selectedIndex: selection,
                                    pageCount: pageCount,
                                    maxDisplayedDots: 7,
                                    dotSpacing: 10,
                                    dotSize: 20,
                                    selectedColor: Color.green,
                                    defaultColor: Color.gray.opacity(0.5))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
