// 설정 모달창
import SwiftUI

struct SettingSheet: View {
    @EnvironmentObject var store: DrinkStore
    @State private var showAlert = false
    @State private var resetTime: Date = {
        var c = DateComponents()
        c.hour = UserDefaults.standard.integer(forKey: "resetHour")    // 존재하지 않으면 0
        c.minute = UserDefaults.standard.integer(forKey: "resetMinute")
        // 오늘 날짜의 같은 시,분으로  Date 생성
        return Calendar.current.date(from: c) ?? DateComponents(calendar: .current, hour: 0, minute: 0).date!
    }()

    var body: some View {
        NavigationStack {
            Form {
                // 일일 자동 초기화 설정
                Section("일일 초기화") {
                    // 자동 초기화 사용/미사용 토글
                    Toggle("자동 초기화 사용", isOn: $store.autoResetEnabled)
                    // 초기화 시각 선택 (시/분)
                    DatePicker("초기화 시각",
                               selection: $resetTime,
                               displayedComponents: .hourAndMinute)
                    .onChange(of: resetTime) { _, d in
                        // 사용자ㅐ가 시/분을 바꾸면 Store에 반영
                        store.updateResetTime(to: d)
                    }

                    Text("기본값 00:00. 해당 시각을 지나면 다음 활성화 시 자동 초기화됩니다.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }

                // 수동 초기화
                Section {
                    Button(role: .destructive) {
                        showAlert = true
                    } label: {
                        Label("일일 초기화", systemImage: "arrow.counterclockwise")
                    }
                } footer: {
                    Text("지금 즉시 오늘의 기록(총량·시간별)을 초기화합니다.")
                }
            }
            .navigationTitle("설정")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
            // 삭제 동작 확인 알림
            .alert("오늘 기록을 초기화할까요?", isPresented: $showAlert) {
                Button("취소", role: .cancel) {}
                Button("초기화", role: .destructive) { store.resetToday() }
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
}
