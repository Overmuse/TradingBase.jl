module TradingBase

using BusinessDays: USNYSE, isbday
using Dates: DateTime, Date, Hour, Minute, Time, now, today
using OrderedCollections: OrderedDict
import UUIDs: UUID, uuid4
using Mocking

export
    #types
    AbstractAccount,
    Account,
    AbstractBrokerage,
    AbstractMarketDataAggregate,
    AbstractMarketDataProvider,
    SimulatedMarketDataProvider,
    LiveMarketDataProvider,
    AbstractOrder,
    Order,
    OrderIntent,
    AbstractOrderType,
    MarketOrder,
    LimitOrder,
    StopOrder,
    StopLimitOrder,
    TrailingStopPriceOrder,
    TrailingStopPercentOrder,
    AbstractOrderDuration,
    DAY,
    GTC,
    OPG,
    CLS,
    IOC,
    FOK,
    AbstractPosition,
    Position,
    Close,
    OHLC,
    OHLCV,
    Trade,

    aggregate,
    close_position,
    close_positions,
    get_account,
    get_clock,
    get_close,
    get_order,
    get_orders,
    get_last,
    get_historical,
    get_equity,
    get_position,
    get_positions,
    submit_order,
    cancel_order,
    cancel_orders,
    is_preopen,
    is_opening,
    is_open,
    is_closing,
    is_closed,
    is_filled,
    status,
    quantity,
    limit_price,
    stop_price,
    trail_price,
    trail_percent,
    type,
    duration,
    symbol,
    id,
    cost_basis,
    cash

include("aggregates.jl")
include("market_data.jl")
include("order.jl")
include("position.jl")
include("account.jl")
include("brokerage.jl")

end # module
