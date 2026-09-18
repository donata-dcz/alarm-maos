import SwiftUI
import AlarmCore

struct ContentView: View {
    @StateObject private var scheduler = AlarmScheduler()

    @State private var mode: ScheduleKind = .alarm
    @State private var selectedTime = Date()
    @State private var durationMinutes: Double = 5

    @State private var showReplaceConfirmation = false
    @State private var pendingModeSwitch: ScheduleKind?

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            Text("Ferme Réveil")
                .font(.largeTitle.bold())

            if let alarm = scheduler.current {
                scheduledView(alarm: alarm)
            } else {
                setupView
            }
        }
        .padding()
        .onReceive(timer) { _ in
            scheduler.tick()
        }
        .confirmationDialog(
            "Remplacer la programmation en cours ?",
            isPresented: $showReplaceConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remplacer", role: .destructive) {
                scheduler.cancel()
                if let newMode = pendingModeSwitch {
                    mode = newMode
                }
            }
            Button("Annuler", role: .cancel) {}
        }
    }

    // MARK: - Écran de réglage (rien de programmé)

    private var setupView: some View {
        VStack(spacing: 20) {
            Picker("Mode", selection: modeBinding) {
                Text("Réveil").tag(ScheduleKind.alarm)
                Text("Minuterie").tag(ScheduleKind.timer)
            }
            .pickerStyle(.segmented)

            if mode == .alarm {
                DatePicker("Heure", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            } else {
                Stepper("Durée : \(Int(durationMinutes)) min", value: $durationMinutes, in: 1...120)
            }

            Button("Écouter l'aperçu") {
                playPreview()
            }
            .buttonStyle(.bordered)

            Button("Programmer") {
                schedule()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var modeBinding: Binding<ScheduleKind> {
        Binding(
            get: { mode },
            set: { newValue in
                if scheduler.current != nil, newValue != mode {
                    pendingModeSwitch = newValue
                    showReplaceConfirmation = true
                } else {
                    mode = newValue
                }
            }
        )
    }

    private func schedule() {
        switch mode {
        case .alarm:
            scheduler.scheduleAlarm(at: selectedTime)
        case .timer:
            scheduler.scheduleTimer(duration: durationMinutes * 60)
        }
    }

    private func playPreview() {
        // TODO : jouer la piste "ferme" prémixée réelle une fois intégrée au bundle
        print("Aperçu son : scène ferme (coq → oiseaux → poules → vache)")
    }

    // MARK: - Écran programmation active / sonnerie

    private func scheduledView(alarm: Alarm) -> some View {
        VStack(spacing: 20) {
            Text(alarm.kind == .alarm ? "Réveil programmé" : "Minuterie en cours")
                .font(.headline)

            if scheduler.isRinging {
                Text("Ça sonne !")
                    .font(.title)
                    .foregroundStyle(.orange)

                HStack(spacing: 16) {
                    Button("Arrêter") {
                        scheduler.stop()
                    }
                    .buttonStyle(.borderedProminent)

                    if alarm.isSnoozeEnabled {
                        Button("Reporter 5 min") {
                            scheduler.snooze()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            } else {
                if alarm.kind == .alarm {
                    Text(alarm.fireDate, style: .time)
                        .font(.system(size: 40, weight: .semibold))
                } else {
                    Text(formattedRemaining(alarm.timeRemaining))
                        .font(.system(size: 40, weight: .semibold, design: .monospaced))
                }

                HStack(spacing: 16) {
                    Button("Modifier") {
                        scheduler.cancel()
                    }
                    .buttonStyle(.bordered)

                    Button("Annuler") {
                        scheduler.cancel()
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
        }
    }

    private func formattedRemaining(_ seconds: TimeInterval) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    ContentView()
}