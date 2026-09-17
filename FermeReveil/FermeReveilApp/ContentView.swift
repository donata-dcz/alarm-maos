import SwiftUI
import AlarmCore

struct ContentView: View {
    @State private var current: Alarm = .timer(duration: 300)

    var body: some View {
        VStack(spacing: 16) {
            Text(current.kind == .alarm ? "Réveil" : "Minuterie")
                .font(.headline)
            Text(current.label)
            if current.kind == .timer {
                Text("\(Int(current.timeRemaining)) s restantes")
            } else {
                Text(current.fireDate, style: .time)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
