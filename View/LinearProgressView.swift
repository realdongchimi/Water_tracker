import SwiftUI

struct LinearProgressView: View {
    var progress: Double
    var height: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.12))
                    .frame(height: height)
                Capsule()
                    .fill(Color.blue)
                    .frame(width: geo.size.width * max(0, min(1, progress)), height: height)
                    .animation(.easeOut(duration: 0.25), value: progress)
            }
        }
        .frame(height: height)
    }
}
