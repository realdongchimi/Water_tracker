import SwiftUI

struct IntakeRowCard: View {
    let entry: DrinkEntry

    var body: some View {
        HStack {
            Label("\(entry.amount)ml", systemImage: "cup.and.saucer.fill")
            Spacer()
            Text(entry.time.formatted(date: .omitted, time: .shortened))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.blue.opacity(0.15)))
    }
}
