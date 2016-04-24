include("src/DataReader.jl")

using DataReader

source = DataSource("google")
#source = DataSource("yahoo")
# params = DataReaderParameters(3, 0.1, 10)  # default parameters for DataReader (retry_count, pause, timeout, cache...)

dt_start = DateTime("2015-04-01")
dt_end = DateTime("2015-04-15")

#symb = DataSymbol("MSFT")
#data = get(source, symb, dt_start, dt_end)

symbols = DataSymbols(["IBM", "MSFT"])
data = get(source, symbols, dt_start, dt_end)

println(data)
# println(data[:Open])
# println(data[DataSymbol("IBM")])