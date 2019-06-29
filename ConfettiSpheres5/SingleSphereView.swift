import SwiftUI

struct SingleSphereView : View {
    var body: some View {
        ZStack {
            Circle()
                .fill(colorFill)
            Circle()
                .fill(shadowFill)
        }.sphereSized()
    }

    var colorFill: RadialGradient {
        let colors = Gradient(stops: [
            .init(color: .white, location: 0),
            .init(color: .white, location: 0.1),
            .init(color: .init(red: 0.9813960195, green: 0.7744863629, blue: 0.5789747238), location: 1)
        ])
        return .init(
            gradient: colors,
            center: .init(x: 0.4, y: 0.4),
            startRadius: 0,
            endRadius: Self.size / 2)
    }

    var shadowFill: RadialGradient {
        let colors = Gradient(stops: [
            .init(color: Color.clear, location: 0),
            .init(color: Color.clear, location: 0.5),
            .init(color: Color.black.opacity(0.2), location: 0.8),
            .init(color: Color.clear, location: 1.0),
        ])
        return .init(
            gradient: colors,
            center: .init(x: 0.4, y: 0.4),
            startRadius: 0,
            endRadius: Self.size * 0.7)
    }

    static var size: CGFloat { return 140 }
}

struct SphereSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(width: SingleSphereView.size, height: SingleSphereView.size)
    }
}

extension View {
    func sphereSized() -> Modified<SphereSizeModifier> {
        return modifier(SphereSizeModifier())
    }
}


#if DEBUG
struct SphereView_Previews : PreviewProvider {
    static var previews: some View {
        SingleSphereView()
            .previewLayout(.fixed(width: SingleSphereView.size, height: SingleSphereView.size))
    }
}
#endif
