import Foundation

enum ScheduleKind: String, Codable {
    case alarm
    case timer
}

struct Alarm: Codable, Identifiable, Equatable {
    let id: UUID
    let kind: ScheduleKind
    var label: String
    var fireDate: Date
    var originalDuration: TimeInterval?
    var isSnoozeEnabled: Bool

    var timeRemaining: TimeInterval {
        max(0, fireDate.timeIntervalSinceNow)
    }

    var hasFired: Bool {
        fireDate <= Date()
    }


    static func alarm(at fireDate: Date, label: String = "Réveil ferme", snooze: Bool = true) -> Alarm {
        Alarm(id: UUID(), kind: .alarm, label: label, fireDate: fireDate, originalDuration: nil, isSnoozeEnabled: snooze)
    }

    static func timer(duration: TimeInterval, label: String = "Minuterie ferme", snooze: Bool = false) -> Alarm {
        Alarm(id: UUID(), kind: .timer, label: label, fireDate: Date().addingTimeInterval(duration), originalDuration: duration, isSnoozeEnabled: snooze)
    }
}

