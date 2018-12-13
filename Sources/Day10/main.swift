import Foundation
import Regex
import Utils

struct Canvas<Pixel> {
    let size: Size
    var pixels: [Pixel]

    init(_ size: Size, fill: Pixel) {
        self.size = size
        pixels = Array<Pixel>(repeating: fill, count: size.width * size.height)
    }

    func index(for pos: Point) -> Int {
        return pos.y * size.width + pos.x
    }

    mutating func paint(at pos: Point, color: Pixel) {
        pixels[index(for: pos)] = color
    }
}

extension Canvas: CustomStringConvertible where Pixel == Bool {
    var description: String {
        var rv = ""
        for (i, v) in pixels.enumerated() {
            rv += v ? "#" : "."
            if i % size.width == size.width - 1 {
                rv += "\n"
            }
        }
        return rv
    }
}

struct Light {
    static let pattern = try! Regex(pattern: "^position=<(.*)> velocity=<(.*)>$")

    var position: Point
    var velocity: Point

    init(_ string: String) {
        let data = Light.pattern.captures(string: string)
            .map { $0.string }
            .flatMap { $0.split(separator: ",") }
            .map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
            .compactMap { Int($0) }
        position = Point(x: data[0], y: data[1])
        velocity = Point(x: data[2], y: data[3])
    }
}

extension Array where Element == Light {
    var positions: [Point] {
        return self.map { $0.position }
    }

    mutating func simulate(steps: Int = 1) {
        for _ in 1 ... steps {
            for i in startIndex ..< endIndex {
                self[i].position = self[i].position + self[i].velocity
            }
        }
    }

    mutating func unsimulate(steps: Int = 1) {
        for _ in 1 ... steps {
            for i in startIndex ..< endIndex {
                self[i].position = self[i].position - self[i].velocity
            }
        }
    }

    func draw() -> Canvas<Bool> {
        let bounds = positions.boundingRect!.inset(by: -1)
        var canvas = Canvas<Bool>(bounds.size, fill: false)
        for pos in positions {
            canvas.paint(at: pos - bounds.origin, color: true)
        }
        return canvas
    }
}

var lights = readLines().map { Light($0) }

let initialSteps = 10000
lights.simulate(steps: initialSteps)

var best = Int.max
var last: Int
var steps = initialSteps
repeat {
    lights.simulate()
    steps += 1
    let area = lights.positions.boundingRect!.area
    last = best
    if best > area {
        best = area
    }
} while best < last

lights.unsimulate(steps: 1)
print("Message: \n\(lights.draw())")
print("Total seconds: \(steps - 1)")
