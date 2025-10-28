import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: DrinkStore
    @State private var showSettings = false
    @State private var selectedAmount = 150

    var body: some View {
        VStack(spacing: 20) {
            HeaderView(onTapSettings: { showSettings = true })

            PercentBlock(progress: store.progress)

            LinearProgressView(progress: store.progress)
                .frame(height: 12)

            HStack(alignment: .top, spacing: 16) {
                AmountPicker(selected: $selectedAmount)
                VStack(alignment: .trailing, spacing: 10) {
                    TodayBlock(todayML: store.today.totalML,
                               goalML: $store.goalML)
                    DrinkButton(amount: selectedAmount) { ml in
                        store.addDrink(amount: ml)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            IntakeList(entries: store.today.entries) { entry in
                store.deleteEntry(entry)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .sheet(isPresented: $showSettings) {
            SettingSheet().environmentObject(store)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}
