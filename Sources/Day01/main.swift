import Utils

let input = readLines().compactMap { Int($0) }

// Part 1
let freq = input.reduce(0, { $0 + $1 })
print("Frequency: \(freq)")

// Part 2
var currentFreq = 0
var seenFreqs = Dictionary<Int, Int>(minimumCapacity: input.count)
var repeatingFreq: Int?

repeat {
    for value in input {
        currentFreq += value
        if seenFreqs.increment(currentFreq) > 1 {
            repeatingFreq = currentFreq
            break
        }
    }
} while (repeatingFreq == nil)

print("Repeating frequency: \(repeatingFreq!)")
