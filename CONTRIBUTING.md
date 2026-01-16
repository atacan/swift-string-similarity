# Contributing

## Running Benchmarks

The benchmarks are in a separate Swift package located in the `Benchmarks/` directory.

```bash
cd Benchmarks
```

### Run All Benchmarks

```bash
swift package benchmark
```

### Run a Specific Target

```bash
swift package benchmark --target LevenshteinBenchmarks
```

Available targets:
- `LevenshteinBenchmarks`
- `DamerauLevenshteinBenchmarks`
- `JaroWinklerBenchmarks`
- `TokenBasedBenchmarks`
- `CombinedBenchmarks`

### List Available Benchmarks

```bash
swift package benchmark list
```

### Run a Specific Benchmark by Name

```bash
swift package benchmark --filter "Levenshtein Distance - Short Strings"
```

### Save and Compare Baselines

Save a baseline:
```bash
swift package benchmark baseline write main
```

Compare against a baseline:
```bash
swift package benchmark baseline compare main
```

### Additional Options

For more options, see:
```bash
swift package benchmark --help
```
