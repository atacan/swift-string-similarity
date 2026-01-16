// import Foundation

/// Algorithm for computing string similarity
public enum SimilarityAlgorithm: Equatable, CaseIterable {
    /// Levenshtein distance normalized by max string length
    /// Good general-purpose algorithm, handles insertions/deletions/substitutions
    case levenshtein

    /// Damerau-Levenshtein distance (includes transpositions)
    /// Better for typing/transcription errors where letters get swapped
    case damerauLevenshtein

    /// Jaro-Winkler similarity
    /// Better for short strings, gives more weight to prefix matches
    case jaroWinkler

    /// Token-based matching (order-independent word comparison)
    /// Good when word order might vary
    case tokenBased

    /// Combination of multiple algorithms (takes the best score)
    case combined

    /// Hamming distance (only for equal-length strings)
    /// Counts positions where characters differ
    case hamming

    /// MostFreqK distance
    /// Compares strings based on their K most frequent characters
    case mostFreqK

    /// Normalized MostFreqK distance (0.0 to 1.0)
    case normalizedMostFreqK
}

// MARK: - String Similarity Algorithms

// MARK: Levenshtein Distance

/// Computes the Levenshtein edit distance between two strings
/// Returns the minimum number of single-character edits needed
public func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
    let s1Array = Array(s1)
    let s2Array = Array(s2)
    let m = s1Array.count
    let n = s2Array.count

    // Handle empty strings
    if m == 0 { return n }
    if n == 0 { return m }

    // Create distance matrix
    var matrix = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)

    // Initialize first row and column
    for i in 0...m { matrix[i][0] = i }
    for j in 0...n { matrix[0][j] = j }

    // Fill in the matrix
    for i in 1...m {
        for j in 1...n {
            let cost = s1Array[i - 1] == s2Array[j - 1] ? 0 : 1
            matrix[i][j] = min(
                matrix[i - 1][j] + 1,  // deletion
                matrix[i][j - 1] + 1,  // insertion
                matrix[i - 1][j - 1] + cost  // substitution
            )
        }
    }

    return matrix[m][n]
}

/// Normalized Levenshtein similarity (0.0 to 1.0)
public func levenshteinSimilarity(_ s1: String, _ s2: String) -> Double {
    let maxLen = max(s1.count, s2.count)
    if maxLen == 0 { return 1.0 }
    let distance = levenshteinDistance(s1, s2)
    return 1.0 - (Double(distance) / Double(maxLen))
}

// MARK: Damerau-Levenshtein Distance

/// Computes Damerau-Levenshtein distance (includes transpositions)
public func damerauLevenshteinDistance(_ s1: String, _ s2: String) -> Int {
    let s1Array = Array(s1)
    let s2Array = Array(s2)
    let m = s1Array.count
    let n = s2Array.count

    if m == 0 { return n }
    if n == 0 { return m }

    var matrix = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)

    for i in 0...m { matrix[i][0] = i }
    for j in 0...n { matrix[0][j] = j }

    for i in 1...m {
        for j in 1...n {
            let cost = s1Array[i - 1] == s2Array[j - 1] ? 0 : 1

            matrix[i][j] = min(
                matrix[i - 1][j] + 1,
                matrix[i][j - 1] + 1,
                matrix[i - 1][j - 1] + cost
            )

            // Check for transposition
            if i > 1 && j > 1 && s1Array[i - 1] == s2Array[j - 2]
                && s1Array[i - 2] == s2Array[j - 1]
            {
                matrix[i][j] = min(matrix[i][j], matrix[i - 2][j - 2] + cost)
            }
        }
    }

    return matrix[m][n]
}

/// Normalized Damerau-Levenshtein similarity
public func damerauLevenshteinSimilarity(_ s1: String, _ s2: String) -> Double {
    let maxLen = max(s1.count, s2.count)
    if maxLen == 0 { return 1.0 }
    let distance = damerauLevenshteinDistance(s1, s2)
    return 1.0 - (Double(distance) / Double(maxLen))
}

// MARK: Jaro-Winkler Similarity

/// Computes Jaro similarity
public func jaroSimilarity(_ s1: String, _ s2: String) -> Double {
    let s1Array = Array(s1)
    let s2Array = Array(s2)
    let len1 = s1Array.count
    let len2 = s2Array.count

    if len1 == 0 && len2 == 0 { return 1.0 }
    if len1 == 0 || len2 == 0 { return 0.0 }

    // Calculate match window
    let matchDistance = max(len1, len2) / 2 - 1

    var s1Matches = [Bool](repeating: false, count: len1)
    var s2Matches = [Bool](repeating: false, count: len2)

    var matches = 0
    var transpositions = 0

    // Find matches
    for i in 0..<len1 {
        let start = max(0, i - matchDistance)
        let end = min(i + matchDistance + 1, len2)

        for j in start..<end {
            if s2Matches[j] || s1Array[i] != s2Array[j] { continue }
            s1Matches[i] = true
            s2Matches[j] = true
            matches += 1
            break
        }
    }

    if matches == 0 { return 0.0 }

    // Count transpositions
    var k = 0
    for i in 0..<len1 {
        if !s1Matches[i] { continue }
        while !s2Matches[k] { k += 1 }
        if s1Array[i] != s2Array[k] { transpositions += 1 }
        k += 1
    }

    let m = Double(matches)
    let t = Double(transpositions / 2)

    return (m / Double(len1) + m / Double(len2) + (m - t) / m) / 3.0
}

/// Computes Jaro-Winkler similarity (adds prefix bonus)
public func jaroWinklerSimilarity(_ s1: String, _ s2: String, prefixScale: Double = 0.1)
    -> Double
{
    let jaroSim = jaroSimilarity(s1, s2)

    // Calculate common prefix length (up to 4 characters)
    let s1Array = Array(s1.lowercased())
    let s2Array = Array(s2.lowercased())
    var prefixLength = 0

    for i in 0..<min(4, min(s1Array.count, s2Array.count)) {
        if s1Array[i] == s2Array[i] {
            prefixLength += 1
        } else {
            break
        }
    }

    return jaroSim + (Double(prefixLength) * prefixScale * (1.0 - jaroSim))
}

// MARK: Token-Based Similarity

/// Token-based similarity (order-independent word matching)
public func tokenSimilarity(_ s1: String, _ s2: String) -> Double {
    let tokens1 = Set(s1.lowercased().split(separator: " ").map(String.init))
    let tokens2 = Set(s2.lowercased().split(separator: " ").map(String.init))

    if tokens1.isEmpty && tokens2.isEmpty { return 1.0 }
    if tokens1.isEmpty || tokens2.isEmpty { return 0.0 }

    let intersection = tokens1.intersection(tokens2)
    let union = tokens1.union(tokens2)

    // Jaccard similarity
    return Double(intersection.count) / Double(union.count)
}

/// Token sort similarity (sorts tokens before comparing)
public func tokenSortSimilarity(_ s1: String, _ s2: String) -> Double {
    let sorted1 = s1.lowercased().split(separator: " ").sorted().joined(separator: " ")
    let sorted2 = s2.lowercased().split(separator: " ").sorted().joined(separator: " ")
    return levenshteinSimilarity(sorted1, sorted2)
}

// MARK: Combined Similarity

/// Combined similarity taking the best score from multiple algorithms
public func combinedSimilarity(_ s1: String, _ s2: String) -> Double {
    let scores = [
        levenshteinSimilarity(s1, s2),
        damerauLevenshteinSimilarity(s1, s2),
        jaroWinklerSimilarity(s1, s2),
        tokenSortSimilarity(s1, s2),
    ]
    return scores.max() ?? 0.0
}

// MARK: Hamming Distance

/// Computes the Hamming distance between two strings
/// Returns nil if strings have different lengths
public func hammingDistance(_ s1: String, _ s2: String) -> Int? {
    let s1Array = Array(s1)
    let s2Array = Array(s2)

    guard s1Array.count == s2Array.count else { return nil }

    var distance = 0
    for i in 0..<s1Array.count {
        if s1Array[i] != s2Array[i] {
            distance += 1
        }
    }
    return distance
}

/// Normalized Hamming similarity (0.0 to 1.0)
/// Returns nil if strings have different lengths
public func hammingSimilarity(_ s1: String, _ s2: String) -> Double? {
    guard let distance = hammingDistance(s1, s2) else { return nil }
    let length = s1.count
    if length == 0 { return 1.0 }
    return 1.0 - (Double(distance) / Double(length))
}

// MARK: MostFreqK Distance

/// Returns a dictionary of character frequencies for a string
private func characterFrequencies(_ s: String) -> [Character: Int] {
    var freq: [Character: Int] = [:]
    for char in s {
        freq[char, default: 0] += 1
    }
    return freq
}

/// Returns the K most frequent characters with their frequencies
private func mostFrequentK(_ s: String, k: Int) -> [(Character, Int)] {
    let freq = characterFrequencies(s)
    return freq.sorted { $0.value > $1.value || ($0.value == $1.value && $0.key < $1.key) }
        .prefix(k)
        .map { ($0.key, $0.value) }
}

/// Computes the MostFreqK distance between two strings
/// Based on comparing the K most frequent characters in each string
public func mostFreqKDistance(_ s1: String, _ s2: String, k: Int = 2) -> Int {
    if s1.isEmpty && s2.isEmpty { return 0 }
    if s1.isEmpty || s2.isEmpty { return max(s1.count, s2.count) * k }

    let freq1 = mostFrequentK(s1, k: k)
    let freq2 = mostFrequentK(s2, k: k)

    var distance = 0

    // For each character in freq1, find it in freq2 and compute difference
    for (char1, count1) in freq1 {
        if let (_, count2) = freq2.first(where: { $0.0 == char1 }) {
            distance += abs(count1 - count2)
        } else {
            distance += count1
        }
    }

    // For characters in freq2 not in freq1
    for (char2, count2) in freq2 {
        if !freq1.contains(where: { $0.0 == char2 }) {
            distance += count2
        }
    }

    return distance
}

/// MostFreqK similarity (higher is more similar)
public func mostFreqKSimilarity(_ s1: String, _ s2: String, k: Int = 2) -> Double {
    let distance = mostFreqKDistance(s1, s2, k: k)
    let maxPossible = max(s1.count, s2.count) * k
    if maxPossible == 0 { return 1.0 }
    return 1.0 - (Double(distance) / Double(maxPossible))
}

// MARK: Normalized MostFreqK Distance

/// Computes the Normalized MostFreqK similarity
/// Normalizes character frequencies before comparison
public func normalizedMostFreqKSimilarity(_ s1: String, _ s2: String, k: Int = 2) -> Double {
    if s1.isEmpty && s2.isEmpty { return 1.0 }
    if s1.isEmpty || s2.isEmpty { return 0.0 }

    let freq1 = mostFrequentK(s1, k: k)
    let freq2 = mostFrequentK(s2, k: k)

    let total1 = Double(freq1.reduce(0) { $0 + $1.1 })
    let total2 = Double(freq2.reduce(0) { $0 + $1.1 })

    // Normalize frequencies
    var normFreq1: [Character: Double] = [:]
    var normFreq2: [Character: Double] = [:]

    for (char, count) in freq1 {
        normFreq1[char] = Double(count) / total1
    }
    for (char, count) in freq2 {
        normFreq2[char] = Double(count) / total2
    }

    // Compute similarity using cosine-like measure
    var dotProduct = 0.0
    var magnitude1 = 0.0
    var magnitude2 = 0.0

    let allChars = Set(normFreq1.keys).union(Set(normFreq2.keys))

    for char in allChars {
        let v1 = normFreq1[char] ?? 0.0
        let v2 = normFreq2[char] ?? 0.0
        dotProduct += v1 * v2
        magnitude1 += v1 * v1
        magnitude2 += v2 * v2
    }

    let magnitude = magnitude1.squareRoot() * magnitude2.squareRoot()
    if magnitude == 0 { return 0.0 }

    return dotProduct / magnitude
}

/// Compute similarity using the specified algorithm
public func similarity(
    _ s1: String,
    _ s2: String,
    algorithm: SimilarityAlgorithm
) -> Double {
    switch algorithm {
    case .levenshtein:
        return levenshteinSimilarity(s1, s2)
    case .damerauLevenshtein:
        return damerauLevenshteinSimilarity(s1, s2)
    case .jaroWinkler:
        return jaroWinklerSimilarity(s1, s2)
    case .tokenBased:
        return max(tokenSimilarity(s1, s2), tokenSortSimilarity(s1, s2))
    case .combined:
        return combinedSimilarity(s1, s2)
    case .hamming:
        return hammingSimilarity(s1, s2) ?? 0.0
    case .mostFreqK:
        return mostFreqKSimilarity(s1, s2)
    case .normalizedMostFreqK:
        return normalizedMostFreqKSimilarity(s1, s2)
    }
}
