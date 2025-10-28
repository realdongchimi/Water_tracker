import SwiftUI

struct IntakeList: View {
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
