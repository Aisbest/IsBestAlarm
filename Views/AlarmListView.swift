import SwiftUI

struct AlarmListView: View {
    @StateObject private var viewModel = AlarmListViewModel()
    @State private var showAddSheet = false
    @State private var editingAlarm: Alarm?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.alarms.isEmpty {
                    emptyView
                } else {
                    alarmList
                }
            }
            .navigationTitle("IsBest 闹钟")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddAlarmView { label, date in
                    viewModel.addAlarm(label: label, date: date)
                }
            }
            .sheet(item: $editingAlarm) { alarm in
                AddAlarmView(
                    editingAlarm: alarm,
                    onSave: { label, date in
                        viewModel.updateAlarm(alarm, label: label, date: date)
                    }
                )
            }
            .onAppear {
                viewModel.checkPermission()
            }
        }
    }

    // MARK: - Subviews

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "alarm.waves.left.and.right")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("还没有闹钟")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("点击右上角 + 添加一个")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var alarmList: some View {
        List {
            if viewModel.permissionDenied {
                Section {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("通知权限未开启，闹钟不会响铃")
                            .font(.caption)
                        Spacer()
                        Button("去设置") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                }
            }

            Section {
                ForEach(viewModel.alarms) { alarm in
                    AlarmRowView(alarm: alarm, onToggle: {
                        viewModel.toggleAlarm(alarm)
                    }, onTap: {
                        editingAlarm = alarm
                    })
                }
                .onDelete(perform: viewModel.deleteAlarm)
            }
        }
    }
}
