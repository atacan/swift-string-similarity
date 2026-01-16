import Benchmark
import StringSimilarity

let benchmarks : @Sendable () -> Void  = {
    let shortString1 = "kitten"
    let shortString2 = "sitting"

    let transposedString1 = "algorithm"
    let transposedString2 = "algortihm"

    let mediumString1 = "the quick brown fox jumps over the lazy dog"
    let mediumString2 = "teh quick brown fox jumsp over the lazy dog"

    let longString1 = String(repeating: "abcdefghij", count: 50)
    let longString2 = String(repeating: "abcdefghik", count: 50)

    Benchmark("Damerau-Levenshtein Distance - Short Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinDistance(shortString1, shortString2))
        }
    }

    Benchmark("Damerau-Levenshtein Distance - Transposed Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinDistance(transposedString1, transposedString2))
        }
    }

    Benchmark("Damerau-Levenshtein Distance - Medium Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinDistance(mediumString1, mediumString2))
        }
    }

    Benchmark("Damerau-Levenshtein Distance - Long Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinDistance(longString1, longString2))
        }
    }

    Benchmark("Damerau-Levenshtein Similarity - Short Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinSimilarity(shortString1, shortString2))
        }
    }

    Benchmark("Damerau-Levenshtein Similarity - Transposed Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinSimilarity(transposedString1, transposedString2))
        }
    }

    Benchmark("Damerau-Levenshtein Similarity - Medium Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinSimilarity(mediumString1, mediumString2))
        }
    }

    Benchmark("Damerau-Levenshtein Similarity - Long Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(damerauLevenshteinSimilarity(longString1, longString2))
        }
    }
}
