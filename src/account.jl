abstract type AbstractAccount end
id(a::AbstractAccount) = a.id
cash(a::AbstractAccount) = a.cash
struct Account <: AbstractAccount
    id   :: UUID
    cash :: Float64
end
Account(cash) = Account(uuid4(), cash)
get_equity(a::Account) = a.cash
JSON3.StructType(::Type{Account}) = JSON3.Struct()
