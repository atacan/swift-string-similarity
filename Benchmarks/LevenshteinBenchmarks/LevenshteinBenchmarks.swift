import Benchmark
import StringSimilarity

let benchmarks : @Sendable () -> Void  = {
    let shortString1 = "kitten"
    let shortString2 = "sitting"

    let mediumString1 = "the quick brown fox jumps over the lazy dog"
    let mediumString2 = "the quick brown cat jumps over the lazy dog"

    let longString1 = String(repeating: "abcdefghij", count: 50)
    let longString2 = String(repeating: "abcdefghik", count: 50)

    Benchmark("Levenshtein Distance - Short Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(levenshteinDistance(shortString1, shortString2))
        }
    }

    Benchmark("Levenshtein Distance - Medium Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(levenshteinDistance(mediumString1, mediumString2))
        }
    }

    Benchmark("Levenshtein Distance - Long Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(levenshteinDistance(longString1, longString2))
        }
    }

    Benchmark("Levenshtein Similarity - Short Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(levenshteinSimilarity(shortString1, shortString2))
        }
    }

    Benchmark("Levenshtein Similarity - Medium Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(levenshteinSimilarity(mediumString1, mediumString2))
        }
    }

    Benchmark("Levenshtein Similarity - Long Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(levenshteinSimilarity(longString1, longString2))
        }
    }
}
