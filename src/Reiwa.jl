module Reiwa

import Unicode

export ReiwaString, @reiwa_str

const SQUARE_ERA_NAME_REIWA = '\u32ff'
const COMPAT_STRING_REIWA = "令和"
# const IS_UNICODE_V12_1 = Base.Unicode.isassigned(SQUARE_ERA_NAME_REIWA)

"""
    ReiwaString(str::AbstractString)

Create a new `ReiwaString` object that wraps an `str::AbstractString` and 
behaves as ordinal UTF-8 `String`.  
Most commonly constructed using the `@reiwa_str` macro.  

The character `'\\u32ff'` (`'㋿'`: U+32FF SQUARE ERA NAME REIWA) is stored 
and shown **AS IS** (not escaped to the Unicode codepoints form), 
and normalized to the compatible String `"令和"` by `Unicode.normalize()`.

# Example

```jldoctest
julia> reiwa"\\u337e\\u337d\\u337c\\u337b\\u32ff"
reiwa"㍾㍽㍼㍻㋿"

julia> using Unicode; Unicode.normalize(reiwa"\\u337e\\u337d\\u337c\\u337b\\u32ff", :NFKC)
"明治大正昭和平成令和"
```
"""
struct ReiwaString <: AbstractString
    str::AbstractString
end

"""
    @reiwa_str

Create a new `ReiwaString` object.

# Example

```jldoctest
julia> reiwa"\\u337e\\u337d\\u337c\\u337b\\u32ff"
reiwa"㍾㍽㍼㍻㋿"
```
"""
macro reiwa_str(src::String)
    ReiwaString(unescape_string(src))
end

# io
function Base.show(io::IO, str::ReiwaString)
    components = split(str.str, SQUARE_ERA_NAME_REIWA)
    print(io, "reiwa\"", escape_string(components[1]))
    for cmp = components[2:end]
        print(io, SQUARE_ERA_NAME_REIWA, escape_string(cmp))
    end
    print(io, "\"")
end

(::Type{String})(str::ReiwaString) = String(str.str)

function tocompatstring(io::IO, str::ReiwaString)
    components = split(str.str, SQUARE_ERA_NAME_REIWA)
    print(io, components[1])
    for cmp = components[2:end]
        print(io, COMPAT_STRING_REIWA, cmp)
    end
end
@inline tocompatstring(str::ReiwaString) = sprint(tocompatstring, str, sizehint=lastindex(str)+1)

# interfaces
Base.ncodeunits(str::ReiwaString) = ncodeunits(str.str)
Base.isvalid(str::ReiwaString, i::Integer) = isvalid(str.str, i)

Base.iterate(str::ReiwaString) = iterate(str.str)
Base.iterate(str::ReiwaString, i::Integer) = iterate(str.str, i)

# Unicode
Unicode.isassigned(c::Char) = c == SQUARE_ERA_NAME_REIWA ? true : Base.Unicode.isassigned(c)
Unicode.isassigned(c::Integer) = c == Int32(SQUARE_ERA_NAME_REIWA) ? true : Base.Unicode.isassigned(c)

function Unicode.normalize(str::ReiwaString, nf::Symbol)
    Unicode.normalize((nf ∈ (:NFKC, :NFKD) ? tocompatstring(str) : str.str), nf)
end
function Unicode.normalize(str::ReiwaString; compat::Bool=false, kwargs...)
    Unicode.normalize((compat ? tocompatstring(str) : str.str); compat=compat, kwargs...)
end

end # module
