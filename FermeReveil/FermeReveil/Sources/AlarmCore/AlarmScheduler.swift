import Foundation
import Combine

public final class AlarmScheduler: ObservableObject {
    @Published public private(set) var current: Alarm?
    @Published public private(set) var isRinging: Bool = false

    public init() {}

    /// Retourne false si une programmation existe déjà et qu'il faut confirmer le remplacement.
    public func canScheduleWithoutConfirmation() -> Bool {
        current == nil
    }

    public func scheduleAlarm(at fireDate: Date) {
        current = .alarm(at: fireDate)
        isRinging = false
    }

    public func scheduleTimer(duration: TimeInterval) {
        current = .timer(duration: duration)
        isRinging = false
    }

    public func cancel() {
        current = nil
        isRinging = false
    }

    public func snooze(minutes: TimeInterval = 5) {
        guard var alarm = current else { return }
        alarm.fireDate = Date().addingTimeInterval(minutes * 60)
        current = alarm
        isRinging = false
    }

    public func stop() {
        isRinging = false
        current = nil
    }

    /// À appeler à chaque tick pour vérifier si l'alarme doit sonner.
    public func tick() {
        guard let alarm = current, !isRinging else { return }
        if alarm.hasFired {
            isRinging = true
        }
    }
}