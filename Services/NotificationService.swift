import UserNotifications

/// 负责系统通知的权限请求、调度和取消
class NotificationService {

    // MARK: - Permission

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("通知权限请求失败: \(error.localizedDescription)")
            }
            if granted {
                print("通知权限已授权")
            } else {
                print("用户拒绝了通知权限")
            }
        }
    }

    /// 检查当前通知权限状态，未决定则请求，已拒绝则提示
    func ensurePermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.requestPermission()
                    completion(false)
                case .denied:
                    completion(false)
                case .authorized, .provisional, .ephemeral:
                    completion(true)
                @unknown default:
                    completion(false)
                }
            }
        }
    }

    // MARK: - Schedule

    func schedule(alarm: Alarm) {
        guard alarm.isActive else { return }

        let content = UNMutableNotificationContent()
        content.title = "⏰ 闹钟"
        content.body = alarm.label.isEmpty ? "时间到了！" : alarm.label
        content.sound = .default

        // 只取年月日时分，精确到分钟
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarm.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知调度失败: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Cancel

    func cancel(alarmId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarmId.uuidString])
    }

    /// 查看所有已调度的通知（调试用）
    func listPending(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
}
