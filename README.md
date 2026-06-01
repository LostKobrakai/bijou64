# Bijou64

Bijou64 is a purely canonical variable length encoding for u64 integers.

See https://www.inkandswitch.com/tangents/bijou64/

## Benchmarks

Comparison with the common `LEB128` format as implemented by `:varint`.

```
Operating System: macOS
CPU Information: Apple M4 Pro
Number of Available Cores: 14
Available memory: 48 GB
Elixir 1.19.1
Erlang 28.1
JIT enabled: true
```

### Encode

```
##### With input random_500 #####
Name                      ips        average  deviation         median         99th %
Bijou64: encode      316.60 K        3.16 μs    ±44.36%        3.04 μs        4.38 μs
Varint: encode       131.07 K        7.63 μs    ±63.49%        7.29 μs       10.29 μs

Comparison:
Bijou64: encode      316.60 K
Varint: encode       131.07 K - 2.42x slower +4.47 μs
```

### Decode

```
##### With input random_500 #####
Name                      ips        average  deviation         median         99th %
Bijou64: decode      124.69 K        8.02 μs    ±53.10%        7.79 μs       10.71 μs
Varint: decode        96.55 K       10.36 μs    ±10.67%       10.21 μs       13.96 μs

Comparison:
Bijou64: decode      124.69 K
Varint: decode        96.55 K - 1.29x slower +2.34 μs
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bijou64` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bijou64, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bijou64>.
