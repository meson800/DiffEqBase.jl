using Pkg
using SafeTestsets
using Test

const GROUP = get(ENV, "GROUP", "All")
const is_APPVEYOR = (Sys.iswindows() && haskey(ENV, "APPVEYOR"))

function activate_downstream_env()
    Pkg.activate("downstream")
    Pkg.develop(PackageSpec(path = dirname(@__DIR__)))
    Pkg.instantiate()
end

function activate_gpu_env()
    Pkg.activate("gpu")
    Pkg.develop(PackageSpec(path = dirname(@__DIR__)))
    Pkg.instantiate()
end

@time begin
    if GROUP == "All" || GROUP == "Core"
        @time @safetestset "Fast Power" begin
            include("fastpow.jl")
        end
        @time @safetestset "Callbacks" begin
            include("callbacks.jl")
        end
        @time @safetestset "Internal Rootfinders" begin
            include("internal_rootfinder.jl")
        end
        @time @safetestset "Plot Vars" begin
            include("plot_vars.jl")
        end
        @time @safetestset "Problem Creation Tests" begin
            include("problem_creation_tests.jl")
        end
        @time @safetestset "Affine differential equation operators" begin
            include("affine_operators_tests.jl")
        end
        @time @safetestset "Export tests" begin
            include("export_tests.jl")
        end
        @time @safetestset "Remake tests" begin
            include("remake_tests.jl")
        end
        @time @safetestset "High Level solve Interface" begin
            include("high_level_solve.jl")
        end
        @time @safetestset "DiffEqFunction tests" begin
            include("diffeqfunction_tests.jl")
        end
        @time @safetestset "Internal Euler" begin
            include("internal_euler_test.jl")
        end
        @time @safetestset "Basic Operators Interface" begin
            include("basic_operators_interface.jl")
        end
        @time @safetestset "Norm" begin
            include("norm.jl")
        end
        @time @safetestset "Utils" begin
            include("utils.jl")
        end
        @time @safetestset "ForwardDiff Dual Detection" begin
            include("forwarddiff_dual_detection.jl")
        end
        @time @safetestset "ODE default norm" begin
            include("ode_default_norm.jl")
        end
        @time @safetestset "ODE default unstable check" begin
            include("ode_default_unstable_check.jl")
        end
    end

    if !is_APPVEYOR && GROUP == "Downstream"
        activate_downstream_env()
        @time @safetestset "Kwarg Warnings" begin
            include("downstream/kwarg_warn.jl")
        end
        @time @safetestset "Solve Error Handling" begin
            include("downstream/solve_error_handling.jl")
        end
        @time @safetestset "Null DE Handling" begin
            include("downstream/null_de.jl")
        end
        @time @safetestset "Unitful" begin
            include("downstream/unitful.jl")
        end
        @time @safetestset "Null Parameters" begin
            include("downstream/null_params_test.jl")
        end
        @time @safetestset "Ensemble Simulations" begin
            include("downstream/ensemble.jl")
        end
        @time @safetestset "Ensemble Analysis" begin
            include("downstream/ensemble_analysis.jl")
        end
        @time @safetestset "Ensemble Thread Safety" begin
            include("downstream/ensemble_thread_safety.jl")
        end
        @time @safetestset "Inference Tests" begin
            include("downstream/inference.jl")
        end
        @time @safetestset "Table Inference Tests" begin
            include("downstream/tables.jl")
        end
        @time @safetestset "Default linsolve with structure" begin
            include("downstream/default_linsolve_structure.jl")
        end
        @time @safetestset "Callback Merging Tests" begin
            include("downstream/callback_merging.jl")
        end
        @time @safetestset "LabelledArrays Tests" begin
            include("downstream/labelledarrays.jl")
        end
    end

    if !is_APPVEYOR && GROUP == "Downstream2"
        activate_downstream_env()
        @time @safetestset "Prob Kwargs" begin
            include("downstream/prob_kwargs.jl")
        end
        @time @safetestset "Unwrapping" begin
            include("downstream/unwrapping.jl")
        end
        @time @safetestset "Callback BigFloats" begin
            include("downstream/bigfloat_events.jl")
        end
        @time @safetestset "DE stats" begin
            include("downstream/stats_tests.jl")
        end
        @time @safetestset "Ensemble AD Tests" begin
            include("downstream/ensemble_ad.jl")
        end
        @time @safetestset "Community Callback Tests" begin
            include("downstream/community_callback_tests.jl")
        end
        @time @testset "Distributed Ensemble Tests" begin
            include("downstream/distributed_ensemble.jl")
        end
        @time @safetestset "AD via ode with complex numbers" begin
            include("downstream/complex_number_ad.jl")
        end
    end

    if !is_APPVEYOR && GROUP == "GPU"
        activate_gpu_env()
        @time @safetestset "Simple GPU" begin
            include("gpu/simple_gpu.jl")
        end
    end
end
