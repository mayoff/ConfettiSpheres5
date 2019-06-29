import SwiftUI

struct MultiSphereView : View {
    var centers: [CGPoint]

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0 ..< centers.count) { i in
                SingleSphereView()
                    .position(.init(x: self.centers[i].x, y: 756 - self.centers[i].y))
            }
        }
    }

    static func `for`(_ color: StripeColor) -> MultiSphereView {
        switch color {
        case .red: return Self.red
        case .green: return Self.green
        case .blue: return Self.blue
        }
    }

    static var red: MultiSphereView {
        return Self.init(centers: [
            .init(x: 522, y: 619),
            .init(x: 882, y: 419),
            .init(x: 243, y: 307),
            .init(x: 626, y: 239),
        ])
    }

    static var green: MultiSphereView {
        return Self.init(centers: [
            .init(x: 290, y: 616),
            .init(x: 631, y: 467),
            .init(x: 128, y: 144),
            .init(x: 390, y: 104),
            ])
    }

    static var blue: MultiSphereView {
        return Self.init(centers: [
            .init(x: 135, y: 473),
            .init(x: 439, y: 362),
            .init(x: 797, y: 636),
            .init(x: 829, y: 155),
        ])
    }
}

#if DEBUG
struct MultiSphereView_Previews : PreviewProvider {
    static var previews: some View {
        ZStack(content: {
            MultiSphereView.red
            MultiSphereView.green
            MultiSphereView.blue
        })
            .previewLayout(.fixed(width: 1024, height: 756))
    }
}
#endif
