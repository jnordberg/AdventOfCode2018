import Utils

typealias TrackPiece = Character
let validTrackPieces = Set<TrackPiece>(["|", "-", "/", "\\", "+"])

enum Turn {
    case left, right
}

enum Cardinal: Int8 {
    case north, east, south, west

    var vector: Point {
        switch self {
        case .north: return Point(0, -1)
        case .east: return Point(1, 0)
        case .south: return Point(0, 1)
        case .west: return Point(-1, 0)
        }
    }

    func turning(_ direction: Turn) -> Cardinal {
        let dir: Int8 = direction == .left ? -1 : 1
        return Cardinal(rawValue: (4 + rawValue + dir) % 4)!
    }
}

class Cart {
    static var cartSeq = 0

    let id: Int
    var pos: Point
    var facing: Cardinal
    var turnCounter: Int = 0

    init(_ pos: Point, _ facing: Cardinal) {
        Cart.cartSeq += 1
        id = Cart.cartSeq
        self.pos = pos
        self.facing = facing
    }

    func nextTurn() -> Turn? {
        turnCounter += 1
        switch turnCounter % 3 {
        case 0:
            return .right
        case 1:
            return .left
        case 2:
            return nil
        default:
            fatalError("Maths broken, universe collapsing...")
        }
    }

    func intersectionTurn() {
        if let direction = nextTurn() {
            turn(direction)
        }
    }

    func turn(_ direction: Turn) {
        facing = facing.turning(direction)
    }
}

extension Cart: Equatable, Hashable, CustomStringConvertible {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Cart, rhs: Cart) -> Bool {
        return lhs.id == rhs.id
    }

    var description: String {
        return "Cart \(id) - \(pos) \(facing)"
    }
}

var track = Dictionary<Point, TrackPiece>()
var carts = Array<Cart>()

for (y, line) in readLines().enumerated() {
    for (x, char) in line.enumerated() {
        let pos = Point(x, y)
        switch char {
        case " ":
            continue
        case ">":
            carts.append(Cart(pos, .east))
            track[pos] = "-"
        case "<":
            carts.append(Cart(pos, .west))
            track[pos] = "-"
        case "^":
            carts.append(Cart(pos, .north))
            track[pos] = "|"
        case "v":
            carts.append(Cart(pos, .south))
            track[pos] = "|"
        default:
            guard validTrackPieces.contains(char) else {
                fatalError("Invalid track piece: \(char)")
            }
            track[pos] = char
        }
    }
}

var crashed = Set<Cart>()
var active = Set(carts)
repeat {
    carts.sort { (a, b) -> Bool in
        if a.pos.y == b.pos.y {
            return a.pos.x < b.pos.x
        } else {
            return a.pos.y < b.pos.y
        }
    }
    for cart in carts where !crashed.contains(cart) {
        let nextPos = cart.pos + cart.facing.vector
        guard let nextTrack = track[nextPos] else {
            fatalError("Cart ran off track")
        }
        if let other = active.first(where: { $0.pos == nextPos }) {
            if crashed.isEmpty {
                print("First crash at \(cart.pos.x),\(cart.pos.y)")
            }
            crashed.insert(cart)
            crashed.insert(other)
            active.remove(cart)
            active.remove(other)
            continue
        }
        cart.pos = nextPos
        let v = cart.facing == .north || cart.facing == .south
        switch nextTrack {
        case "+":
            cart.intersectionTurn()
        case "\\":
            cart.turn(v ? .left : .right)
        case "/":
            cart.turn(v ? .right : .left)
        default:
            break
        }
    }
} while active.count > 1

let pos = active.first!.pos
print("Last surviving cart is at: \(pos.x),\(pos.y)")
