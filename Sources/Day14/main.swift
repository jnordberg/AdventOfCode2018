import Utils

let number = Int(readLine()!)!

var elf1 = 0, elf2 = 1
var recipes = [3, 7]

while recipes.count < 30_000_000 {
    let sum = recipes[elf1] + recipes[elf2]
    recipes.append(contentsOf: sum.digits)
    elf1 = (elf1 + 1 + recipes[elf1]) % recipes.count
    elf2 = (elf2 + 1 + recipes[elf2]) % recipes.count
    if recipes.count == number + 10 {
        print("Part 1: \(recipes.suffix(10).reduce("", { $0 + String($1) }))")
    }
}

let digits = ArraySlice(number.digits)
let n = digits.count
for i in 0 ..< recipes.count - n {
    if recipes[i ..< i + n] == digits {
        print("Part 2: \(i)")
        break
    }
}
