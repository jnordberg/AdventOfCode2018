import Foundation
import Regex
import Utils

struct Claim: Equatable {
    static let pattern = try! Regex(pattern: "^#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)$")

    static func == (lhs: Claim, rhs: Claim) -> Bool {
        return lhs.id == rhs.id
    }

    let id: Int
    let rect: Rect

    init(_ string: String) {
        let c = Claim.pattern.captures(string: string).map { Int($0.string)! }
        id = c[0]
        rect = Rect(origin: Point(x: c[1], y: c[2]), size: Size(width: c[3], height: c[4]))
    }
}

let claims = readLines().map { Claim($0) }

var fabric = Dictionary<Point, Int>()
for claim in claims {
    for point in claim.rect.points {
        fabric.increment(point)
    }
}

let area = fabric
    .filter { $0.value > 1 }
    .count

print("Area of overlapping claims: \(area)")

for claim in claims {
    let hasIntersection = claims.contains { $0 != claim && $0.rect.intersects(claim.rect) }
    if !hasIntersection {
        print("Non-overlapping claim: \(claim.id)")
        break
    }
}
