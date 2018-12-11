import Utils

let points = readLines().map { Point($0)! }
let bounds = points.boundingRect!
let gridPoints = bounds.inset(by: -1).points
var grid = Dictionary<Point, [(target: Point, distance: UInt)]>(minimumCapacity: gridPoints.count)

for point in gridPoints {
    let distances = points
        .map { (target: $0, distance: $0.distance(to: point)) }
        .sorted { $0.distance < $1.distance }
    grid[point] = distances
}

var areas = Dictionary<Point, (infinite: Bool, size: Int)>(minimumCapacity: points.count)

for (point, distances) in grid {
    guard distances[0].distance < distances[1].distance else {
        continue
    }

    let areaPoint = distances[0].target
    areas[areaPoint, default: (false, 0)].size += 1
    if !bounds.contains(point) {
        areas[areaPoint]!.infinite = true
    }
}

let area = areas
    .filter { !$0.value.infinite }
    .map { $0.value.size }
    .sorted()
    .last!

print("Largest finite area: \(area)")

var safePoints = Set<Point>()

for (point, distances) in grid {
    let total = distances.reduce(0) { $0 + $1.distance }
    if total < 10000 {
        safePoints.insert(point)
    }
}

print("Safe region area: \(safePoints.count)")
