import SwiftUI
import AlarmCore

struct ContentView: View {
    var body: some View {
        List(Alarm.defaultAlarm) { alarm in
            VStack(alignment: .leading) {
                Text(alarm.label)
                Text(alarm.date, style: .time)
            }
        }
    }
}

#Preview {
    ContentView()
}
