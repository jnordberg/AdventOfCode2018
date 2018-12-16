import Utils

func comparePositions(_ a: Point, _ b: Point) -> Bool {
    if a.y == b.y {
        return a.x < b.x
    } else {
        return a.y < b.y
    }
}

class Node: Equatable, Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.position == rhs.position
    }

    let position: Point
    var parent: Node?

    var g = 0
    var h = 0
    var f = 0

    init(_ position: Point, parent: Node? = nil) {
        self.position = position
        self.parent = parent
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

let PossibleMoves = [Point(0, -1),
                     Point(-1, 0),
                     Point(1, 0),
                     Point(0, 1)]

func a🌟(grid: Set<Point>, from: Point, to: Point) -> [Point]? {
    let start = Node(from)
    let end = Node(to)

    var open = Set<Node>()
    var closed = Set<Node>()

    open.insert(start)

    var current: Node!
    while !open.isEmpty {
        current = open.min { a, b in
            if a.f == b.f {
                return comparePositions(b.position, a.position)
            } else {
                return a.f < b.f
            }
        }

        if current == end {
            var path = Array<Node>()
            repeat {
                path.append(current)
                current = current.parent
            } while current != nil
            return path
                .map { $0.position }
                .reversed()
        }

        open.remove(current)
        closed.insert(current)

        for pos in PossibleMoves {
            let newPos = pos + current.position
            guard grid.contains(newPos) else {
                continue
            }

            let child = Node(newPos, parent: current)

            if closed.contains(child) {
                continue
            }

            child.g = current.g + 1
            child.h = 1 // + i
            child.f = child.g + child.h

            if let existing = open.remove(child), existing.f < child.f {
                open.insert(existing)
            } else {
                open.insert(child)
            }
        }
    }
    return nil
}

class Player: Hashable, Equatable, CustomStringConvertible {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }

    static var seq: Int = 0

    let id: Int
    let startingPos: Point
    var pos: Point

    var hp: Int = 200

    init(pos: Point) {
        Player.seq += 1
        id = Player.seq
        self.pos = pos
        startingPos = pos
    }

    var isAlive: Bool {
        return hp > 0
    }

    func reset() {
        hp = 200
        pos = startingPos
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var description: String {
        let type = self is Elf ? "Elf" : "Goblin"
        return "\(type)-\(id) @\(pos)"
    }
}

class Goblin: Player {}
class Elf: Player {}

extension Collection where Element: Player {
    var alive: [Player] { return filter { $0.isAlive } }
    var goblins: [Goblin] { return compactMap { $0 as? Goblin } }
    var elves: [Elf] { return compactMap { $0 as? Elf } }
}

var players = Set<Player>()
var grid = Set<Point>()

for (y, line) in readLines().enumerated() {
    for (x, char) in line.enumerated() {
        let pos = Point(x, y)
        switch char {
        case ".":
            grid.insert(pos)
        case "G":
            players.insert(Goblin(pos: pos))
            grid.insert(pos)
        case "E":
            players.insert(Elf(pos: pos))
            grid.insert(pos)
        case "#":
            break
        default:
            fatalError("Encountered invalid map segment: \(char)")
        }
    }
}

func drawState() {
    let bounds = grid.boundingRect!.inset(by: -1)
    var canvas = Canvas<Character>(bounds.size, fill: "#")
    for pos in grid.subtracting(players.alive.map { $0.pos }) {
        canvas.paint(at: pos - bounds.origin, color: ".")
    }
    for player in players.alive {
        canvas.paint(at: player.pos - bounds.origin, color: player is Goblin ? "G" : "E")
    }
    print(canvas.ascii)
}

func comparePaths(a: [Point], b: [Point]) -> Bool {
    if a.count == b.count {
        let al = a[a.count - 1]
        let bl = b[b.count - 1]
        if al == bl {
            return comparePositions(a[1], b[1])
        } else {
            return comparePositions(al, bl)
        }
    } else {
        return a.count < b.count
    }
}

func getTarget(for player: Player, targets: [Player]) -> Player? {
    let adjacent = PossibleMoves.map { player.pos + $0 }
    let adjacentTargets = targets
        .filter { adjacent.contains($0.pos) }
        .sorted { a, b in
            if a.hp == b.hp {
                return comparePositions(a.pos, b.pos)
            } else {
                return a.hp < b.hp
            }
        }
    return adjacentTargets.first
}

func simulate(_ elfPower: Int = 3) -> ([Player], Int) {
    players.forEach { $0.reset() }
    var round = 0
    outer: while true {
        for player in players.sorted(by: { comparePositions($0.pos, $1.pos) }) {
            guard player.isAlive else {
                continue
            }
            let map = grid.subtracting(players.alive.map({ $0.pos }))
            let targets: [Player] = player is Goblin ? players.elves.alive : players.goblins.alive
            var target = getTarget(for: player, targets: targets)
            if target == nil {
                let possiblePaths = targets.flatMap { target in
                    return PossibleMoves
                        .map { $0 + target.pos }
                        .filter { map.contains($0) }
                        .compactMap { a🌟(grid: map, from: player.pos, to: $0) }
                }
                guard let bestPath = possiblePaths.sorted(by: comparePaths).first else {
                    continue
                }
                player.pos = bestPath[1]
                target = getTarget(for: player, targets: targets)
            }
            if let target = target {
                target.hp -= player is Elf ? elfPower : 3
            }
        }
        if players.goblins.alive.isEmpty || players.elves.alive.isEmpty {
            break
        }
        round += 1
    }
    let winners: [Player] = players.goblins.alive.count > 0 ? players.goblins.alive : players.elves.alive
    return (winners, round)
}

func calculateOutcome(_ winners: [Player], _ round: Int) -> Int {
    let totalHp = winners.reduce(0) { $0 + $1.hp }
    return round * totalHp
}

print("Part 1")
let (winners, round) = simulate()
drawState()
print("Outcome: \(calculateOutcome(winners, round))")

print("\nPart 2")
var power = 19
let numElves = players.elves.count
while true {
    let (winners, round) = simulate(power)
    if winners.count == numElves {
        drawState()
        print("Outcome: \(calculateOutcome(winners, round))")
        break
    }
    power += 1
}
