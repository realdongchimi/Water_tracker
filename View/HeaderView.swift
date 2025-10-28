import SwiftUI

struct HeaderView: View {
    var onTapSettings: () -> Void

    var body: some View {
        HStack {
            Text("물마시개 💧")
                .font(.title).bold()
            Spacer()
            Button(action: onTapSettings) {
                Image(systemName: "gearshape")
                    .font(.title3)
            }
        }
    }
}
