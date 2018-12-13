import Utils

func getPowerLevel(_ pos: Point, _ serial: Int) -> Int {
    let rackId = pos.x + 10
    var powerLevel = rackId * pos.y
    powerLevel += serial
    powerLevel *= rackId
    return powerLevel / 100 % 10 - 5
}

let serialNumber = Int(readLine()!)!

let gridBounds = Rect(minX: 1, minY: 1, maxX: 301, maxY: 301)
var grid = Dictionary<Point, Int>()
for point in gridBounds.points {
    grid[point] = getPowerLevel(point, serialNumber)
}

let lookupOffset = Point(x: 3, y: 3)
let lookupArea = Size(width: 3, height: 3)

func getGridLevel(_ point: Point) -> Int {
    let lookupBounds = Rect(origin: point, size: Size(width: 3, height: 3))
    let total = lookupBounds.points.reduce(0) { $0 + grid[$1]! }
    return total
}

let bestPoint = gridBounds.inset(by: 3).points.max(by: { (a, b) -> Bool in
    getGridLevel(a - lookupOffset) < getGridLevel(b - lookupOffset)
})! - lookupOffset

print("Best 3x3 power level at: \(bestPoint.x),\(bestPoint.y)")

// Part 2 stolen from reddit because this was killing me... (Swift version of u/tribulu's C++ solution)
var sum = Array(repeating: Array(repeating: 0, count: 301), count: 301)
var bx = 0, by = 0, bs = 0, best = Int.min
for y in 1 ... 300 {
    for x in 1 ... 300 {
        let p = getPowerLevel(Point(x, y), serialNumber)
        sum[y][x] = p + sum[y - 1][x] + sum[y][x - 1] - sum[y - 1][x - 1]
    }
}

for s in 1 ... 300 {
    for y in s ... 300 {
        for x in s ... 300 {
            let total = sum[y][x] - sum[y - s][x] - sum[y][x - s] + sum[y - s][x - s]
            if total > best {
                best = total; bx = x; by = y; bs = s
            }
        }
    }
}

print("Best power level and size: \(bx - bs + 1),\(by - bs + 1),\(bs)")
