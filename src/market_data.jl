abstract type AbstractMarketDataProvider end
abstract type SimulatedMarketDataProvider <: AbstractMarketDataProvider end
abstract type LiveMarketDataProvider <: AbstractMarketDataProvider end

get_last(::AbstractMarketDataProvider, args...; kwargs...) = error("Unimplemented")
get_historical(::AbstractMarketDataProvider, args...; kwargs...) = error("Unimplemented")
