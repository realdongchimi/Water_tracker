import SwiftUI

struct AmountPicker: View {
    @Binding var selected: Int
    var options: [Int] = [100,150,200,250,300]

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
