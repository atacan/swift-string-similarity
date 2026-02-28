# StringSimilarity

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fatacan%2Fswift-string-similarity%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/atacan/swift-string-similarity)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fatacan%2Fswift-string-similarity%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/atacan/swift-string-similarity)

A lightweight Swift package for computing string similarity and distance metrics. Perfect for fuzzy string matching, typo detection, search suggestions, and text comparison in Swift applications.

**No Foundation dependency** - works everywhere Swift runs.

## Available Algorithms

| Algorithm | Best For | Returns |
|-----------|----------|---------|
| **Levenshtein** | General-purpose string comparison | Distance (Int) / Similarity (Double) |
| **Damerau-Levenshtein** | Typo detection with transpositions | Distance (Int) / Similarity (Double) |
| **Jaro-Winkler** | Short strings, prefix matching | Similarity (Double) |
| **Hamming** | Equal-length strings, binary data | Distance (Int?) / Similarity (Double?) |
| **Token-Based** | Word order variations | Similarity (Double) |
| **MostFreqK** | Character frequency comparison | Distance (Int) / Similarity (Double) |
| **Normalized MostFreqK** | Normalized frequency vectors | Similarity (Double) |
| **Combined** | Best match across algorithms | Similarity (Double) |

## Installation

Add StringSimilarity to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/atacan/swift-string-similarity.git", from: "1.0.0")
]
```

Then add it to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["StringSimilarity"]
)
```

## Quick Start

```swift
import StringSimilarity

// Using the unified API
let score = similarity("hello", "hallo", algorithm: .levenshtein)
// 0.8

// Or use functions directly
let distance = levenshteinDistance("kitten", "sitting")
// 3
```

## Algorithm Examples

### Levenshtein Distance

The classic edit distance algorithm. Counts insertions, deletions, and substitutions needed to transform one string into another.

```swift
import StringSimilarity

// Get raw edit distance
levenshteinDistance("kitten", "sitting")  // 3
levenshteinDistance("book", "back")       // 2

// Get normalized similarity (0.0 to 1.0)
levenshteinSimilarity("hello", "hallo")   // 0.8
levenshteinSimilarity("swift", "swift")   // 1.0
```

### Damerau-Levenshtein Distance

Like Levenshtein but also handles transpositions (swapped adjacent characters). Better for detecting typing errors.

```swift
import StringSimilarity

// Transposition counts as 1 edit, not 2
damerauLevenshteinDistance("CA", "AC")       // 1 (transposition)
levenshteinDistance("CA", "AC")              // 2 (delete + insert)

damerauLevenshteinDistance("specter", "spectre")  // 1
damerauLevenshteinSimilarity("teh", "the")        // 0.667
```

### Jaro-Winkler Similarity

Optimized for short strings. Gives higher scores to strings that match from the beginning (common prefix bonus).

```swift
import StringSimilarity

// Great for name matching
jaroWinklerSimilarity("MARTHA", "MARHTA")   // 0.961
jaroWinklerSimilarity("DWAYNE", "DUANE")    // 0.84

// Jaro without prefix bonus
jaroSimilarity("MARTHA", "MARHTA")          // 0.944

// Custom prefix scale (default is 0.1)
jaroWinklerSimilarity("hello", "helloo", prefixScale: 0.2)
```

### Hamming Distance

Counts positions where characters differ. Only works with equal-length strings.

```swift
import StringSimilarity

// Returns nil for different-length strings
hammingDistance("karolin", "kathrin")  // 3
hammingDistance("1011101", "1001001")  // 2
hammingDistance("abc", "abcd")         // nil

// Normalized similarity
hammingSimilarity("karolin", "kathrin")  // 0.571
```

### Token-Based Similarity

Word-level comparison using Jaccard similarity. Order-independent - great when words might be rearranged.

```swift
import StringSimilarity

// Order doesn't matter
tokenSimilarity("hello world", "world hello")      // 1.0
tokenSimilarity("New York City", "City of New York")  // 0.6

// Token sort: sorts words then compares with Levenshtein
tokenSortSimilarity("John Smith", "Smith John")    // 1.0
```

### MostFreqK Distance

Compares strings based on their K most frequent characters. Useful for detecting similar character distributions.

```swift
import StringSimilarity

// Compare using top 2 most frequent characters (default)
mostFreqKDistance("aaaaabbbb", "ababababa", k: 2)  // 0 (same frequencies)
mostFreqKDistance("hello", "world", k: 2)          // 3

// Normalized similarity
mostFreqKSimilarity("research", "researcher", k: 2)  // high similarity
```

### Normalized MostFreqK Similarity

Uses cosine similarity on normalized character frequency vectors for the K most frequent characters.

```swift
import StringSimilarity

normalizedMostFreqKSimilarity("aaaaabbbb", "ababababa", k: 2)  // 1.0
normalizedMostFreqKSimilarity("abc", "xyz", k: 2)              // 0.0
```

### Combined Similarity

Returns the highest score from Levenshtein, Damerau-Levenshtein, Jaro-Winkler, and Token Sort algorithms.

```swift
import StringSimilarity

// Automatically picks the best matching algorithm
combinedSimilarity("hello world", "world hello")  // 1.0 (from token sort)
combinedSimilarity("hello", "hallo")              // 0.8 (from levenshtein)
```

## Unified API

Use the `similarity()` function with a `SimilarityAlgorithm` enum for a consistent interface:

```swift
import StringSimilarity

let s1 = "swift"
let s2 = "swfit"

similarity(s1, s2, algorithm: .levenshtein)       // 0.6
similarity(s1, s2, algorithm: .damerauLevenshtein) // 0.8
similarity(s1, s2, algorithm: .jaroWinkler)       // 0.967
similarity(s1, s2, algorithm: .hamming)           // 0.6
similarity(s1, s2, algorithm: .combined)          // 0.967

// Iterate over all algorithms
for algorithm in SimilarityAlgorithm.allCases {
    print("\(algorithm): \(similarity(s1, s2, algorithm: algorithm))")
}
```

## Unicode Support

All algorithms fully support Unicode strings:

```swift
levenshteinDistance("cafe", "caf??")           // 1
jaroWinklerSimilarity("??????", "??????")       // 0.889
```

## License

MIT
