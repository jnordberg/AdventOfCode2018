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
        .target(name: "Utils", dependencies: []),
    ]
)
