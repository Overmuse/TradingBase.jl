@testset "Orders" begin
    @testset "MarketOrder" begin
        o = MarketOrder()
        @test isnothing(limit_price(o))
        @test isnothing(stop_price(o))
        @test isnothing(trail_price(o))
        @test isnothing(trail_percent(o))
    end
    @testset "LimitOrder" begin
        o = LimitOrder(100.0)
        @test limit_price(o) == 100.0
        @test isnothing(stop_price(o))
        @test isnothing(trail_price(o))
        @test isnothing(trail_percent(o))
    end
    @testset "StopOrder" begin
        o = StopOrder(100.0)
        @test isnothing(limit_price(o))
        @test stop_price(o) == 100.0
        @test isnothing(trail_price(o))
        @test isnothing(trail_percent(o))
    end
    @testset "StopLimitOrder" begin
        o = StopLimitOrder(100.0, 200.0)
        @test limit_price(o) == 100.0
        @test stop_price(o) == 200.0
        @test isnothing(trail_price(o))
        @test isnothing(trail_percent(o))
    end
    @testset "TrailingStopPriceOrder" begin
        o = TrailingStopPriceOrder(100.0)
        @test isnothing(limit_price(o))
        @test isnothing(stop_price(o))
        @test trail_price(o) == 100.0
        @test isnothing(trail_percent(o))
    end
    @testset "TrailingStopPercentOrder" begin
        o = TrailingStopPercentOrder(100.0)
        @test isnothing(limit_price(o))
        @test isnothing(stop_price(o))
        @test isnothing(trail_price(o))
        @test trail_percent(o) == 100.0
    end
    @testset "OrderIntent" begin
        oi = OrderIntent("A", StopLimitOrder(100.0, 200.0), CLS(), 1)
        @test limit_price(oi) == 100.0
        @test stop_price(oi) == 200.0
        @test id(oi) isa UUID
        @test symbol(oi) == "A"
        @test type(oi) isa StopLimitOrder
        @test duration(oi) isa CLS
        @test quantity(oi) == 1
    end
end
