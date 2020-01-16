module TradingBase

import UUIDs: UUID, uuid4

export
    #types
    AbstractBrokerage,
    AbstractOrder,
    OrderIntent,
    AbstractOrderType,
    MarketOrder,
    LimitOrder,
    StopOrder,
    StopLimitOrder,
    AbstractOrderDuration,
    DAY,
    GTC,
    CLS,
    IOC,
    FOK,
    AbstractPosition,
    Position,

    get_account,
    get_order,
    get_orders,
    get_last,
    get_historical,
    submit_order,
    cancel_order,
    cancel_orders,
    quantity,
    limit_price,
    stop_price,
    type,
    duration,
    symbol,
    id,
    cost_basis,
    cash

include("order.jl")
include("position.jl")
include("account.jl")
include("brokerage.jl")

end # module
