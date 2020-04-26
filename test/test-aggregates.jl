@testset "Aggregates" begin
    x = Close(100.0)
    y = OHLC(99.0, 101.0, 98.0, 100.0)
    z = OHLCV(99.0, 101.0, 98.0, 100.0, 10000)
    @testset "get_close" for agg in [x, y, z]
        @test agg isa AbstractMarketDataAggregate
        @test get_close(agg) == 100.0
    end
    @testset "Aggregation" begin
        times = Date(2020, 2, 2) .+ [Time(10), Time(10, 0, 2), Time(10, 1), Time(11)]
        price = [100.0, 99.0, 104.0, 103.0]
        quantity = [1, 2, 3, 4]
        trades = Trade.("A", times, price, quantity, Ref([]))

        @testset for agg in [Close, OHLC, OHLCV]
            @test aggregate(agg, Minute(1), trades) isa OrderedDict{DateTime, agg}
        end
        @testset "Day" begin
            agg = aggregate(OHLCV, Day(1), trades)
            @test length(agg) == 1
            agg_value = first(values(agg))
            @test agg_value.open == first(price)
            @test agg_value.low == minimum(price)
            @test agg_value.high == maximum(price)
            @test agg_value.close == last(price)
            @test agg_value.volume == sum(quantity)
        end
        @testset "Hour" begin
            agg = aggregate(OHLCV, Hour(1), trades)
            @test length(agg) == 2
            agg_value = first(values(agg))
            @test agg_value.open == first(price)
            @test agg_value.low == minimum(price)
            @test agg_value.high == maximum(price)
            @test agg_value.close == price[3]
            @test agg_value.volume == sum(quantity[1:3])
        end
        @testset "Minute" begin
            agg = aggregate(OHLCV, Minute(1), trades)
            @test length(agg) == 61
            agg_value = first(values(agg))
            @test agg_value.open == first(price)
            @test agg_value.low == minimum(price)
            @test agg_value.high == price[1]
            @test agg_value.close == price[2]
            @test agg_value.volume == sum(quantity[1:2])
        end
    end
end
