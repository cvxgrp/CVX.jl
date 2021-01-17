import LinearAlgebra.norm

# deprecate these soon
norm_inf(x::AbstractExpr) = maximum(abs(x))
norm_1(x::AbstractExpr) = sum(abs(x))
norm_fro(x::AbstractExpr) = norm2(vec(x))

# behavior of norm should be consistent with julia:
# * vector norms for vectors
# * operator norms for matrices
"""
    LinearAlgebra.norm(x::AbstractExpr, p::Real=2)

Computes the `p`-norm `‖x‖ₚ = (∑ᵢ |xᵢ|^p)^(1/p)` of a vector expression `x`.
For a matrix expression, returns `‖vec(x)‖ₚ`, matching the behavior of [`norm`](@ref)
for numeric matrices.

!!! warning
    For versions of Convex.jl prior to v0.14.0, `norm` on a matrix expression returned
    the operator norm ([`opnorm`](@ref)), which matches Julia v0.6 behavior. This functionality
    was deprecated since Convex.jl v0.8.0.
"""
function LinearAlgebra.norm(x::AbstractExpr, p::Real=2)
    if length(size(x)) <= 1 || minimum(size(x))==1
        # x is a vector
        if p == 1
            return norm_1(x)
        elseif p == 2
            return norm2(x)
        elseif p == Inf
            return norm_inf(x)
        elseif p > 1
            # TODO: allow tolerance in the rationalize step
            return rationalnorm(x, rationalize(Int, float(p)))
        else
            error("vector p-norms not defined for p < 1")
        end
    else
        return norm(vec(x), p)
    end
end
