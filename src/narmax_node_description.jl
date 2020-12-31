using ForneyLab
using LinearAlgebra
import ForneyLab: SoftFactor, @ensureVariables, generateId, addNode!, associate!,
                  averageEnergy, Interface, Variable, slug, ProbabilityDistribution,
                  differentialEntropy, unsafeLogMean, unsafeMean, unsafeCov, unsafePrecision, unsafeMeanCov
export NAutoRegressiveMovingAverageX, NARMAX

"""
Description:

    A Nonlinear AutoRegressive model with moving average and exogeneous input (NARMAX)

    y_t = f(y_t-1, …, y_t-n_y, u_t, …, u_t-n_u, e_t, …, e_t-n_e)

    where n_y is the number of previous observations, n_u the number of previous inputs 
    and n_e the number of previous residuals. These histories are stored as the following 
    vectors:
    - x_t-1 = [y_t-1, …, y_t-n_y]' 
    - z_t-1 = [u_t-1, …, u_t-n_u]'
    - r_t-1 = [e_t-1, …, e_t-n_e]'.

    Assume y_t, x_t-1, u_t, z_t-1 and r_t-1 are observed and e_t ~ N(0, τ^-1).

    f is assumed to be a linear product of coefficients θ and a basis expansion of inputs, 
    outputs and residuals ϕ: 
    
        f(...) = θ'*ϕ(y_t-1, …, y_t-n_y, u_t, …, u_t-n_u, e_t, …, e_t-n_e)

Interfaces:

    1. y (output)
    2. θ (function coefficients)
    3. x (previous observations vector)
    4. u (input)
    5. z (previous inputs vector)
    6. r (previous residuals)
    7. τ (precision)

Construction:

    NAutoRegressiveMovingAverageX(y, θ, x, u, z, r, τ, g=ϕ, id=:some_id)
"""

mutable struct NAutoRegressiveMovingAverageX <: SoftFactor
    id::Symbol
    interfaces::Vector{Interface}
    i::Dict{Symbol,Interface}

    g::Function # Scalar function between autoregression coefficients and state variable

    function NAutoRegressiveMovingAverageX(y, θ, x, u, z, r, τ; g::Function, id=generateId(NAutoRegressiveMovingAverageX))
        @ensureVariables(y, θ, x, u, z, r, τ)
        self = new(id, Array{Interface}(undef, 7), Dict{Symbol,Interface}(), g)
        addNode!(currentGraph(), self)
        self.i[:y] = self.interfaces[1] = associate!(Interface(self), y)
        self.i[:θ] = self.interfaces[2] = associate!(Interface(self), θ)
        self.i[:x] = self.interfaces[3] = associate!(Interface(self), x)
        self.i[:u] = self.interfaces[4] = associate!(Interface(self), u)
        self.i[:z] = self.interfaces[5] = associate!(Interface(self), z)
        self.i[:r] = self.interfaces[6] = associate!(Interface(self), r)
        self.i[:τ] = self.interfaces[7] = associate!(Interface(self), τ)
        return self
    end
end

slug(::Type{NAutoRegressiveMovingAverageX}) = "NARMAX"

function averageEnergy(::Type{NAutoRegressiveMovingAverageX},
                       marg_y::ProbabilityDistribution{Univariate},
                       marg_θ::ProbabilityDistribution{Multivariate},
                       marg_x::ProbabilityDistribution{Multivariate},
                       marg_u::ProbabilityDistribution{Univariate},
                       marg_z::ProbabilityDistribution{Multivariate},
                       marg_r::ProbabilityDistribution{Multivariate},
                       marg_τ::ProbabilityDistribution{Univariate})

    error("not implemented yet")

end
