import SwiftUI

struct AddAlarmView: View {
    var editingAlarm: Alarm?
    var onSave: (String, Date) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var label: String = ""
    @State private var date: Date = {
        // 默认设为下个月的今天 10:00
        let now = Date()
        let calendar = Calendar.current
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: now) else { return now }
        var components = calendar.dateComponents([.year, .month, .day], from: nextMonth)
        components.hour = 10
        components.minute = 0
        return calendar.date(from: components) ?? now
    }()

    private var isEditing: Bool { editingAlarm != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(
                        "日期和时间",
                        selection: $date,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                }

                Section("提醒内容") {
                    TextField("例如：还信用卡、交房租", text: $label)
                }

                Section {
                    Button {
                        onSave(label.trimmingCharacters(in: .whitespaces), date)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isEditing ? "保存修改" : "添加闹钟")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(date <= Date())
                }
            }
            .navigationTitle(isEditing ? "编辑闹钟" : "新建闹钟")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let alarm = editingAlarm {
                    label = alarm.label
                    date = alarm.date
                }
            }
        }
    }
}
