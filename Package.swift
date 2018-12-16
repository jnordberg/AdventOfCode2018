// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "AdventOfCode2018",
    products: [
        .executable(name: "day01", targets: ["Day01"]),
        .executable(name: "day02", targets: ["Day02"]),
        .executable(name: "day03", targets: ["Day03"]),
        .executable(name: "day04", targets: ["Day04"]),
        .executable(name: "day05", targets: ["Day05"]),
        .executable(name: "day06", targets: ["Day06"]),
        .executable(name: "day07", targets: ["Day07"]),
        .executable(name: "day08", targets: ["Day08"]),
        .executable(name: "day09", targets: ["Day09"]),
        .executable(name: "day10", targets: ["Day10"]),
        .executable(name: "day11", targets: ["Day11"]),
        .executable(name: "day12", targets: ["Day12"]),
        .executable(name: "day13", targets: ["Day13"]),
        .executable(name: "day14", targets: ["Day14"]),
        .executable(name: "day15", targets: ["Day15"]),
    ],
    dependencies: [
        .package(url: "https://github.com/getGuaka/Regex.git", .branch("master")),
    ],
    targets: [
        .target(name: "Day01", dependencies: ["Utils"]),
        .target(name: "Day02", dependencies: ["Utils"]),
        .target(name: "Day03", dependencies: ["Utils", "Regex"]),
        .target(name: "Day04", dependencies: ["Utils"]),
        .target(name: "Day05", dependencies: ["Utils"]),
        .target(name: "Day06", dependencies: ["Utils"]),
        .target(name: "Day07", dependencies: ["Utils"]),
        .target(name: "Day08", dependencies: ["Utils"]),
        .target(name: "Day09", dependencies: ["Utils"]),
        .target(name: "Day10", dependencies: ["Utils", "Regex"]),
        .target(name: "Day11", dependencies: ["Utils"]),
        .target(name: "Day12", dependencies: ["Utils"]),
        .target(name: "Day13", dependencies: ["Utils"]),
        .target(name: "Day14", dependencies: ["Utils"]),
        .target(name: "Day15", dependencies: ["Utils"]),
        .target(name: "Utils", dependencies: []),
    ]
)
