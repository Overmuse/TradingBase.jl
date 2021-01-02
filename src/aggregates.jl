abstract type AbstractMarketDataAggregate end

struct Close <: AbstractMarketDataAggregate
    close::Float64
end
struct OHLC <: AbstractMarketDataAggregate
    open::Float64
    high::Float64
    low::Float64
    close::Float64
end
struct OHLCV <: AbstractMarketDataAggregate
    open::Float64
    high::Float64
    low::Float64
    close::Float64
    volume::Int
end
JSON3.StructType(::Type{<:AbstractMarketDataAggregate}) = JSON3.Struct()

get_close(m::AbstractMarketDataAggregate) = m.close

struct Trade
    ticker     :: String
    time       :: DateTime
    price      :: Float64
    quantity   :: Int
    conditions :: Vector{Int}
end

const DEFAULT_MAPPING2 = Dict{String, Vector{Int}}(
    "HL" => [2, 7, 13, 15, 16, 20, 21, 37, 52, 53],
    "V"  => [15, 16, 38]
)

function aggregate(::Type{OHLCV}, t, trades::Vector{Trade}; trade_mapping = DEFAULT_MAPPING2)
    min_t, max_t = round(trades[1].time, t, RoundDown), round(trades[end].time, t, RoundUp)
    if max_t == trades[end].time
        bins = min_t:t:(max_t+t)
    else
        bins = min_t:t:max_t
    end
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
            if !any(x -> x ∈ trade_mapping["HL"], conditions)
                if price > high
                    high = price
                elseif price < low
                    low = price
                end
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
    if max_t == trades[end].time
        bins = min_t:t:(max_t+t)
    else
        bins = min_t:t:max_t
    end
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
    if max_t == trades[end].time
        bins = min_t:t:(max_t+t)
    else
        bins = min_t:t:max_t
    end
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
