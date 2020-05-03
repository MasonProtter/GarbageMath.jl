module GarbageMath

export XKCDNumber, Precise, Garbage, mean, StatisticallyIndependant

using Statistics: Statistics, mean

struct XKCDNumber{Badness, T} <: Number 
    n::T 
end
XKCDNumber{Badness}(x) where {Badness} = XKCDNumber{Badness, typeof(x)}(x)

const Precise = XKCDNumber{1}
const Garbage = XKCDNumber{10}

get_badness(::XKCDNumber{Badness}) where {Badness} = Badness

function Base.show(io::IO, x::XKCDNumber{n}) where {n}
    qualifier = if n <= 0.25
        "Very precise"
    elseif n <= 0.5
        "More precise"
    elseif n <= 1
        "Precise"
    elseif n <= 2
        "Slightly less precise"
    elseif n <= 3
        "Less precise"
    elseif n < 5
        "Better garbage"
    elseif n < 7 
        "Less bad garbage"
    elseif n < 15
        "Garbage"
    elseif n < 25 
        "Worse garbage"
    else
        "Much worse garbage"
    end
    print(io, qualifier, " number ", x.n)
end


struct StatisticallyIndependant
    xs::Vector
end

+̂(x, y) = maximum((x + y, 0.0))

Base.:(+)(x::XKCDNumber{N}, y::XKCDNumber{M}) where {N, M} = XKCDNumber{N +̂ M}(x.n + y.n)
Base.:(*)(x::XKCDNumber{N}, y::XKCDNumber{M}) where {N, M} = XKCDNumber{N +̂ M}(x.n * y.n)

Base.:(√)(x::XKCDNumber{N}) where {N} = XKCDNumber{N/2}(√(x.n))
Base.literal_pow(::typeof(^), x::XKCDNumber{N}, ::Val{2}) where {N} = XKCDNumber{2N}(x.n ^ 2)

Statistics.mean(v::StatisticallyIndependant) = XKCDNumber{mean(get_badness.(v.xs))/3}(mean((x -> x.n).(v.xs)))

Base.:(^)(x::XKCDNumber{N}, y::XKCDNumber{M}) where {N, M} = XKCDNumber{4*(N +̂ M)}(x.n ^ y.n)
Base.:(-)(x::XKCDNumber{N}, y::XKCDNumber{M}) where {N, M} = XKCDNumber{2*(N +̂ M)}(x.n - y.n)

Base.:(/)(x::XKCDNumber{N}, y::XKCDNumber{M}) where {N, M} = XKCDNumber{100*(N +̂ M)}(x.n / y.n)

Base.:(*)(x::XKCDNumber{N}, y::Number)  where {N} = y == 0 ? Precise(0) : XKCDNumber{N}(x.n * y)
Base.:(*)(x::Number, y::XKCDNumber) = y * x

Base.abs(x::XKCDNumber{N}) where {N} = XKCDNumber{N}(abs(x.n))
Base.isnan(x::XKCDNumber) = isnan(x.n)
Base.isinf(x::XKCDNumber) = abs(x.n) >= 3
Base.Float64(x::XKCDNumber{N}) where {N} = Float64(x.n)  

Base.AbstractFloat(x::XKCDNumber{N}) where {N} = AbstractFloat(x.n)
Base.real(x::XKCDNumber{N}) where {N} = XKCDNumber{N}(real(x.n))

end
