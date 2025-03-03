using OrdinaryDiffEq, Test
function lorenz(du, u, p, t)
    du[1] = 10.0(u[2] - u[1])
    du[2] = u[1] * (28.0 - u[3]) - u[2]
    du[3] = u[1] * u[2] - (8 / 3) * u[3]
end
u0 = [1.0; 0.0; 0.0]
tspan = (0.0, 100.0)
prob = ODEProblem(lorenz, u0, tspan)
@test_nowarn sol = solve(prob, Tsit5(), reltol = 1e-6)
sol = solve(prob, Tsit5(), rel_tol = 1e-6)
@test_logs (:warn, DiffEqBase.KWARGWARN_MESSAGE) sol=solve(prob, Tsit5(), rel_tol = 1e-6)
@test_throws DiffEqBase.CommonKwargError sol=solve(prob, Tsit5(), rel_tol = 1e-6,
    kwargshandle = DiffEqBase.KeywordArgError)

prob = ODEProblem(lorenz, u0, tspan, test = 2.0)
@test_logs (:warn, DiffEqBase.KWARGWARN_MESSAGE) sol=solve(prob, Tsit5(), reltol = 1e-6)
