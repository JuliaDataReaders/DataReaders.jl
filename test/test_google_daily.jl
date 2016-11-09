using Base.Test

using DataReaders

dr = DataReader("google");

dt_start = DateTime("2015-04-01");
dt_end = DateTime("2015-04-15");

# One symbol
# ==========
symb = DataSymbol("MSFT");

response = get(dr, symb, dt_start, dt_end);

df = DataFrame(response)
println(df)

#ta = TimeArray(response)
#println(ta)


# Several symbols
# ===============
symbols = DataSymbols(["IBM", "MSFT"])

response = get(dr, symbols, dt_start, dt_end);

data = DataFrame(response);
println(data)
