include("src/DataReaders.jl")

using DataReaders
using RequestsCache: CachedSession

session = CachedSession(cache_name="cache.jld", backend="jld", expire_after=Base.Dates.Day(1))
#session = nothing

#dr = DataReader("google", session=session)
dr = DataReader("yahoo", session=session)

dt_start = DateTime("2015-04-01")
dt_end = DateTime("2015-04-15")

#symb = DataSymbol("MSFT")
#data = get(dr, symb, dt_start, dt_end)

symbols = DataSymbols(["IBM", "MSFT"])
data = get(dr, symbols, dt_start, dt_end)

println(data)
# println(data[:Open])
# println(data[DataSymbol("IBM")])
