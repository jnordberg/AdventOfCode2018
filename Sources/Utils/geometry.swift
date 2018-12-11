import Foundation

public struct Point: Hashable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init?(_ string: String) {
        let parts = string
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: CharacterSet.decimalDigits.inverted) }
            .compactMap { Int($0) }
        guard parts.count == 2 else {
            return nil
        }
        x = parts[0]
        y = parts[1]
    }

    public func distance(to other: Point) -> UInt {
        return (x - other.x).magnitude + (y - other.y).magnitude
    }
}

extension Point: CustomStringConvertible {
    public var description: String {
        return "(\(x), \(y))"
    }
}

extension Collection where Element == Point {
    public var boundingRect: Rect? {
        guard
            let minX = map({ $0.x }).min(),
            let maxX = map({ $0.x }).max(),
            let minY = map({ $0.y }).min(),
            let maxY = map({ $0.y }).max()
        else { return nil }
        return Rect(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
}

public struct Size {
    public let width: Int
    public let height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

public struct Rect {
    public let origin: Point
    public let size: Size

    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    public init(minX: Int, minY: Int, maxX: Int, maxY: Int) {
        origin = Point(x: minX, y: minY)
        size = Size(width: maxX - minX, height: maxY - minY)
    }

    var minX: Int { return origin.x }
    var minY: Int { return origin.y }
    var maxX: Int { return origin.x + size.width }
    var maxY: Int { return origin.y + size.height }

    public var points: [Point] {
        var rv = Array<Point>()
        for x in minX ..< maxX {
            for y in minY ..< maxY {
                rv.append(Point(x: x, y: y))
            }
        }
        return rv
    }

    public var cgRect: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }

    public func intersects(_ other: Rect) -> Bool {
        return !(minX > other.maxX || maxX < other.minX ||
            minY > other.maxY || maxY < other.minY)
    }

    public func contains(_ point: Point) -> Bool {
        return minX <= point.x && minY <= point.y &&
            maxX >= point.x && maxY >= point.y
    }

    /// Return a rect that is shrunk or expanded around its midpoint.
    public func inset(by delta: Int) -> Rect {
        return Rect(
            origin: Point(x: origin.x + delta, y: origin.y + delta),
            size: Size(width: size.width - delta * 2, height: size.height - delta * 2)
        )
    }
}
