import Foundation
import Utils

struct Marble {
    let value: Int
    var prev: Int
    var next: Int
}

func play(_ numPlayers: Int, _ lastMarble: Int) -> Int {
    var scores = Dictionary<Int, Int>()
    var current: Int = 0
    var placed: [Marble] = [Marble(value: 0, prev: 0, next: 0)]
    var player: Int = -1
    for marble in 1 ... lastMarble {
        player = (player + 1) % numPlayers
        if marble % 23 == 0 {
            for _ in 1 ... 7 {
                current = placed[current].prev
            }
            let removed = placed[current]
            placed[removed.next].prev = removed.prev
            placed[removed.prev].next = removed.next
            scores[player, default: 0] += marble + removed.value
            current = removed.next
        } else {
            current = placed[current].next
            let next = placed[current].next
            let prev = current
            let index = placed.count
            placed.append(Marble(value: marble, prev: prev, next: next))
            placed[next].prev = index
            placed[prev].next = index
            current = index
        }
    }
    return scores.values.sorted().last ?? 0
}

let input = readLine()!.split(separator: " ").compactMap { Int($0) }
let players = input[0]
let lastMarble = input[1]

print("First game: \(play(players, lastMarble))")
print("Second game: \(play(players, lastMarble * 100))")
