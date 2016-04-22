using DataReader

source = DataSource("yahoo")
# params = DataReaderParameters(3, 0.1, 10)  # default parameters for DataReader (retry_count, pause, timeout, cache...)

symb = DataSymbol("MSFT")
symbols = DataSymbols(["IBM", "MSFT"])

dt_start = Date("2015-04-01")
dt_end = Date("2015-04-15")

# data = get_data_google(symb, dt_start, dt_end)
# data = get_data_google(symb, dt_start, dt_end, params=params)
# data = get(source, symb, dt_start, dt_end)
data = get(source, symbols, dt_start, dt_end)

println(data)
# println(data[:Open])
# println(data[DataSymbol("IBM")])