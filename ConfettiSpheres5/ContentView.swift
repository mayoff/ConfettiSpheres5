import SwiftUI

struct ContentView : View {
    @ObjectBinding var model: Model
    @GestureState var dragState = DragState()
    @State var v: CGFloat = 0

    // https://www.dropbox.com/sh/oi9wdd0uc5uc700/AAAXFo4uWPG6ZEygQ5GY50tma?dl=0.&preview=Confetti+Spheres+5.png
    // The size of the original Confetti Spheres 5.png.
    static var width: CGFloat { return 1024 }
    static var height: CGFloat { return 756 }

    var body: some View {
        ZStack(alignment: .topLeading) {
            BackgroundStripesView()
            StripedSpheresView()
            OverlayStripesView(size: .init(width: model.overlayWidth + dragState.dragOffset, height: Self.height))
            }
            .frame(width: Self.width, height: Self.height)
            .gesture(dragGesture)
    }

    var dragGesture: some Gesture {
        return AnyGesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onEnded { self.endDragGesture(with: $0) })
            .updating($dragState) { (drag, dragState, transaction) in
                self.updateDragState(&dragState, with: drag) }
    }

    func dragOffset(forProposedDragOffset x: CGFloat) -> CGFloat {
        return max(-model.overlayWidth, min(x, Self.width - model.overlayWidth))
    }

    func updateDragState(_ dragState: inout DragState, with drag: DragGesture.Value) {
        model.cancelCoasting()
        if let priorDrag = dragState.priorDrag {
            let ds = drag.translation.width - priorDrag.translation.width
            let dt = CGFloat(drag.time.timeIntervalSinceReferenceDate - priorDrag.time.timeIntervalSinceReferenceDate)
            if dt > 0.1 {
                dragState.velocity = 0
            } else {
                // https://stackoverflow.com/a/1027808/77567
                let velocitySample = ds / dt
                let alpha = -expm1(-7 * dt)
                let oldVelocity = dragState.velocity
                dragState.velocity = oldVelocity + alpha * (velocitySample - oldVelocity)
            }
        }
        dragState.priorDrag = drag
        dragState.dragOffset = self.dragOffset(forProposedDragOffset: drag.translation.width)
    }

    func endDragGesture(with drag: DragGesture.Value) {
        let velocity: CGFloat
        if
            let priorDrag = dragState.priorDrag,
            drag.time.timeIntervalSinceReferenceDate - priorDrag.time.timeIntervalSinceReferenceDate > 0.1
        {
            velocity = 0
        } else {
            velocity = dragState.velocity
        }

        v = velocity
        let newWidth = model.overlayWidth + dragOffset(forProposedDragOffset: drag.translation.width)
        model.setOverlay(width: newWidth, velocity: velocity)
    }

    struct DragState {
        var priorDrag: DragGesture.Value? = nil
        var dragOffset: CGFloat = 0
        var velocity: CGFloat = 0 // points per second
    }
}

fileprivate struct BackgroundStripesView: View {
    var body: some View {
        ForEach(StripeColor.allCases) {
            StripeView(color: $0)
        }
    }
}

fileprivate struct StripedSpheresView: View {
    var body: some View {
        ForEach(StripeColor.allCases) {
            MultiSphereView.for($0)
        }
    }
}

fileprivate struct OverlayStripesView: View {
    var size: CGSize

    var body: some View {
        ForEach(StripeColor.allCases) {
            StripeView(color: $0)
                .frame(width: self.size.width, height: self.size.height)
                .mask(MultiSphereView.for($0))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let model = Model()
        return ContentView(model: model)
            .previewLayout(.sizeThatFits)
    }
}
#endif
