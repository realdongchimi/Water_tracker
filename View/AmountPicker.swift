// 추가할 물 섭취량을 선택하는 세로형 선택 뷰
import SwiftUI

struct AmountPicker: View {
    @Binding var selected: Int
    // 표시할 옵션 목록
    var options: [Int] = [100,150,200,250,300,350,400,450,500]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(options, id: \.self) { ml in
                    Text("\(ml)ml")
                        .font(ml == selected ? .title3.bold() : .body)
                        .foregroundStyle(ml == selected ? .primary : .gray)
                        .onTapGesture { selected = ml }
                }
            }
            .padding(.vertical, 8)
        }
        .frame(width: 90, height: 130)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.05)))
    }
}
