import SwiftUI

struct StripeView: View {
    var color: StripeColor

    var body: some View {
        return GeometryReader { proxy in
            // I had to factor out StripeContentView to make this compile.
            // Also, note that GeometryReader seems to interface with the .animation modifier, which is part of why this program manually drives the animation with a CADisplayLink.
            return StripeContentView(color: self.color, proxy: proxy)
        }
    }
}

struct StripeContentView: View {
    var color: StripeColor
    var proxy: GeometryProxy

    var body: some View {
        let width = proxy.size.width
        let y0 = self.color.phase * stripeHeight
        let ys = stride(from: y0, to: proxy.size.height, by: StripeColor.count * stripeHeight)
        let rects = ys.map { y in
            CGRect(x: 0, y: y, width: width, height: stripeHeight)
        }
        let path = Path { path in
            path.addRects(rects)
        }
        let shape = path.fill(color.color, style: .init(eoFill: true, antialiased: true))
        return shape
    }

    var stripeHeight: CGFloat { return 8 }
}

enum StripeColor: CaseIterable, Hashable, Identifiable {
    var id: StripeColor { return self }

    case red
    case green
    case blue

    var phase: CGFloat {
        switch self {
        case .red: return 2
        case .green: return 1
        case .blue: return 0
        }
    }

    var color: Color {
        switch self {
        case .red: return .init(red: 1, green: 0.14928931, blue: 0, opacity: 1)
        case .green: return .init(red: 0.3097907305, green: 0.9778609872, blue: 0, opacity: 1)
        case .blue: return .init(red: 0, green: 0.594666183, blue: 1, opacity: 1)
        }
    }

    static let count = CGFloat(Self.allCases.count)
}

#if DEBUG
struct StripeView_Previews : PreviewProvider {
    static var previews: some View {
        ZStack(content: {
            StripeView(color: .red)
            StripeView(color: .green)
            StripeView(color: .blue)
        })
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
