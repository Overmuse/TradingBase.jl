@testset "Positions" begin
    p = Position("AAPL", 1, 100.0)

    @test id(p) isa UUID
    @test symbol(p) == "AAPL"
    @test quantity(p) == 1
    @test cost_basis(p) == 100.0
end
