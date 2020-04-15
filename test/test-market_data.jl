# @testset "Market data" begin
#     struct DataProvider <: LiveMarketDataProvider end
#     premarket = @patch now() = DateTime(2020, 2, 3, 8, 30)
#     apply(premarket) do
#         @info now()
#         @test is_preopen(DataProvider())
#     end
# end
