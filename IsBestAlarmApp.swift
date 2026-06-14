import SwiftUI

@main
struct IsBestAlarmApp: App {
    @StateObject private var viewModel = AlarmListViewModel()

    var body: some Scene {
        WindowGroup {
            AlarmListView()
                .onAppear {
                    // 启动时请求通知权限
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
                }
        }
    }
}
