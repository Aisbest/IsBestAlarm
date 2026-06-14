import SwiftUI

struct AlarmRowView: View {
    let alarm: Alarm
    var onToggle: () -> Void
    var onTap: () -> Void

    var body: some View {
        HStack {
            // 左侧：时间 + 标签
            VStack(alignment: .leading, spacing: 4) {
                Text(alarm.shortFormatted)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(alarm.isActive ? .primary : .secondary)

                if !alarm.label.isEmpty {
                    Text(alarm.label)
                        .font(.subheadline)
                        .foregroundColor(alarm.isActive ? .secondary : .tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // 右侧：开关
            Toggle(isOn: Binding(
                get: { alarm.isActive },
                set: { _ in onToggle() }
            )) {
                EmptyView()
            }
            .labelsHidden()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .opacity(alarm.isActive ? 1.0 : 0.5)
    }
}
