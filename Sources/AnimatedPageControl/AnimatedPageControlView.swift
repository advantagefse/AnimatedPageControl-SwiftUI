//
//  AnimatedPageControlView.swift
//
//
//  Created by AFSE on 23/8/23.
//

import SwiftUI

public struct AnimatedPageControlView: View {

    // MARK: Properties

    @ObservedObject private var viewModel: AnimatedPageControlViewModel

    private let selectedIndex: Int
    private let dotSpacing: CGFloat
    private let dotSize: CGFloat
    private let selectedColor: Color
    private let defaultColor: Color

    private let maxDisplayedDots: Int
    private let pageCount: Int

    @State private var isAppeared: Bool = false

    // MARK: Init

    public init(viewModel: AnimatedPageControlViewModel,
                selectedIndex: Int,
                pageCount: Int,
                maxDisplayedDots: Int,
                dotSpacing: CGFloat,
                dotSize: CGFloat,
                selectedColor: Color,
                defaultColor: Color) {

        self.defaultColor = defaultColor
        self.selectedColor = selectedColor
        self.dotSize = dotSize
        self.dotSpacing = dotSpacing
        self.selectedIndex = selectedIndex
        self.pageCount = pageCount
        self.maxDisplayedDots = maxDisplayedDots

        self.viewModel = viewModel
    }

    // MARK: Body

    public var body: some View {
        Group {
            HStack(spacing: dotSpacing) {
                ForEach(0...viewModel.pageCount, id: \.self) { index in
                    let selected = isSelected(index)

                    if viewModel.shouldShowIndex(index) {
                        Circle()
                            .fill(selected ? selectedColor : defaultColor)
                            .scaleEffect(selected ? 1 : scaleEffect(index))
                            .animation(.default, value: selectedIndex)
                            .frame(width: dotSize, height: dotSize)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            }
            .animation(shouldAnimate, value: viewModel.displayedRange)
            .opacity(viewModel.shouldHideIndicator ? 0 : 1)
        }
        .onAppear {
            viewModel.onAppear(maxDots: maxDisplayedDots, pageCount: pageCount)
            viewModel.updateIndex(selectedIndex)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Disable animation on appear
                isAppeared = true
            }
        }
        .onChange(of: selectedIndex) { newValue in
            viewModel.updateIndex(newValue)
        }
    }
}

// MARK: AnimatedPageControlView Extension

extension AnimatedPageControlView {

    private var shouldAnimate: Animation? {
        // Disable animation on appear
        isAppeared ? .default : Optional<Animation>.none
    }

    private func scaleEffect(_ index: Int) -> CGFloat {
        let isIndexSelectedWithStepper: ((Int) -> Bool) = { stepper in
            return (index + stepper == selectedIndex) || (index - stepper) == selectedIndex
        }

        //        if (index == viewModel.minIndex || index == viewModel.maxIndex) && selectedIndex != index {
        //            return 0.4
        //        }

        switch selectedIndex {
        case _ where isIndexSelectedWithStepper(1):
            return 1
        case _ where isIndexSelectedWithStepper(2):
            return 1
        case _ where isIndexSelectedWithStepper(3):
            return 0.8
        case _ where isIndexSelectedWithStepper(4):
            return 0.7
        case _ where isIndexSelectedWithStepper(5):
            return 0.6
        default:
            return 0.4
        }
    }

    private func isSelected(_ index: Int) -> Bool {
        if selectedIndex < 0 {
            // in case the first card is hidden
            // we want the first dot to be selected
            return selectedIndex == (index - 1)
        } else {
            return selectedIndex == index
        }
    }
}
