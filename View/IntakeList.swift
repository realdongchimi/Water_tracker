// 시간별 섭취 기록을 리스트로 정렬
import SwiftUI

struct IntakeList: View {
    // 표시할 기록 리스트
    let entries: [DrinkEntry]
    var onDelete: (DrinkEntry) -> Void = { _ in }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(entries) { e in
                    IntakeRowCard(entry: e)
                        .contextMenu {
                            Button(role: .destructive) {
                                onDelete(e)
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
}
