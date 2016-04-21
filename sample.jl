using DataReader

source = DataSource("GOOG")
params = DataReaderParameters(3, 0.1)  # default parameters for DataReader (retry_count, pause, cache...)

symb = DataSymbol("MSFT")
symbols = DataSymbols(["IBM", "MSFT"])

dt_start = Date("2015-04-01")
dt_end = Date("2015-04-15")

# data = get_data_google(symb, dt_start, dt_end, params)
# data = get(source, symb, dt_start, dt_end, params)
data = get(source, symbols, dt_start, dt_end, params)

println(data)
# println(data[:Open])
# println(data[DataSymbol("IBM")])