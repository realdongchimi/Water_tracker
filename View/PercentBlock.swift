import SwiftUI

struct PercentBlock: View {
    var progress: Double
    var body: some View {
        Text("\(Int(progress * 100))%")
            .font(.system(size: 60, weight: .heavy))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
