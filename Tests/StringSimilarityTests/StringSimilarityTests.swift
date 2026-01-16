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

private func isApproximatelyEqual(_ a: Double, _ b: Double, tolerance: Double) -> Bool {
    abs(a - b) <= tolerance
}