# GarbageMath.jl

A julia implementation of [garbage math](https://xkcd.com/2295/). Look out, [Measurements.jl](https://github.com/JuliaPhysics/Measurements.jl)

```julia
julia> using GarbageMath

julia> Precise(1.2) + Precise(3.5)
Slightly less precise number 4.7

julia> Precise(3) * Precise(1)
Slightly less precise number 3

julia> Precise(1) + Garbage(2)
Garbage number 3

julia> Precise(1e10) * Garbage(1e-6)
Garbage number 10000.0

julia> √(Garbage(5))
Less bad garbage number 2.23606797749979

julia> Garbage(6)^2
Worse garbage number 36

julia> mean(StatisticallyIndependant([Garbage(3), Garbage(4), Garbage(5)]))
Better garbage number 4.0

julia> Precise(5)^Garbage(6)
Much worse garbage number 15625

julia> Garbage(2) - Garbage(10)
Much worse garbage number -8

julia> Precise(10)/(Garbage(3) - Garbage(4))
Much worse garbage number -10.0

julia> Garbage(3) * 0
Precise number 0
```

PRs welcome! 