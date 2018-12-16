/// Read all lines from stdin until EOF.
public func readLines() -> [String] {
    var rv = Array<String>()
    while let line = readLine() {
        rv.append(line)
    }
    return rv
}

public struct Canvas<Pixel> {
    public let size: Size
    public var pixels: [Pixel]

    public init(_ size: Size, fill: Pixel) {
        self.size = size
        pixels = Array<Pixel>(repeating: fill, count: size.width * size.height)
    }

    public func index(for pos: Point) -> Int {
        return pos.y * size.width + pos.x
    }

    public mutating func paint(at pos: Point, color: Pixel) {
        pixels[index(for: pos)] = color
    }

    fileprivate func renderAscii(_ resolve: (Pixel) -> Character) -> String {
        var lines = Array<String>()
        var line = Array<Character>()
        for (i, v) in pixels.enumerated() {
            if i != 0 && i % size.width == 0 {
                lines.append(String(line))
                line = []
            }
            line.append(resolve(v))
        }
        lines.append(String(line))
        return lines.joined(separator: "\n")
    }
}

public extension Canvas where Pixel == Bool {
    public var ascii: String {
        return renderAscii { $0 ? "#" : "." }
    }
}

public extension Canvas where Pixel == Character {
    public var ascii: String {
        return renderAscii { $0 }
    }
}
