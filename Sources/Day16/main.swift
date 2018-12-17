import Foundation
import Utils

enum Opcode: CaseIterable {
    /// (add register) stores into register C the result of adding register A and register B.
    case addr
    /// (add immediate) stores into register C the result of adding register A and value B.
    case addi
    /// (multiply register) stores into register C the result of multiplying register A and register B.
    case mulr
    /// (multiply immediate) stores into register C the result of multiplying register A and value B.
    case muli
    /// (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    case banr
    /// (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
    case bani
    /// (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    case borr
    /// (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
    case bori
    /// (set register) copies the contents of register A into register C. (Input B is ignored.)
    case setr
    /// (set immediate) stores value A into register C. (Input B is ignored.)
    case seti
    /// (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    case gtir
    /// (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
    case gtri
    /// (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
    case gtrr
    /// (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    case eqir
    /// (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    case eqri
    /// (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    case eqrr
}

struct Instruction {
    let opcode: Int
    let a: Int
    let b: Int
    let c: Int
    init(_ string: String) {
        let r = string.split(separator: " ")
            .map { $0.trimmingCharacters(in: CharacterSet.decimalDigits.inverted) }
            .compactMap { Int($0) }
        opcode = r[0]
        a = r[1]
        b = r[2]
        c = r[3]
    }
}

extension Array where Element == Int {
    init(_ string: String) {
        self = string.split(separator: ",")
            .map { $0.trimmingCharacters(in: CharacterSet.decimalDigits.inverted) }
            .compactMap { Int($0) }
    }
}

typealias Register = Array<Int>

struct Sample {
    let before: Register
    let instr: Instruction
    let after: Register
}

enum InputType {
    case before, after, instruction
}

let input = Dictionary(grouping: readLines().filter({ $0.count > 0 })) { line -> InputType in
    if line.contains("Before:") {
        return .before
    } else if line.contains("After:") {
        return .after
    } else {
        return .instruction
    }
}

var samples = Array<Sample>()
for idx in 0 ..< input[.before]!.count {
    samples.append(Sample(
        before: Register(input[.before]![idx]),
        instr: Instruction(input[.instruction]![idx]),
        after: Register(input[.after]![idx])
    ))
}

func exec(op: Opcode, a: Int, b: Int, c: Int, reg: inout Register) {
    let valA = a
    let valB = b
    let regA = reg[a]
    let regB = reg[b]
    var out: Int
    switch op {
    case .addr:
        out = regA + regB
    case .addi:
        out = regA + valB
    case .mulr:
        out = regA * regB
    case .muli:
        out = regA * valB
    case .banr:
        out = regA & regB
    case .bani:
        out = regA & valB
    case .borr:
        out = regA | regB
    case .bori:
        out = regA | valB
    case .setr:
        out = regA
    case .seti:
        out = valA
    case .gtir:
        out = valA > regB ? 1 : 0
    case .gtri:
        out = regA > valB ? 1 : 0
    case .gtrr:
        out = regA > regB ? 1 : 0
    case .eqir:
        out = valA == regB ? 1 : 0
    case .eqri:
        out = regA == valB ? 1 : 0
    case .eqrr:
        out = regA == regB ? 1 : 0
    }
    reg[c] = out
}

func possibleCodes(_ sample: Sample) -> Set<Opcode> {
    var rv = Set<Opcode>()
    for op in Opcode.allCases {
        var reg = sample.before
        exec(op: op, a: sample.instr.a, b: sample.instr.b, c: sample.instr.c, reg: &reg)
        if reg == sample.after {
            rv.insert(op)
        }
    }
    return rv
}

print("Part 1:", samples.filter { possibleCodes($0).count >= 3 }.count)

var possible = Dictionary<Int, [Set<Opcode>]>()
for sample in samples {
    possible[sample.instr.opcode, default: []].append(possibleCodes(sample))
}

var codeLookup = Dictionary<Int, Opcode>()
while codeLookup.count != 16 {
    for (code, sets) in possible {
        if codeLookup[code] != nil {
            continue
        }
        var codes = sets.first!
        for set in sets.suffix(from: 1) {
            codes = codes.intersection(set)
        }
        let found = Set(codeLookup.values)
        codes.subtract(found)
        if codes.count == 1 {
            codeLookup[code] = codes.first!
        }
    }
}

let program = input[.instruction]!.suffix(from: input[.before]!.count).map { Instruction($0) }

var register = [0, 0, 0, 0]
for instr in program {
    guard let op = codeLookup[instr.opcode] else {
        fatalError("Unknown ocode")
    }
    exec(op: op, a: instr.a, b: instr.b, c: instr.c, reg: &register)
}

print("Part 2: \(register[0])")
