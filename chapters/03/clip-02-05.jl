using StatisticalRethinking, Optim
gr(size=(600,300))

p_grid = range(0, step=0.001, stop=1)

prior = ones(length(p_grid));

likelihood = [pdf(Binomial(9, p), 6) for p in p_grid];

posterior = likelihood .* prior;

posterior = posterior / sum(posterior)

N = 10000
samples = sample(p_grid, Weights(posterior), N);

#chn = Chains(reshape(samples, N, 1, 1), [:toss], Dict(:parameters => [:toss]));
chn = MCMCChain.Chains(reshape(samples, N, 1, 1), names=[:toss]);
#describe(chn)

plot(chn)

x0 = [0.5]
lower = [0.0]
upper = [1.0]

function loglik(x)
  ll = 0.0
  ll += log.(pdf.(Beta(1, 1), x[1]))
  ll += sum(log.(pdf.(Binomial(9, x[1]), repeat([6], N))))
  -ll
end

(qmap, opt) = quap(samples, loglik, lower, upper, x0)

opt

quapfit = [qmap[1], std(samples, mean=qmap[1])]

p = Vector{Plots.Plot{Plots.GRBackend}}(undef, 2)
p[1] = scatter(1:N, samples, markersize = 2, ylim=(0.0, 1.3), lab="Draws")

w = 6
n = 9
x = 0:0.01:1
p[2] = density(samples, ylim=(0.0, 5.0), lab="Sample density")
p[2] = plot!( x, pdf.(Beta( w+1 , n-w+1 ) , x ), lab="Conjugate solution")

plot!( p[2], x, pdf.(Normal( quapfit[1], quapfit[2] ) , x ), lab="Quap approximation")
plot(p..., layout=(1, 2))

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

