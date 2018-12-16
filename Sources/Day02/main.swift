import Utils

let input = readLines()

// Part 1

func letterCount(_ string: String) -> Dictionary<Character, Int> {
    var rv = Dictionary<Character, Int>(minimumCapacity: string.count)
    for letter in string {
        rv.increment(letter)
    }
    return rv
}

var twos = 0
var threes = 0
for checksum in input {
    let counts = letterCount(checksum)
    if counts.values.contains(2) { twos += 1 }
    if counts.values.contains(3) { threes += 1 }
}

print("Checksum: \(twos * threes)")

// Part 2

func distance(_ a: String, _ b: String) -> Int {
    precondition(a.count == b.count)
    return zip(a, b).reduce(0) { $0 + ($1.0 == $1.1 ? 0 : 1) }
}

func common(_ a: String, _ b: String) -> String {
    precondition(a.count == b.count)
    return String(zip(a, b).filter { $0.0 == $0.1 }.map { $0.0 })
}

outer: for sum1 in input {
    for sum2 in input {
        let d = distance(sum1, sum2)
        if d == 1 {
            print("Common letters: \(common(sum1, sum2))")
            break outer
        }
    }
}
