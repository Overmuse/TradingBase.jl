abstract type AbstractMarketDataProvider end
abstract type SimulatedMarketDataProvider <: AbstractMarketDataProvider end
abstract type LiveMarketDataProvider <: AbstractMarketDataProvider end

get_last(::AbstractMarketDataProvider, args...; kwargs...) = error("Unimplemented")
get_historical(::AbstractMarketDataProvider, args...; kwargs...) = error("Unimplemented")

function is_preopen(::LiveMarketDataProvider)
    isbday(USNYSE(), today()) && (Time(now()) > Time(9)) && (Time(now()) < Time(9, 30))
end
function is_opening(::LiveMarketDataProvider)
    isbday(USNYSE(), today()) && (Time(now()) > Time(9, 30)) && (Time(now()) < Time(9, 35))
end

function is_open(::LiveMarketDataProvider)
    isbday(USNYSE(), today()) && (Time(now()) > Time(9, 35)) && (Time(now()) < Time(15, 55))
end

function is_closing(::LiveMarketDataProvider)
    isbday(USNYSE(), today()) && (Time(now()) > Time(15, 55)) && (Time(now()) < Time(16))
end
function is_closed(::LiveMarketDataProvider)
    !isbday(USNYSE(), today()) || (Time(now()) > Time(16)) || (Time(now()) < Time(9))
end

get_clock(::LiveMarketDataProvider) = now()
