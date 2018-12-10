import Foundation
import Utils

struct Entry {
    enum Action: Equatable {
        case guardChange(id: Int)
        case wakeUp
        case fallAsleep
    }

    let date: Date
    let action: Action

    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    init(_ string: String) {
        let parts = string.split(separator: "]").map { String($0.dropFirst()) }
        date = Entry.formatter.date(from: parts[0])!
        switch parts[1] {
        case "wakes up":
            action = .wakeUp
        case "falls asleep":
            action = .fallAsleep
        default:
            let id = parts[1]
                .drop { $0 != "#" }
                .dropFirst()
                .prefix { $0 != " " }
            action = .guardChange(id: Int(id)!)
        }
    }
}

struct Period {
    let start: Date
    let end: Date
    var duration: TimeInterval {
        return end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
    }
}

typealias GuardID = Int

let entries = readLines()
    .map { Entry($0) }
    .sorted { $0.date < $1.date }

var sleepPeriods = Dictionary<GuardID, [Period]>()
var currentGuard: GuardID!
var prevEntry: Entry!

for entry in entries {
    switch entry.action {
    case let .guardChange(id):
        currentGuard = id
    case .fallAsleep:
        break
    case .wakeUp:
        assert(prevEntry.action == .fallAsleep)
        sleepPeriods[currentGuard, default: []].append(Period(start: prevEntry.date, end: entry.date))
    }
    prevEntry = entry
}

let sleepDurations = sleepPeriods.mapValues({ (period) -> TimeInterval in
    period.reduce(0, { $0 + $1.duration })
})

let sleepyGuard = sleepDurations
    .sorted { $0.value > $1.value }
    .first!
    .key

typealias Minute = Int

func getSleepMinutes(_ periods: [Period]) -> [(Minute, Int)] {
    var rv = Dictionary<Minute, Int>()
    for period in periods {
        let minutes = Int(period.duration / 60)
        let startMinute = Calendar.current.component(.minute, from: period.start)
        for minute in startMinute ..< startMinute + minutes {
            rv.increment(minute % 60)
        }
    }
    return rv.sorted { $0.value > $1.value }
}

let sleepyMinute = getSleepMinutes(sleepPeriods[sleepyGuard]!).first!.0

print("Strategy 1: \(sleepyMinute * sleepyGuard)")

let consistentSleeper = sleepPeriods
    .mapValues(getSleepMinutes)
    .sorted { $0.value.first!.1 > $1.value.first!.1 }
    .first!

print("Strategy 2: \(consistentSleeper.key * consistentSleeper.value.first!.0)")
