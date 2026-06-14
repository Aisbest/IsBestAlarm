import Foundation
import UserNotifications

/// 连接 AlarmStore 和 NotificationService，管理闹钟状态
@MainActor
class AlarmListViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var permissionDenied: Bool = false

    private let store = AlarmStore()
    private let notificationService = NotificationService()

    init() {
        self.alarms = store.alarms
    }

    // MARK: - Permission

    func checkPermission() {
        notificationService.ensurePermission { [weak self] granted in
            self?.permissionDenied = !granted
        }
    }

    // MARK: - Actions

    func addAlarm(label: String, date: Date) {
        let alarm = Alarm(label: label, date: date, isActive: true)
        store.add(alarm)
        alarms = store.alarms
        notificationService.schedule(alarm: alarm)
    }

    func deleteAlarm(at offsets: IndexSet) {
        for index in offsets {
            notificationService.cancel(alarmId: alarms[index].id)
        }
        store.delete(at: offsets)
        alarms = store.alarms
    }

    func deleteAlarm(_ alarm: Alarm) {
        notificationService.cancel(alarmId: alarm.id)
        store.delete(alarm)
        alarms = store.alarms
    }

    func toggleAlarm(_ alarm: Alarm) {
        store.toggle(alarm)
        alarms = store.alarms

        if let updated = alarms.first(where: { $0.id == alarm.id }) {
            if updated.isActive {
                notificationService.schedule(alarm: updated)
            } else {
                notificationService.cancel(alarmId: updated.id)
            }
        }
    }

    func updateAlarm(_ alarm: Alarm, label: String, date: Date) {
        notificationService.cancel(alarmId: alarm.id)
        var updated = alarm
        updated.label = label
        updated.date = date
        updated.isActive = true
        store.update(updated)
        alarms = store.alarms
        notificationService.schedule(alarm: updated)
    }
}
