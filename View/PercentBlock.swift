// 물 섭취를 어느정도 했는지 퍼센트를 알려줌
import SwiftUI

struct PercentBlock: View {
    // 진행률 (0.0~1.0)
    var progress: Double
    // 퍼센트로 변환  (0~100)
    var body: some View {
        Text("\(Int(progress * 100))%")
            .font(.system(size: 60, weight: .heavy))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
