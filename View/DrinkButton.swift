// 버튼 클릭시 선택된 양을 추가
import SwiftUI

struct DrinkButton: View {
    // 한 번에 추가할 섭취량
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
