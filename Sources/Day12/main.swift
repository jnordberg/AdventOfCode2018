import Foundation
import Utils

let input = readLines()

enum Plant: Equatable, Hashable, CustomStringConvertible {
    case alive, dead

    init?(_ char: Character) {
        switch char {
        case "#":
            self = .alive
        case ".":
            self = .dead
        default:
            return nil
        }
    }

    var description: String {
        switch self {
        case .alive:
            return "#"
        case .dead:
            return "."
        }
    }
}

struct Tunnel: CustomStringConvertible {
    typealias Position = Int

    var plants = Dictionary<Position, Plant>()

    init() {}

    init(initialState: [Plant]) {
        for (pos, plant) in initialState.enumerated() {
            plants[pos] = plant
        }
    }

    var description: String {
        guard let extent = plants.keys.extent() else {
            return ""
        }
        var rv = ""
        for pos in extent.min ... extent.max {
            rv += plants[pos, default: .dead].description
        }
        return rv
    }
}

struct Mutation: CustomStringConvertible {
    let left: (Plant, Plant)
    let center: Plant
    let right: (Plant, Plant)
    let result: Plant

    init(_ string: String) {
        let chars = Array(string.prefix(5))
        left = (Plant(chars[0])!, Plant(chars[1])!)
        center = Plant(chars[2])!
        right = (Plant(chars[3])!, Plant(chars[4])!)
        result = Plant(string.last!)!
    }

    var description: String {
        return "\(left.0)\(left.1)\(center)\(right.0)\(right.1) => \(result)"
    }
}

let state = input[0].compactMap { Plant($0) }
let mutations = input.dropFirst(2).map { Mutation($0) }
let tunnel = Tunnel(initialState: state)

func score(_ tunnel: Tunnel) -> Int {
    return tunnel.plants.reduce(0) { $0 + ($1.value == .alive ? $1.key : 0) }
}

func simulate(_ initial: Tunnel, generations: Int) -> Int {
    var current = initial
    var lastScore = score(initial)
    var scoreDiffs: [Int] = []
    for gen in 1 ... generations {
        var next = Tunnel()
        let extent = current.plants.keys.extent()!
        for pos in extent.min - 2 ... extent.max + 2 {
            let plant = current.plants[pos, default: .dead]
            let left = (current.plants[pos - 2, default: .dead], current.plants[pos - 1, default: .dead])
            let right = (current.plants[pos + 1, default: .dead], current.plants[pos + 2, default: .dead])
            let match = mutations.enumerated().first { (_, mutation) -> Bool in
                if plant == mutation.center && left == mutation.left && right == mutation.right {
                    return true
                }
                return false
            }
            if let match = match {
                next.plants[pos] = match.element.result
            }
        }
        current = next

        let currentScore = score(current)
        let diff = currentScore - lastScore
        lastScore = currentScore
        scoreDiffs.append(diff)
        if scoreDiffs.count > 5 {
            if scoreDiffs.allSatisfy({ $0 == diff }) {
                return lastScore + (generations - gen) * diff
            }
            scoreDiffs.removeFirst()
        }
    }
    return lastScore
}

print("Result after 20 generations: \(simulate(tunnel, generations: 20))")
print("Result after 50 billion generations: \(simulate(tunnel, generations: 50_000_000_000))")
