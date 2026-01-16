import Testing
@testable import StringSimilarity

@Test func testLevenshteinDistance() {
    #expect(levenshteinDistance("", "sitting") == 7)
    #expect(levenshteinDistance("kitten", "") == 6)
    #expect(levenshteinDistance("kitten", "sitting") == 3)
    #expect(levenshteinDistance("saturday", "sunday") == 3)
    #expect(levenshteinDistance("君子和而不同", "小人同而不和") == 4)
}

@Test func testDamerauLevenshteinDistance() {
    #expect(damerauLevenshteinDistance("", "sitting") == 7)
    #expect(damerauLevenshteinDistance("kitten", "") == 6)
    #expect(damerauLevenshteinDistance("kitten", "sitting") == 3)
    #expect(damerauLevenshteinDistance("CA", "AC") == 1)
    #expect(damerauLevenshteinDistance("specter", "spectre") == 1)
    #expect(damerauLevenshteinDistance("CA", "ABC") == 3)  // OSA variant
    #expect(damerauLevenshteinDistance("君子和而不同", "小人同而不和") == 4)
}

@Test func testJaroWinklerSimilarity() {
    #expect(jaroWinklerSimilarity("", "") == 1.0)
    #expect(jaroWinklerSimilarity("", "Yo") == 0.0)
    #expect(jaroWinklerSimilarity("search", "find") == 0.0)
    #expect(jaroWinklerSimilarity("search", "search") == 1.0)
    #expect(isApproximatelyEqual(jaroWinklerSimilarity("MARTHA", "MARHTA"), 0.961, tolerance: 0.001))
    #expect(isApproximatelyEqual(jaroWinklerSimilarity("DWAYNE", "DUANE"), 0.84, tolerance: 0.001))
    #expect(isApproximatelyEqual(jaroWinklerSimilarity("DIXON", "DICKSONX"), 0.814, tolerance: 0.001))
    #expect(isApproximatelyEqual(jaroWinklerSimilarity("kitten", "sitting"), 0.746, tolerance: 0.001))
    #expect(isApproximatelyEqual(jaroWinklerSimilarity("君子和而不同", "小人同而不和"), 0.555, tolerance: 0.001))
}

@Test func testLevenshteinSimilarity() {
    #expect(levenshteinSimilarity("", "") == 1.0)
    #expect(levenshteinSimilarity("abc", "abc") == 1.0)
    #expect(levenshteinSimilarity("", "abc") == 0.0)
    #expect(isApproximatelyEqual(levenshteinSimilarity("kitten", "sitting"), 1.0 - 3.0/7.0, tolerance: 0.001))
}

@Test func testDamerauLevenshteinSimilarity() {
    #expect(damerauLevenshteinSimilarity("", "") == 1.0)
    #expect(damerauLevenshteinSimilarity("abc", "abc") == 1.0)
    #expect(damerauLevenshteinSimilarity("CA", "AC") == 0.5)
}

@Test func testTokenSimilarity() {
    #expect(tokenSimilarity("hello world", "world hello") == 1.0)
    #expect(tokenSimilarity("", "") == 1.0)
    #expect(tokenSimilarity("hello", "") == 0.0)
    #expect(isApproximatelyEqual(tokenSimilarity("hello world", "hello"), 0.5, tolerance: 0.001))
}

@Test func testSimilarityAlgorithmEnum() {
    #expect(similarity("kitten", "sitting", algorithm: .levenshtein) == levenshteinSimilarity("kitten", "sitting"))
    #expect(similarity("CA", "AC", algorithm: .damerauLevenshtein) == damerauLevenshteinSimilarity("CA", "AC"))
    #expect(similarity("MARTHA", "MARHTA", algorithm: .jaroWinkler) == jaroWinklerSimilarity("MARTHA", "MARHTA"))
}

@Test func testHammingDistance() {
    #expect(hammingDistance("karolin", "kathrin") == 3)
    #expect(hammingDistance("karolin", "kerstin") == 3)
    #expect(hammingDistance("1011101", "1001001") == 2)
    #expect(hammingDistance("2173896", "2233796") == 3)
    #expect(hammingDistance("", "") == 0)
    #expect(hammingDistance("abc", "abcd") == nil)  // Different lengths
}

@Test func testMostFreqKDistance() {
    // Distance based on frequency difference of K most frequent characters
    #expect(mostFreqKDistance("", "") == 0)
    #expect(mostFreqKDistance("abc", "") == 6)  // 3 chars * k=2
    #expect(mostFreqKDistance("aaaaabbbb", "ababababa", k: 2) == 0)  // Same top-2: a(5), b(4)
    #expect(mostFreqKDistance("abc", "abc", k: 2) == 0)
    #expect(mostFreqKDistance("aabb", "aacc", k: 2) == 4)  // a matches (0), b not in s2 (+2), c not in s1 (+2)
    #expect(mostFreqKDistance("hello", "world", k: 2) == 3)  // l: |2-1|=1, e not in s2 (+1), d not in s1 (+1)
}

@Test func testNormalizedMostFreqKSimilarity() {
    // Cosine similarity on normalized K most frequent character vectors
    #expect(normalizedMostFreqKSimilarity("", "") == 1.0)
    #expect(normalizedMostFreqKSimilarity("abc", "") == 0.0)
    #expect(normalizedMostFreqKSimilarity("my", "a", k: 2) == 0.0)  // No overlap in top-K
    #expect(isApproximatelyEqual(normalizedMostFreqKSimilarity("aaaaabbbb", "ababababa", k: 2), 1.0, tolerance: 0.001))
    #expect(isApproximatelyEqual(normalizedMostFreqKSimilarity("abc", "abc", k: 2), 1.0, tolerance: 0.001))
    #expect(isApproximatelyEqual(normalizedMostFreqKSimilarity("research", "seeking", k: 2), 0.632, tolerance: 0.001))
}

private func isApproximatelyEqual(_ a: Double, _ b: Double, tolerance: Double) -> Bool {
    abs(a - b) <= tolerance
}