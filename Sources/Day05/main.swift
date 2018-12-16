import Foundation
import Utils

let input = readLine()!

func scanPolymer(_ sequence: String) -> Int {
    var seq = sequence
    var pos = sequence.index(after: sequence.startIndex)
    while pos < seq.endIndex {
        let range = seq.index(before: pos) ... pos
        let pair = seq[range]
        let upperPair = pair.uppercased()
        if upperPair.first! == upperPair.last! && pair.first!.isLowerCase != pair.last!.isLowerCase {
            let startPos = seq.index(after: seq.startIndex)
            pos = seq.index(pos, offsetBy: -2, limitedBy: startPos) ?? startPos
            seq.removeSubrange(range)
        } else {
            pos = seq.index(after: pos)
        }
    }
    return seq.count
}

print("Reacted polymer length: \(scanPolymer(input))")

let types = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { Set([$0, String($0).lowercased().first!]) }

var best = Int.max
for type in types {
    let seq = input.filter { !type.contains($0) }
    let result = scanPolymer(seq)
    if result < best {
        best = result
    }
}

print("Best polymer length: \(best)")
