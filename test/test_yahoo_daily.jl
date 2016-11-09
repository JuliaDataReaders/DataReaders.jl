using Base.Test

using DataReaders

dr = DataReader("yahoo")

dt_start = DateTime("2015-04-01")
dt_end = DateTime("2015-04-15")

# One symbol
# ==========
symb = DataSymbol("MSFT")

response = get(dr, symb, dt_start, dt_end)

## DataFrame
df = DataFrame(response)
println(df)

## TimeArray
ta_price, ta_volume = TimeArray(response)
println(ta_price)
println(ta_volume)

# Several symbols
# ===============
symbols = DataSymbols(["IBM", "MSFT"])

response = get(dr, symbols, dt_start, dt_end);

data = DataFrame(response);
println(data)
