import SwiftUI

struct TodayBlock: View {
    var todayML: Int
    @Binding var goalML: Int

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

            HStack(spacing: 6) {
                if editing {
                    TextField("목표", text: $draft)
                        .keyboardType(.numberPad)
                        .frame(width: 80)
                        .focused($focus)
                        .onAppear {
                            draft = String(goalML)
                            focus = true
                        }
                    Text("ml").foregroundStyle(.secondary)
                    Button {
                        commit()
                    } label: { Image(systemName: "checkmark.circle.fill") }

                    Button {
                        editing = false
                        focus = false
                    } label: { Image(systemName: "xmark.circle.fill") }
                } else {
                    Text("목표 \(goalML) ml")
                        .font(.headline)
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
        withAnimation { editing = false }
        focus = false
    }
}
