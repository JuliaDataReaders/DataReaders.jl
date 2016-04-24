include("src/DataReader.jl")

using DataReader


source = DataSource("google-quotes")

symb = DataSymbol("MSFT")
data = get(source, symb)

#symbols = DataSymbols(["IBM", "MSFT"])
#data = get(source, symbols)

println(data)
# println(data[:Open])
# println(data[DataSymbol("IBM")])