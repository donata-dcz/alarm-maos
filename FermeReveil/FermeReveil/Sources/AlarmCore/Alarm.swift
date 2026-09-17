import Foundation

public enum ScheduleKind: String, Codable {
    case alarm
    case timer
}

public struct Alarm: Codable, Identifiable, Equatable {
    public let id: UUID
    public let kind: ScheduleKind
    public var label: String
    public var fireDate: Date
    public var originalDuration: TimeInterval?
    public var isSnoozeEnabled: Bool

    public var timeRemaining: TimeInterval {
        max(0, fireDate.timeIntervalSinceNow)
    }

    public var hasFired: Bool {
        fireDate <= Date()
    }

    public static func alarm(at fireDate: Date, label: String = "Réveil ferme", snooze: Bool = true) -> Alarm {
        Alarm(id: UUID(), kind: .alarm, label: label, fireDate: fireDate, originalDuration: nil, isSnoozeEnabled: snooze)
    }

    public static func timer(duration: TimeInterval, label: String = "Minuterie ferme", snooze: Bool = false) -> Alarm {
        Alarm(id: UUID(), kind: .timer, label: label, fireDate: Date().addingTimeInterval(duration), originalDuration: duration, isSnoozeEnabled: snooze)
    }
}
