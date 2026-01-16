import Benchmark
import StringSimilarity

let benchmarks : @Sendable () -> Void  = {
    let sentence1 = "hello world"
    let sentence2 = "world hello"

    let sentence3 = "the quick brown fox"
    let sentence4 = "brown fox quick the"

    let longSentence1 = "apple banana cherry date elderberry fig grape honeydew"
    let longSentence2 = "honeydew grape fig elderberry date cherry banana apple"

    let partialMatch1 = "apple banana cherry"
    let partialMatch2 = "apple banana date"

    Benchmark("Token Similarity - Short Sentences") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSimilarity(sentence1, sentence2))
        }
    }

    Benchmark("Token Similarity - Medium Sentences") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSimilarity(sentence3, sentence4))
        }
    }

    Benchmark("Token Similarity - Long Sentences") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSimilarity(longSentence1, longSentence2))
        }
    }

    Benchmark("Token Similarity - Partial Match") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSimilarity(partialMatch1, partialMatch2))
        }
    }

    Benchmark("Token Sort Similarity - Short Sentences") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSortSimilarity(sentence1, sentence2))
        }
    }

    Benchmark("Token Sort Similarity - Medium Sentences") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSortSimilarity(sentence3, sentence4))
        }
    }

    Benchmark("Token Sort Similarity - Long Sentences") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSortSimilarity(longSentence1, longSentence2))
        }
    }

    Benchmark("Token Sort Similarity - Partial Match") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(tokenSortSimilarity(partialMatch1, partialMatch2))
        }
    }
}
