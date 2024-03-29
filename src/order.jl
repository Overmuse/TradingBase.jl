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
end
struct TrailingStopPriceOrder <: AbstractOrderType
    trail_price :: Float64
end
struct TrailingStopPercentOrder <: AbstractOrderType
    trail_percent :: Float64
end

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
trail_price(::AbstractOrderType) = nothing
trail_price(x::TrailingStopPriceOrder) = x.trail_price
trail_price(o::AbstractOrder) = trail_price(o.type)
trail_percent(::AbstractOrderType) = nothing
trail_percent(x::TrailingStopPercentOrder) = x.trail_percent
trail_percent(o::AbstractOrder) = trail_percent(o.type)

function should_trade end

mutable struct Order{O <: AbstractOrderType, D <: AbstractOrderDuration} <: AbstractOrder
    id::UUID
    submitted_at::DateTime
    filled_at::Union{DateTime, Nothing}
    canceled_at::Union{DateTime, Nothing}
    failed_at::Union{DateTime, Nothing}
    symbol::String
    quantity::Int
    filled_quantity::Int
    type::O
    duration::D
    limit_price::Union{Float64, Nothing}
    stop_price::Union{Float64, Nothing}
    filled_average_price::Union{Float64, Nothing}
    commission::Union{Float64, Nothing}
    status::String
end

is_filled(o::Order) = o.filled_quantity == o.quantity
status(o::AbstractOrder) = o.status
