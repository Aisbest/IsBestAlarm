import Foundation

struct Alarm: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var label: String
    var date: Date
    var isActive: Bool = true

    /// 格式化显示日期和时间，如 "2026年7月13日 10:00"
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        return formatter.string(from: date)
    }

    /// 简短格式，如 "7月13日 10:00"
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日 HH:mm"
        return formatter.string(from: date)
    }
}
