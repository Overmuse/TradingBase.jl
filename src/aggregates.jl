abstract type AbstractMarketDataAggregate end
struct InconsistentPriceException <: Exception
    msg
end

struct Close{T <: Real} <: AbstractMarketDataAggregate
    close::T
end
struct OHLC{T <: Real} <: AbstractMarketDataAggregate
    open::T
    high::T
    low::T
    close::T

    function OHLC(open, high, low, close)
        if any(high .< [open, low, close])
            throw(InconsistentPriceException(
                "High is not the max in candle."
            ))
        elseif any(low .> [open, high, close])
            throw(InconsistentPriceException(
                "Low is not the min in candle."
            ))
        end
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
        if any(high .< [open, low, close])
            throw(InconsistentPriceException(
                "High is not the max in candle."
            ))
        elseif any(low .> [open, high, close])
            throw(InconsistentPriceException(
                "Low is not the min in candle."
            ))
        end
        promoted = promote(open, high, low, close, volume)
        new{eltype(promoted)}(promoted...)
    end
end

get_close(m::AbstractMarketDataAggregate) = m.close
