using Mocking
Mocking.activate()
import Dates: now
using
    TradingBase,
    Test,
    Dates,
    UUIDs,
    OrderedCollections

@testset "All tests" begin
    include("test-account.jl")
    include("test-aggregates.jl")
    include("test-market_data.jl")
    include("test-order.jl")
    include("test-position.jl")
end
