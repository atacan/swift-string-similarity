import Benchmark
import StringSimilarity

let benchmarks : @Sendable () -> Void = {
    let shortString1 = "kitten"
    let shortString2 = "sitting"

    let mediumString1 = "the quick brown fox jumps over the lazy dog"
    let mediumString2 = "the quick brown cat jumps over the lazy dog"

    let longString1 = String(repeating: "abcdefghij", count: 50)
    let longString2 = String(repeating: "abcdefghik", count: 50)

    let reorderedSentence1 = "apple banana cherry"
    let reorderedSentence2 = "cherry banana apple"

    Benchmark("Combined Similarity - Short Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(combinedSimilarity(shortString1, shortString2))
        }
    }

    Benchmark("Combined Similarity - Medium Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(combinedSimilarity(mediumString1, mediumString2))
        }
    }

    Benchmark("Combined Similarity - Long Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(combinedSimilarity(longString1, longString2))
        }
    }

    Benchmark("Combined Similarity - Reordered Words") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(combinedSimilarity(reorderedSentence1, reorderedSentence2))
        }
    }

    Benchmark("similarity() with .levenshtein - Medium") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(similarity(mediumString1, mediumString2, algorithm: .levenshtein))
        }
    }

    Benchmark("similarity() with .damerauLevenshtein - Medium") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(similarity(mediumString1, mediumString2, algorithm: .damerauLevenshtein))
        }
    }

    Benchmark("similarity() with .jaroWinkler - Medium") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(similarity(mediumString1, mediumString2, algorithm: .jaroWinkler))
        }
    }

    Benchmark("similarity() with .tokenBased - Medium") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(similarity(mediumString1, mediumString2, algorithm: .tokenBased))
        }
    }

    Benchmark("similarity() with .combined - Medium") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(similarity(mediumString1, mediumString2, algorithm: .combined))
        }
    }
}
