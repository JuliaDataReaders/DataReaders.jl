include("src/DataReaders.jl")

using DataReaders

dr = DataReader("google-quotes")

symb = DataSymbol("MSFT")
data = get(dr, symb)

#symbols = DataSymbols(["IBM", "MSFT"])
#data = get(dr, symbols)

println(data)
# println(data[:Open])
# println(data[DataSymbol("IBM")])
