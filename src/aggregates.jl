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
    volume::Int

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
        promoted = promote(open, high, low, close)
        new{eltype(promoted)}(promoted..., volume)
    end
end

get_close(m::AbstractMarketDataAggregate) = m.close

struct Trade
    ticker
    time
    price
    quantity
    conditions
end

const DEFAULT_MAPPING = Dict{String, Vector{Int}}(
    "HL" => [2, 7, 13, 15, 16, 20, 21, 37, 52, 53],
    "V"  => [15, 16, 38]
)

function aggregate(::Type{OHLCV}, t, trades::Vector{Trade}; trade_mapping = DEFAULT_MAPPING)
    min_t, max_t = round(trades[1].time, t, RoundDown), round(trades[end].time, t, RoundUp)
    bins = min_t:t:max_t
    statistics = OrderedDict{DateTime, OHLCV}()
    bin_count = 1
    trade_count = 1
    while bin_count < length(bins)
        open = trades[max(1, trade_count-1)].price
        high = open
        low = open
        volume = 0
        while trade_count <= length(trades) && trades[trade_count].time < bins[bin_count+1]
            price = trades[trade_count].price
            conditions = trades[trade_count].conditions
            if price > high
                high = price
            elseif price < low
                low = price
            end
            if !any(x -> x ∈ trade_mapping["V"], conditions)
                volume += trades[trade_count].quantity
            end
            trade_count += 1
        end
        close = trades[trade_count-1].price
        statistics[bins[bin_count]] = OHLCV(open, high, low, close, volume)
        bin_count += 1
    end
    return statistics
end

function aggregate(::Type{OHLC}, t, trades::Vector{Trade})
    min_t, max_t = round(trades[1].time, t, RoundDown), round(trades[end].time, t, RoundUp)
    bins = min_t:t:max_t
    statistics = OrderedDict{DateTime, OHLC}()
    bin_count = 1
    trade_count = 1
    while bin_count < length(bins)
        open = trades[max(1, trade_count-1)].price
        high = open
        low = open
        while trade_count <= length(trades) && trades[trade_count].time < bins[bin_count+1]
            price = trades[trade_count].price
            if price > high
                high = price
            elseif price < low
                low = price
            end
            trade_count += 1
        end
        close = trades[trade_count-1].price
        statistics[bins[bin_count]] = OHLC(open, high, low, close)
        bin_count += 1
    end
    return statistics
end

function aggregate(::Type{Close}, t, trades::Vector{Trade})
    min_t, max_t = round(trades[1].time, t, RoundDown), round(trades[end].time, t, RoundUp)
    bins = min_t:t:max_t
    statistics = OrderedDict{DateTime, Close}()
    bin_count = 1
    trade_count = 1
    while bin_count < length(bins)
        while trade_count <= length(trades) && trades[trade_count].time < bins[bin_count+1]
            price = trades[trade_count].price
            trade_count += 1
        end
        close = trades[trade_count-1].price
        statistics[bins[bin_count]] = Close(close)
        bin_count += 1
    end
    return statistics
end
