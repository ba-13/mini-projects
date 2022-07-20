### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ eea88282-ea94-44db-b227-75857d33d263
begin
	import Base: +, *, ^
	using StatsPlots, StaticArrays
	using PlutoUI
	using Random
end

# ╔═╡ 70241cc0-722e-4bb4-9fa3-95910b2f89ce
begin
    import DarkMode
    DarkMode.enable()
    # OR DarkMode.Toolbox(theme="default")
end

# ╔═╡ 098e905c-4043-4381-9d1f-372c3b8b1592
struct Dual{T}
	val::T
	der::T
end

# ╔═╡ 131c6efc-37ab-413a-943f-1626fd5d9dd1
md"""
# DUALS

A way to represent differentials that can be handled algorithmically.
It involves taking ϵ as a small number such that ϵ² = 0.  
Then using the definition that:
$f(x+ϵ) = f(x) + ϵ⋅f'(x) + σ(ϵ²)$
where we drop the higher powers because of our assumption, which is practically quite accurate.
"""

# ╔═╡ 4a0b4d1f-43f6-4747-bbfd-9a15cac65ec2
md"""
Below we define basic differentials for 1° variable functions, i.e. through Duals 
"""

# ╔═╡ 38343cf9-1960-4d82-b9e5-2c8edf95f970
begin
	Base.promote_rule(::Type{Number}, ::Type{Dual}) = Dual
	Base.convert(::Type{Dual}, α::Number) = Dual(α, 0)
	# BUG: Didn't work out, conversion rules.
end

# ╔═╡ 0ba25c3e-7cca-40d4-9d35-fa7d2c70db25
begin
	Base.:+(f::Dual, g::Dual) = Dual(f.val + g.val, f.der + g.der)
	Base.:+(f::Dual, α::Number) = Dual(f.val + α, f.der)
	Base.:+(α::Number, f::Dual) = f + α
	
	Base.:-(f::Dual, g::Dual) = Dual(f.val - g.val, f.der - g.der)
	
	Base.:*(f::Dual, g::Dual) = Dual(f.val * g.val, f.val * g.der + f.der * g.val)
	Base.:*(f::Dual, α::Number) = Dual(f.val * α, f.der * α)
	Base.:*(α::Number, f::Dual) = f * α
	
	Base.:/(f::Dual, g::Dual) = Dual(f.val/g.val,(g.val*f.der - f.val*g.der) /(g.val^2))
	Base.:/(f::Dual, α::Number) = Dual(f.val/α, f.der/α)
	Base.:/(α::Number, f::Dual) = Dual(α/f.val, -α*f.der/(f.val^2))
	
	Base.:^(f::Dual, α::Number) = Dual(f.val^α, α * (f.val^(α-1)) * f.der)
	
	function Base.:exp(f::Dual)
		return Dual(exp(f.val), exp(f.val)*f.der)
	end
	function Base.:log(f::Dual)
		return Dual(log(f.val), f.der/f.val)
	end
	function Base.:sin(f::Dual)
		return Dual(sin(f.val), cos(f.val)*f.der)
	end
	function Base.:cos(f::Dual)
		return Dual(cos(f.val), -sin(f.val)*f.der)
	end
	function Base.:abs(f::Dual)
		return Dual(abs(f.val), sign(f.val)*f.der)
	end
	function Base.:show(f::Dual)
		return "f.val is $(f.val), f.der is $(f.der)"
	end
	function Base.:(==)(f::Dual, g::Dual)
		if(f.val==g.val && f.der==g.der)
			return true
		else
			return false
		end
	end
	function Base.:<(f::Dual, g::Dual)
		if(f.val < g.val)
			return true
		else 
			return false
		end
	end
	function Base.:>(f::Dual, g::Dual)
		if(f.val > g.val)
			return true
		else
			return false
		end
	end
	function Base.:(==)(f::Dual, α::Number)
		if(f.val == α)
			return true
		else 
			return false
		end
	end
	function Base.:>(f::Dual, α::Number)
		if(f.val > α)
			return true
		else 
			return false
		end
	end
	function Base.:<(f::Dual, α::Number)
		if(f.val < α)
			return true
		else 
			return false
		end
	end
	function Base.:(==)(α::Number, f::Dual)
		if(f.val == α)
			return true
		else 
			return false
		end
	end
	function Base.:>(α::Number, f::Dual)
		if(f.val > α)
			return true
		else 
			return false
		end
	end
	function Base.:<(α::Number, f::Dual)
		if(f.val < α)
			return true
		else 
			return false
		end
	end
	# We have to remove the above repeated code through conversion and promotions.
end

# ╔═╡ d3140d8b-a6d0-4752-bb40-386bdc722018
begin
	d1 = Dual(3,0)
	d2 = Dual(3,0)
	β = 3
end

# ╔═╡ 8d0b1849-07e2-4035-a190-8f9638d695c0
d1 == d2

# ╔═╡ 7050498e-6cf9-49aa-9fe0-a4afb6d7e033
d1 == β

# ╔═╡ 629a088c-bade-4dbe-949b-fd657ae04678
show(Dual(2,1))

# ╔═╡ 3e422f2c-df13-4e14-8863-306a8a86b938
f1(x) = exp(x^2) + 3*x + x^3

# ╔═╡ c4ed1b55-c6a2-4a84-a5af-43007336349c
derivative(f, x) = f(Dual(x, one(x))).der

# ╔═╡ b13af0d1-4319-48d5-bdef-bf88bdae3687
derivative(f1, 1)

# ╔═╡ e20344bd-4a54-458b-bdd4-6b180accd1c8
md"""
# MULTIDUALS

MultiDuals are just re-representing duals in a more compact manner suitable for higher dimensional input vectors. We are extending the concept of 1 variable functions to multiple dimensions.
"""

# ╔═╡ 7fefaabe-87c7-4ed4-9f53-0e9977cb6080
struct MultiDual{N,T} <: Number
	val::T
	derivs::SVector{N,T}
end

# ╔═╡ 3a392caa-6dec-4ab7-bcc5-bccd2db5317e
begin
	Base.promote_rule(::Type{Number}, ::Type{MultiDual}) = MultiDual
	Base.convert(::Type{MultiDual}, α::Number) = MultiDual(α, SVector(0))
end

# ╔═╡ 76828d9d-5249-4e78-b925-2600a7cc5f70
md"""
A WARNING: Use only _Float64_ as input/assigning the values in MultiDual struct and its related calculations, because Julia doesn't convert Int32 implicitly to that, Julia involves Multiple Dispatching, but It doesn't work here cause we are defining a new struct and its definitions, afaik.
"""

# ╔═╡ 0e9d4675-4df2-4df0-8362-7a3da94238f5
	md"""
	Below, We define the following operations for MultiDual struct defined above.
	Promotion and Conversion will take care of instances
	where Numbers and MultiDuals are involved together.
	- \+ 
	- \-
	- \*
	- /
	- ^
	- abs
	- log
	- sin
	- cos
	- exp
	- greater than 
	- lesser than
	- equal to
	"""

# ╔═╡ 69d485a5-2718-4f18-b024-6cd0b0636986
begin
	# Addition definition
	function Base.:+(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(f.val + g.val, f.derivs + g.derivs)
	end
	function Base.:+(f::MultiDual{N,T}, α::Number) where {N,T}
		return MultiDual{N,T}(f.val + α, f.derivs)
	end
	function Base.:+(α::Number, f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(α + f.val, f.derivs)
	end
	
	# Multiplication definition
	function Base.:*(α::Number, f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(f.val * α, f.derivs .* α)
	end
	function Base.:*(f::MultiDual{N,T}, α::Number) where {N,T}
    	return MultiDual{N,T}(f.val * α, f.derivs .* α)
	end
	function Base.:*(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(f.val * g.val, g.derivs*f.val + g.val*f.derivs)
	end
	
	# Subtraction definition
	function Base.:-(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(f.val - g.val, f.derivs - g.derivs)
	end
	
	# Division definition
	function Base.:/(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(f.val/g.val, (g.val .* f.derivs - f.val .* g.derivs)/(g.val^2))
	end
	
	function Base.:/(α::Number, f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(α/f.val, -α .* f.derivs / (f.val^2))
	end
	
	function Base.:/(f::MultiDual{N,T}, α::Number) where {N,T}
		return MultiDual{N,T}(f.val/α, f.derivs ./ α)
	end
	# Exponentiation definition
	function Base.:^(f::MultiDual{N,T}, α::Number) where {N,T}
		return MultiDual{N,T}(f.val^α, α*(f.val^(α-1)).*f.derivs)
	end
	
	# exp definition
	function Base.:exp(f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(exp(f.val), exp(f.val) .* f.derivs)
	end
	
	# sin, cos definition
	function Base.:sin(f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(sin(f.val), cos.(f.derivs))
	end
	
	function Base.:cos(f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(cos(f.val), -sin.(f.derivs))
	end
	
	# log definition
	function Base.:log(f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(log(f.val), f.derivs ./ f.val)
	end
	# abs definition
	function Base.:abs(f::MultiDual{N,T}) where {N,T}
		return MultiDual{N,T}(abs(f.val), sign(f.val) .* f.derivs)
	end
	
	# Comparison definition
	function Base.:(==)(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
		return f.val==g.val ? true : false
	end
		
	function Base.:>(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
		return f.val > g.val ? true : false
	end
	
	function Base.:<(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
		return f.val < g.val ? true : false
	end
	
	function Base.:(==)(f::MultiDual{N,T}, α::Number) where {N,T}
		return f.val == α ? true : false
	end
	
	function Base.:<(f::MultiDual{N,T}, α::Number) where {N,T}
		return f.val < α ? true : false
	end
	
	function Base.:>(f::MultiDual{N,T}, α::Number) where {N,T}
		return f.val > α ? true : false
	end
	
	function Base.:(==)(α::Number, f::MultiDual{N,T}) where {N,T}
		return f.val == α ? true : false
	end
	
	function Base.:<(α::Number, f::MultiDual{N,T}) where {N,T}
		return f.val > α ? true : false
	end
	
	function Base.:>(α::Number, f::MultiDual{N,T}) where {N,T}
		return f.val < α ? true : false
	end
end

# ╔═╡ 86d13df2-0c35-47d6-936c-0f1ebaa58ef5
md"""
### Show
display MultiDuals as a string.
"""

# ╔═╡ eafef8fb-dd34-4b4a-9e8b-8e44d25ff539
function Base.:show(f::MultiDual{N,T}, name::String="multiDual") where {N,T}
	"""
	Defining show function for MultiDuals
	"""
	return "$name.Value: $(f.val)", "$name.Gradient: $(f.derivs)"
end

# ╔═╡ 8b9908ae-8ce1-451d-bd33-80309fdfb200
begin
	m1 = MultiDual(3.0,SVector(1.0,0.0))
	m2 = MultiDual(4.0,SVector(0.0,1.0))
	m1 + m2
end

# ╔═╡ a69fec3f-13ee-4385-8466-bffbbfd14acc
# show(m1,"m1")
show(m1)
# I know, can be better implemented, for now you have to pass the variable name as string, else assigned "x"

# ╔═╡ 3f2e6342-3786-45f1-8680-9b7d24147a4f
md"""
#### Example:
Verifying the workings of MultiDuals by comparing the results of the following function f(X) through the routes of MultiDuals and Duals
"""

# ╔═╡ c06b9602-590b-485e-bc04-3ed2513df617
f₁(X) = X[1]^2.0 + 2.0*X[2] + 1/X[1] + exp(X[1]) + log(X[2]) + abs(X[1]*X[2]) + X[2]^4.2

# ╔═╡ 57f156df-81f6-45eb-affe-dc73925762b0
# Let's say we have to find the gradient of f at (3,4)
# This will indeed work because we are approaching from the basics, using Duals individually.
gradient_f₃₄ = [f₁([Dual(3,one(3)), Dual(4,zero(4))]).der, f₁([Dual(3,zero(3)), Dual(4,one(4))]).der]

# ╔═╡ aa797924-16f5-4794-ad76-ef42f7cc4f19
show(f₁([m1, m2]), "grad(f)")

# ╔═╡ 5c9d15ac-6a0f-4118-9106-cb77086f2920
md"""
### Gradient
Definition for multivariable function f, and input X
"""

# ╔═╡ c8cd1519-83dc-41ca-867a-34d15efbfe00
function gradient(f, X)
"""
Takes coordinates in standard basis as input, as well as the function whose gradient we need to find at that specific point. Output is the gradient vector.
"""
	multiDualArray = []
	len = length(X)
	i = 1
	for coordinate in X
		c_arr = zeros(len)
		c_arr[i] = 1.0
		c = MultiDual(Float64(coordinate), SVector{len, Float64}(c_arr))
		append!(multiDualArray, c)
		@show multiDualArray[i] # Just for debugging
		i+=1
	end
	return f(multiDualArray)
end

# ╔═╡ 75f3300c-eda2-4956-94ff-64d6e539cb75
begin
	# Testing the gradient function example 1
	X1 = [3,4]
	show(gradient(f₁,X1))
end

# ╔═╡ 9c974612-53a6-44f2-be1d-6d4d0c09c67f
begin
	# Testing the gradient function example 2
	X2 = [1,2,3,4]
	f₂(X) = X[1]^4.0 + log(X[2])
	show(gradient(f₂,X2))
end

# ╔═╡ b84f23b2-6fef-4d4f-8f0e-e166ac05d62f
md"""
### Jacobian
Definition for multivariable function f, and input X
"""

# ╔═╡ 1cfc0db1-d5c3-4058-a876-0f237b6058c8
function Jacobian(Xg::Vector)
"""
Assuming a few things:
	f is defined inside here, and can be extended following the pattern shown.
	Output is an array of SVectors, because I can't think of how to convert them back     to arrays. 
"""
	fʲ₁(X) = X[1]^3.0 + 3.0*X[2] 
	fʲ₂(X) = abs(X[2])
	fʲ₃(X) = exp(X[3])
	#3 dim I/O function example
	# Make changes to this f, for other Jacobians.
	final = [[gradient(fʲ₁, Xg).derivs],[gradient(fʲ₂, Xg).derivs],[gradient(fʲ₃, Xg).derivs]]
	# reshape(final,(3,3))
	return final
end

# ╔═╡ b7d4bfb8-9a6f-46e7-a91a-a27a268e1246
begin
	X₃ = [2.0,1.0,3.0]
end

# ╔═╡ 2f3bd4df-ce95-452b-bd48-374a300a256a
Jacobian(X₃)

# ╔═╡ Cell order:
# ╠═70241cc0-722e-4bb4-9fa3-95910b2f89ce
# ╠═eea88282-ea94-44db-b227-75857d33d263
# ╠═098e905c-4043-4381-9d1f-372c3b8b1592
# ╟─131c6efc-37ab-413a-943f-1626fd5d9dd1
# ╟─4a0b4d1f-43f6-4747-bbfd-9a15cac65ec2
# ╠═38343cf9-1960-4d82-b9e5-2c8edf95f970
# ╟─0ba25c3e-7cca-40d4-9d35-fa7d2c70db25
# ╠═d3140d8b-a6d0-4752-bb40-386bdc722018
# ╠═8d0b1849-07e2-4035-a190-8f9638d695c0
# ╠═7050498e-6cf9-49aa-9fe0-a4afb6d7e033
# ╠═629a088c-bade-4dbe-949b-fd657ae04678
# ╠═3e422f2c-df13-4e14-8863-306a8a86b938
# ╠═c4ed1b55-c6a2-4a84-a5af-43007336349c
# ╠═b13af0d1-4319-48d5-bdef-bf88bdae3687
# ╟─e20344bd-4a54-458b-bdd4-6b180accd1c8
# ╠═7fefaabe-87c7-4ed4-9f53-0e9977cb6080
# ╠═3a392caa-6dec-4ab7-bcc5-bccd2db5317e
# ╟─76828d9d-5249-4e78-b925-2600a7cc5f70
# ╟─0e9d4675-4df2-4df0-8362-7a3da94238f5
# ╠═69d485a5-2718-4f18-b024-6cd0b0636986
# ╟─86d13df2-0c35-47d6-936c-0f1ebaa58ef5
# ╠═eafef8fb-dd34-4b4a-9e8b-8e44d25ff539
# ╠═a69fec3f-13ee-4385-8466-bffbbfd14acc
# ╠═8b9908ae-8ce1-451d-bd33-80309fdfb200
# ╟─3f2e6342-3786-45f1-8680-9b7d24147a4f
# ╠═c06b9602-590b-485e-bc04-3ed2513df617
# ╟─57f156df-81f6-45eb-affe-dc73925762b0
# ╟─aa797924-16f5-4794-ad76-ef42f7cc4f19
# ╟─5c9d15ac-6a0f-4118-9106-cb77086f2920
# ╠═c8cd1519-83dc-41ca-867a-34d15efbfe00
# ╠═75f3300c-eda2-4956-94ff-64d6e539cb75
# ╠═9c974612-53a6-44f2-be1d-6d4d0c09c67f
# ╟─b84f23b2-6fef-4d4f-8f0e-e166ac05d62f
# ╠═1cfc0db1-d5c3-4058-a876-0f237b6058c8
# ╠═2f3bd4df-ce95-452b-bd48-374a300a256a
# ╠═b7d4bfb8-9a6f-46e7-a91a-a27a268e1246
