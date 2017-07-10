using Base.Test

using DataReaders

@testset "google_daily" begin
    dr = DataReader("google");

    dt_start = DateTime("2015-04-01");
    dt_end = DateTime("2015-04-15");

    @testset "one symbol" begin
        symb = DataSymbol("MSFT");

        response = get(dr, symb, dt_start, dt_end);

        ## DataFrame
        df = DataFrame(response)
        println(df)

        ## TimeArray
        ta_price, ta_volume = TimeArray(response)
        println(ta_price)
        println(ta_volume)
    end

    @testset "several symbols" begin
        symbols = DataSymbol.(["IBM", "MSFT"])

        response = get(dr, symbols, dt_start, dt_end);

        data = DataFrame(response);
        println(data)
    end
end
