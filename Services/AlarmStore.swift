import Foundation

/// 负责闹钟数据的持久化存储（UserDefaults + JSON）
class AlarmStore: ObservableObject {
    @Published var alarms: [Alarm] = []

    private let storageKey = "com.isbest.alarms"

    init() {
        load()
    }

    // MARK: - CRUD

    func add(_ alarm: Alarm) {
        alarms.append(alarm)
        save()
    }

    func update(_ alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms[index] = alarm
        save()
    }

    func delete(_ alarm: Alarm) {
        alarms.removeAll { $0.id == alarm.id }
        save()
    }

    func delete(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
        save()
    }

    func toggle(_ alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms[index].isActive.toggle()
        save()
    }

    // MARK: - Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(alarms) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Alarm].self, from: data)
        else { return }
        alarms = saved
    }
}
