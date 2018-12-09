// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "AdventOfCode2018",
    products: [
        .executable(name: "day1", targets: ["Day1"]),
        .executable(name: "day2", targets: ["Day2"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Day1", dependencies: ["Utils"]),
        .target(name: "Day2", dependencies: ["Utils"]),
        .target(name: "Utils", dependencies: []),
    ]
)
