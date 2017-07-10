using Base.Test

using DataReaders

@testset "google_quotes" begin
    dr = DataReader("google-quotes")

    symb = DataSymbol("MSFT")

    data = get(dr, symb)
end
