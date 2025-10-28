// 타이틀 및 설정창 버튼 배치
import SwiftUI

struct HeaderView: View {
    var onTapSettings: () -> Void

    var body: some View {
        HStack {
            // 앱 타이틀
            Text("물마시개🦭")
                .font(.title).bold()
            Spacer()
            // 설정창 버튼
            Button(action: onTapSettings) {
                Image(systemName: "gearshape")
                    .font(.title3)
            }
        }
    }
}
