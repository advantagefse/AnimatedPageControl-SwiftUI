//
//  AnimatedPageControlViewModel.swift
//  
//
//  Created by AFSE on 23/8/23.
//

import Foundation

public class AnimatedPageControlViewModel: ObservableObject {

    enum Direction: String {
        case left, right, none
    }

    // MARK: Properties

    @Published private(set) var displayedRange = [Int]()

    private var direction: Direction = .none
    private var currentIndex: Int = 0
    private var rangeTrack = [Int]()
    private var stepper: Int = 0
    private(set) var minIndex: Int = 0
    private(set) var maxIndex: Int = 0

    private var maxDots: Int = 0
    private(set) var pageCount: Int = 0

    var shouldHideIndicator: Bool {
        pageCount < 2
    }

    // MARK: Init

    public init() {}

    // MARK: Public methods

    func onAppear(maxDots: Int, pageCount: Int) {
        self.maxDots = maxDots
        self.pageCount = pageCount

        createTrack()
    }

    func shouldShowIndex(_ index: Int) -> Bool {
        if pageCount < 1 { return false }
        return displayedRange.contains(index)
    }

    func updateIndex(_ index: Int) {
        self.direction = index > currentIndex ? .right : .left
        self.currentIndex = index
        updateTrack()
    }

    // MARK: Private methods

    private func createTrack() {
        guard rangeTrack.isEmpty else { return }
        rangeTrack = Array(0..<pageCount)
    }

    private func updateTrack() {
        if direction == .right {
            if maxIndex == currentIndex {
                if lastPageIndex == currentIndex { return }
                stepper += 1
            }
        } else {
            if minIndex == currentIndex {
                stepper -= stepper <= 0 ? 0 : 1
            }
        }

        let minStepper = min(stepper, (pageCount - maxDisplayedDots))
        let maxStepper = min((stepper + maxDisplayedDots), pageCount)

        let track = Array(rangeTrack[(minStepper)..<(maxStepper)])

        displayedRange = track

        updateMinMaxIndex(min: track.first!, max: track.last!)
    }

    private func updateMinMaxIndex(min: Int, max: Int) {
        self.minIndex = min
        self.maxIndex = max
    }

    private var lastPageIndex: Int {
        pageCount - 1
    }

    private var maxDisplayedDots: Int {
        if self.maxDots > 8 {
            return 8 // max 8 dots
        } else if self.maxDots > 2 && pageCount > self.maxDots {
            return self.maxDots
        }
        return pageCount
    }
}
