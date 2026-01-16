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
}

// MARK: - String Similarity Algorithms

public struct StringSimilarity {
    
    // MARK: Levenshtein Distance
    
    /// Computes the Levenshtein edit distance between two strings
    /// Returns the minimum number of single-character edits needed
    public static func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
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
                    matrix[i - 1][j] + 1,      // deletion
                    matrix[i][j - 1] + 1,      // insertion
                    matrix[i - 1][j - 1] + cost // substitution
                )
            }
        }
        
        return matrix[m][n]
    }
    
    /// Normalized Levenshtein similarity (0.0 to 1.0)
    public static func levenshteinSimilarity(_ s1: String, _ s2: String) -> Double {
        let maxLen = max(s1.count, s2.count)
        if maxLen == 0 { return 1.0 }
        let distance = levenshteinDistance(s1, s2)
        return 1.0 - (Double(distance) / Double(maxLen))
    }
    
    // MARK: Damerau-Levenshtein Distance
    
    /// Computes Damerau-Levenshtein distance (includes transpositions)
    public static func damerauLevenshteinDistance(_ s1: String, _ s2: String) -> Int {
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
                if i > 1 && j > 1 &&
                    s1Array[i - 1] == s2Array[j - 2] &&
                    s1Array[i - 2] == s2Array[j - 1] {
                    matrix[i][j] = min(matrix[i][j], matrix[i - 2][j - 2] + cost)
                }
            }
        }
        
        return matrix[m][n]
    }
    
    /// Normalized Damerau-Levenshtein similarity
    public static func damerauLevenshteinSimilarity(_ s1: String, _ s2: String) -> Double {
        let maxLen = max(s1.count, s2.count)
        if maxLen == 0 { return 1.0 }
        let distance = damerauLevenshteinDistance(s1, s2)
        return 1.0 - (Double(distance) / Double(maxLen))
    }
    
    // MARK: Jaro-Winkler Similarity
    
    /// Computes Jaro similarity
    public static func jaroSimilarity(_ s1: String, _ s2: String) -> Double {
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
    public static func jaroWinklerSimilarity(_ s1: String, _ s2: String, prefixScale: Double = 0.1) -> Double {
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
    public static func tokenSimilarity(_ s1: String, _ s2: String) -> Double {
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
    public static func tokenSortSimilarity(_ s1: String, _ s2: String) -> Double {
        let sorted1 = s1.lowercased().split(separator: " ").sorted().joined(separator: " ")
        let sorted2 = s2.lowercased().split(separator: " ").sorted().joined(separator: " ")
        return levenshteinSimilarity(sorted1, sorted2)
    }
    
    // MARK: Combined Similarity
    
    /// Combined similarity taking the best score from multiple algorithms
    public static func combinedSimilarity(_ s1: String, _ s2: String) -> Double {
        let scores = [
            levenshteinSimilarity(s1, s2),
            damerauLevenshteinSimilarity(s1, s2),
            jaroWinklerSimilarity(s1, s2),
            tokenSortSimilarity(s1, s2)
        ]
        return scores.max() ?? 0.0
    }
    
    /// Compute similarity using the specified algorithm
    public static func similarity(
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
        }
    }
}

