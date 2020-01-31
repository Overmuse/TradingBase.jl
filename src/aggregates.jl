abstract type AbstractMarketDataAggregate end
struct Close{T <: Real} <: AbstractMarketDataAggregate
    close::T
end
struct OHLC{T <: Real} <: AbstractMarketDataAggregate
    open::T
    high::T
    low::T
    close::T

    function OHLC(open, high, low, close)
        @assert all(high .>= [open, low, close])
        @assert all(low .<= [open, low, close])
        promoted = promote(open, high, low, close)
        new{eltype(promoted)}(promoted...)
    end
end
struct OHLCV{T <: Real} <: AbstractMarketDataAggregate
    open::T
    high::T
    low::T
    close::T
    volume::T

    function OHLCV(open, high, low, close, volume)
        @assert all(high .>= [open, low, close])
        @assert all(low .<= [open, low, close])
        promoted = promote(open, high, low, close, volume)
        new{eltype(promoted)}(promoted...)
    end
end

get_close(m::AbstractMarketDataAggregate) = m.close
