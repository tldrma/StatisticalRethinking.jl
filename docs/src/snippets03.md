```@meta
EditURL = "https://github.com/TRAVIS_REPO_SLUG/blob/master/"
```

# Chapter 3 snippets

### snippet 3.0

Load Julia packages (libraries) needed  for the snippets in chapter 0

```@example snippets03
using StatisticalRethinking
gr(size=(600,300))
```

snippet 3.1

```@example snippets03
PrPV = 0.95
PrPM = 0.01
PrV = 0.001
PrP = PrPV*PrV + PrPM*(1-PrV)
PrVP = PrPV*PrV / PrP
```

snippet 3.2

Grid of 1001 steps

```@example snippets03
p_grid = range(0, step=0.001, stop=1)
```

all priors = 1.0

```@example snippets03
prior = ones(length(p_grid))
```

Binomial pdf

```@example snippets03
likelihood = [pdf(Binomial(9, p), 6) for p in p_grid]
```

As Uniform priar has been used, unstandardized posterior is equal to likelihood

```@example snippets03
posterior = likelihood .* prior
```

Scale posterior such that they become probabilities

```@example snippets03
posterior = posterior / sum(posterior)
```

Sample using the computed posterior values as weights

In this example we keep the number of samples equal to the length of p_grid,
but that is not required.

```@example snippets03
N = 10000
samples = sample(p_grid, Weights(posterior), N)
fitnormal= fit_mle(Normal, samples)

p = Vector{Plots.Plot{Plots.GRBackend}}(undef, 2)

p[1] = scatter(1:N, samples, markersize = 2, ylim=(0.0, 1.3), lab="Draws")
```

analytical calculation

```@example snippets03
w = 6
n = 9
x = 0:0.01:1
p[2] = density(samples, ylim=(0.0, 5.0), lab="Sample density")
p[2] = plot!( x, pdf.(Beta( w+1 , n-w+1 ) , x ), lab="Conjugate solution")
```

quadratic approximation

```@example snippets03
plot!( p[2], x, pdf.(Normal( fitnormal.μ, fitnormal.σ ) , x ), lab="Normal approximation")
plot(p..., layout=(1, 2))
savefig("s3_1.pdf")
```

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*
