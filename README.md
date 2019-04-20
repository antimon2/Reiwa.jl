Reiwa.jl
========

`'\u32ff'`(`'㋿'`: U+32FF SQUARE ERA NAME REIWA) support in Julia

## Installation

To install, run on the Julia Pkg REPL-mode:

```julia
pkg> add https://github.com/antimon2/Reiwa.jl.git
```

Then you can run the built-in unit tests with

```julia
pkg> test Reiwa
```

to verify that everything is functioning properly on your machine.


## Usage

```julia
julia> using Reiwa

julia> s = reiwa"\u32ff"
reiwa"㋿"

julia> using Unicode

julia> Unicode.normalize(s, :NFKC)
"令和"

```


## Fonts

Available fonts that support `U+32ff` (for example):

+ [Source Han Sans（源ノ角ゴシック）](https://github.com/adobe-fonts/source-han-sans) ≥ v2.001
+ [Cica](https://github.com/miiton/Cica) ≥ v4.2.1
