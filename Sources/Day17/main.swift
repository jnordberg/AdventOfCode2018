import Foundation
import Utils

enum Water {
    case still, flowing
}

class Source: Equatable, Hashable {
    static func == (lhs: Source, rhs: Source) -> Bool {
        return lhs.pos == rhs.pos
    }

    let pos: Point
    let parent: Source?
    init(_ pos: Point, parent: Source? = nil) {
        self.pos = pos
        self.parent = parent
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(pos)
    }
}

func parseRange(_ value: String) -> ClosedRange<Int> {
    if value.contains("..") {
        let parts = value.components(separatedBy: "..").map { Int($0)! }
        return parts[0] ... parts[1]
    } else {
        let v = Int(value)!
        return v ... v
    }
}

var grid = Set<Point>()

for line in readLines() {
    let xy = line.split(separator: ",")
        .map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
        .sorted()
        .map { $0.dropFirst(2) }
        .map { parseRange(String($0)) }
    for y in xy[1] {
        for x in xy[0] {
            grid.insert(Point(x, y))
        }
    }
}

let bounds = grid.boundingRect!.inset(dx: -1, dy: 0)

let down = Point(0, 1)
let left = Point(-1, 0)
let right = Point(1, 0)

let spring = Source(Point(500, 0))
var water = Dictionary<Point, Water>()
var sources = Set([spring])

func drawState() {
    var canvas = Canvas<Character>(bounds.size, fill: ".")
    for pos in grid {
        canvas.paint(at: pos - bounds.origin, color: "#")
    }
    for (pos, type) in water {
        if !bounds.contains(pos) {
            print("WARNING WATER AT", pos, type)
            continue
        }
        canvas.paint(at: pos - bounds.origin, color: type == .flowing ? "|" : "~")
    }
    print(canvas.ascii)
}

func fill(_ pos: Point, _ direction: Point) -> (Bool, Point) {
    var newPos = pos
    while true {
        newPos += direction
        if grid.contains(newPos) {
            return (true, newPos)
        }
        water[newPos] = .flowing
        let below = newPos + down
        if water[below] != .still && !grid.contains(below) {
            return (false, newPos)
        }
    }
}

while !sources.isEmpty {
    var nextSources = Set<Source>()
    source: for source in sources {
        var pos = source.pos + down
        while water[pos] != .still && !grid.contains(pos) {
            water[pos] = .flowing
            pos = pos + down
            if pos.y >= bounds.maxY {
                continue source
            }
        }
        pos -= down
        let (leftEdge, posLeft) = fill(pos, left)
        let (rightEdge, posRight) = fill(pos, right)
        if leftEdge && rightEdge {
            var filledSource = false
            for x in posLeft.x + 1 ... posRight.x - 1 {
                let fillPos = Point(x, pos.y)
                water[fillPos] = .still
                if sources.contains(where: { $0.pos == fillPos }) {
                    filledSource = true
                }
            }
            if filledSource {
                nextSources.insert(source.parent!)
            } else {
                nextSources.insert(source)
            }
        } else {
            if !rightEdge {
                nextSources.insert(Source(posRight, parent: source))
            }
            if !leftEdge {
                nextSources.insert(Source(posLeft, parent: source))
            }
        }
    }
    sources = nextSources
}

// drawState()

let reached = water.filter({ bounds.contains($0.key) }).count
print("Water can reach \(reached) tiles")

let still = water.filter({ $0.value == .still }).count
print("After draining \(still) tiles remain")
