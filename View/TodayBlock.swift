// 오늘의 섭취 총량과 목표 섭취량을 보여줌
import SwiftUI

struct TodayBlock: View {
    // 오늘의 총 섭취량 (읽기 전용)
    var todayML: Int
    // 목표 섭취량 (수정 가능)
    @Binding var goalML: Int
    // 편집 중인지 여부
    @State private var editing = false
    @State private var draft = ""
    @FocusState private var focus: Bool

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("Today")
                .font(.footnote).foregroundStyle(.secondary)

            Text("\(todayML) ml")
                .font(.title2.bold())
                .foregroundColor(.blue)

            // 목표 표시 및 편집
            HStack(spacing: 6) {
                if editing {
                    // TextField를 사용하여 편집
                    TextField("목표", text: $draft)
                        .keyboardType(.numberPad)
                        .frame(width: 80)
                        .focused($focus)
                        .onAppear {
                            draft = String(goalML)
                            focus = true
                        }
                    Text("ml").foregroundStyle(.secondary)
                    // 완료 버튼
                    Button {
                        commit()
                    } label: { Image(systemName: "checkmark.circle.fill") }

                    // 취소 버튼
                    Button {
                        editing = false
                        focus = false
                    } label: { Image(systemName: "xmark.circle.fill") }
                } else {
                    Text("목표 \(goalML) ml")
                        .font(.headline)
                    // 버튼을 누르면 편집 모드로 전환
                    Button {
                        editing = true
                    } label: { Image(systemName: "pencil") }
                }
            }
        }
    }

    private func commit() {
        if let v = Int(draft.filter(\.isNumber)), (300...6000).contains(v) {
            if v != goalML { goalML = v; UIImpactFeedbackGenerator(style: .light).impactOccurred() }
        }
        // 편집 종료
        withAnimation { editing = false }
        focus = false
    }
}
