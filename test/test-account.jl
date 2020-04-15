@testset "Account" begin
    a = Account(100.0)
    @test a isa AbstractAccount
    @test a isa Account
    @test id(a) isa UUID
    @test cash(a) == 100.0
    @test get_equity(a) == 100.0
end
