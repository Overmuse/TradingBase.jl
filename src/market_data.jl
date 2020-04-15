abstract type AbstractMarketDataProvider end
abstract type SimulatedMarketDataProvider <: AbstractMarketDataProvider end
abstract type LiveMarketDataProvider <: AbstractMarketDataProvider end

function get_last end
function get_historical end

function is_preopen(::LiveMarketDataProvider)
    t = @mock now()
    isbday(USNYSE(), Date(t)) && (Time(t) > Time(9)) && (Time(t) < Time(9, 30))
end
function is_opening(::LiveMarketDataProvider)
    t = @mock now()
    isbday(USNYSE(), today()) && (Time(now()) > Time(9, 30)) && (Time(now()) < Time(9, 35))
end

function is_open(::LiveMarketDataProvider)
    t = @mock now()
    isbday(USNYSE(), today()) && (Time(now()) > Time(9, 35)) && (Time(now()) < Time(15, 55))
end

function is_closing(::LiveMarketDataProvider)
    t = @mock now()
    isbday(USNYSE(), today()) && (Time(now()) > Time(15, 55)) && (Time(now()) < Time(16))
end
function is_closed(::LiveMarketDataProvider)
    t = @mock now()
    !isbday(USNYSE(), today()) || (Time(now()) > Time(16)) || (Time(now()) < Time(9))
end

function get_clock(::LiveMarketDataProvider)
    @mock now()
end
