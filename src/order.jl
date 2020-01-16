abstract type AbstractOrderType end
struct MarketOrder <: AbstractOrderType end
struct LimitOrder <: AbstractOrderType
    limit_price :: Float64
end
struct StopOrder <: AbstractOrderType
    stop_price :: Float64
end
struct StopLimitOrder <: AbstractOrderType
    limit_price :: Float64
    stop_price :: Float64
    has_triggered :: Ref{Bool}
end

StopLimitOrder(limit_price::Float64, stop_price::Float64) = StopLimitOrder(limit_price, stop_price, Ref{false})

abstract type AbstractOrderDuration end
struct DAY <: AbstractOrderDuration end
struct GTC <: AbstractOrderDuration end
struct OPG <: AbstractOrderDuration end
struct CLS <: AbstractOrderDuration end
struct IOC <: AbstractOrderDuration end
struct FOK <: AbstractOrderDuration end

abstract type AbstractOrder end
id(o::AbstractOrder) = o.id
symbol(o::AbstractOrder) = o.symbol
type(o::AbstractOrder) = o.type
duration(o::AbstractOrder) = o.duration
quantity(o::AbstractOrder) = o.quantity

struct OrderIntent{O <: AbstractOrderType, D <: AbstractOrderDuration} <: AbstractOrder
    id :: UUID
    symbol :: String
    type :: O
    duration :: D
    quantity :: Int
end

function OrderIntent(symbol, type, duration, quantity)
    OrderIntent(uuid4(), symbol, type, duration, quantity)
end

limit_price(::AbstractOrderType) = nothing
limit_price(x::Union{LimitOrder, StopLimitOrder}) = x.limit_price
limit_price(o::AbstractOrder) = limit_price(o.type)
stop_price(::AbstractOrderType) = nothing
stop_price(x::Union{StopOrder, StopLimitOrder}) = x.stop_price
stop_price(o::AbstractOrder) = stop_price(o.type)

should_trade(::AbstractOrderType) = error("Unimplemented")
