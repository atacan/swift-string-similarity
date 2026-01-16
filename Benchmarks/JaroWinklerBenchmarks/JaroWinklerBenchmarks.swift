import Benchmark
import StringSimilarity

let benchmarks : @Sendable () -> Void  = {
    let shortString1 = "MARTHA"
    let shortString2 = "MARHTA"

    let prefixMatch1 = "DWAYNE"
    let prefixMatch2 = "DUANE"

    let mediumString1 = "the quick brown fox jumps over the lazy dog"
    let mediumString2 = "the quick brown cat jumps over the lazy dog"

    let longString1 = String(repeating: "abcdefghij", count: 50)
    let longString2 = String(repeating: "abcdefghik", count: 50)

    Benchmark("Jaro Similarity - Short Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroSimilarity(shortString1, shortString2))
        }
    }

    Benchmark("Jaro Similarity - Prefix Match") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroSimilarity(prefixMatch1, prefixMatch2))
        }
    }

    Benchmark("Jaro Similarity - Medium Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroSimilarity(mediumString1, mediumString2))
        }
    }

    Benchmark("Jaro Similarity - Long Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroSimilarity(longString1, longString2))
        }
    }

    Benchmark("Jaro-Winkler Similarity - Short Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroWinklerSimilarity(shortString1, shortString2))
        }
    }

    Benchmark("Jaro-Winkler Similarity - Prefix Match") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroWinklerSimilarity(prefixMatch1, prefixMatch2))
        }
    }

    Benchmark("Jaro-Winkler Similarity - Medium Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroWinklerSimilarity(mediumString1, mediumString2))
        }
    }

    Benchmark("Jaro-Winkler Similarity - Long Strings") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(jaroWinklerSimilarity(longString1, longString2))
        }
    }
}
