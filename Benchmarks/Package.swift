// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-string-similarity-benchmark",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark", from: "1.0.0"),
        .package(path: "../"),
    ],
    targets: [
        .executableTarget(
            name: "LevenshteinBenchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "StringSimilarity", package: "swift-string-similarity"),
            ],
            path: "LevenshteinBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
        .executableTarget(
            name: "DamerauLevenshteinBenchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "StringSimilarity", package: "swift-string-similarity"),
            ],
            path: "DamerauLevenshteinBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
        .executableTarget(
            name: "JaroWinklerBenchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "StringSimilarity", package: "swift-string-similarity"),
            ],
            path: "JaroWinklerBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
        .executableTarget(
            name: "TokenBasedBenchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "StringSimilarity", package: "swift-string-similarity"),
            ],
            path: "TokenBasedBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
        .executableTarget(
            name: "CombinedBenchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "StringSimilarity", package: "swift-string-similarity"),
            ],
            path: "CombinedBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
    ]
)
