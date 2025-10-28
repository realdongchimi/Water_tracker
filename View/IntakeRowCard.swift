// 섭취 기록 한 건을 카드 형태로 시각화 
import SwiftUI

struct IntakeRowCard: View {
    // 한 건의 섭취 기록 데이터
    let entry: DrinkEntry

    var body: some View {
        HStack {
            // 왼쪽 아이콘 및 섭취량
            Label("\(entry.amount)ml", systemImage: "cup.and.saucer.fill")
            Spacer()
            // 오른쪽 시간
            Text(entry.time.formatted(date: .omitted, time: .shortened))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.blue.opacity(0.15)))
    }
}
