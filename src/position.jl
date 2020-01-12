abstract type AbstractPosition end
id(p::AbstractPosition) = p.id
symbol(p::AbstractPosition) = p.symbol
quantity(p::AbstractPosition) = p.quantity
cost_basis(p::AbstractPosition) = p.cost_basis

struct Position <: AbstractPosition
    id :: UUID
    symbol :: String
    quantity :: Int
    cost_basis :: Float64
end

function Position(symbol, quantity, cost_basis)
    Position(uuid4(), symbol, quantity, cost_basis)
end
