abstract type AbstractAccount end
id(a::AbstractAccount) = a.id
cash(a::AbstractAccount) = a.cash
struct Account <: AbstractAccount
    id   :: UUID
    cash :: Float64
end
get_equity(a::AbstractAccount, args...; kwargs...) = error("Unimplemented")
