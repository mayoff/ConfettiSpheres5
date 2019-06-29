import SwiftUI
import Combine

class Model: BindableObject {
    let didChange = PassthroughSubject<Model, Never>()

    private(set) var overlayWidth: CGFloat = ContentView.width / 2
    private(set) var overlayVelocity: CGFloat = 0

    func cancelCoasting() {
        overlayVelocity = 0
        displayLink?.isPaused = true
        didChange.send(self)
    }

    func setOverlay(width: CGFloat, velocity: CGFloat) {
        overlayWidth = width
        overlayVelocity = velocity
        didChange.send(self)

        if overlayVelocity != 0 {
            startDisplayLink()
        }
    }

    let overlayRange = 0 ... ContentView.width

    deinit {
        displayLink?.invalidate()
    }

    private var displayLink: CADisplayLink?

    private func startDisplayLink() {
        let link: CADisplayLink
        if let existing = displayLink { link = existing }
        else {
            link = CADisplayLink(target: self, selector: #selector(displayLinkDidFire))
            displayLink = link
            link.preferredFramesPerSecond = 0
            link.add(to: RunLoop.main, forMode: .common)
        }

        link.isPaused = false
    }

    @objc private func displayLinkDidFire(_ link: CADisplayLink) {
        overlayVelocity *= 0.95 // Not correct because it should take link.duration into account.
        overlayWidth += overlayVelocity * CGFloat(link.duration)
        if overlayVelocity == 0 || !overlayRange.contains(overlayWidth) {
            overlayWidth = max(overlayRange.lowerBound, min(overlayWidth, overlayRange.upperBound))
            overlayVelocity = 0
            link.isPaused = true
        }
        didChange.send(self)
    }
}
