// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "AdventOfCode2018",
    products: [
        .executable(name: "day1", targets: ["Day1"]),
        .executable(name: "day2", targets: ["Day2"]),
        .executable(name: "day3", targets: ["Day3"]),
        .executable(name: "day4", targets: ["Day4"]),
        .executable(name: "day5", targets: ["Day5"]),
        .executable(name: "day6", targets: ["Day6"]),
        .executable(name: "day7", targets: ["Day7"]),
        .executable(name: "day8", targets: ["Day8"]),
        .executable(name: "day9", targets: ["Day9"]),
        .executable(name: "day10", targets: ["Day10"]),
        .executable(name: "day11", targets: ["Day11"]),
        .executable(name: "day12", targets: ["Day12"]),
        .executable(name: "day13", targets: ["Day13"]),
        .executable(name: "day14", targets: ["Day14"]),
    ],
    dependencies: [
        .package(url: "https://github.com/getGuaka/Regex.git", .branch("master")),
    ],
    targets: [
        .target(name: "Day1", dependencies: ["Utils"]),
        .target(name: "Day2", dependencies: ["Utils"]),
        .target(name: "Day3", dependencies: ["Utils", "Regex"]),
        .target(name: "Day4", dependencies: ["Utils"]),
        .target(name: "Day5", dependencies: ["Utils"]),
        .target(name: "Day6", dependencies: ["Utils"]),
        .target(name: "Day7", dependencies: ["Utils"]),
        .target(name: "Day8", dependencies: ["Utils"]),
        .target(name: "Day9", dependencies: ["Utils"]),
        .target(name: "Day10", dependencies: ["Utils", "Regex"]),
        .target(name: "Day11", dependencies: ["Utils"]),
        .target(name: "Day12", dependencies: ["Utils"]),
        .target(name: "Day13", dependencies: ["Utils"]),
        .target(name: "Day14", dependencies: ["Utils"]),
        .target(name: "Utils", dependencies: []),
    ]
)
