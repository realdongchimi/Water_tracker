import SwiftUI

struct DrinkButton: View {
    var amount: Int
    var onAdd: (Int) -> Void

    var body: some View {
        Button {
            onAdd(amount)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Text("꿀꺽!")
                .bold()
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .background(Capsule().fill(Color.blue))
        .foregroundStyle(.white)
    }
}
