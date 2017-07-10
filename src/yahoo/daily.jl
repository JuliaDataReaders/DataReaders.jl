type DataReaderResponseYahooDaily <: DataReaderResponse
    r
end

function get(dr::DataReaderYahooDaily, symb::DataSymbol, dt_start::DateTime, dt_end::DateTime)
    url = "http://ichart.finance.yahoo.com/table.csv"
    interval = "d"
    query = Dict{AbstractString,AbstractString}(
        "s" => symb.s,
        "a" => string(Integer(Dates.Month(dt_start)) - 1),
        "b" => string(Integer(Dates.Day(dt_start))),
        "c" => string(Integer(Dates.Year(dt_start))),
        "d" => string(Integer(Dates.Month(dt_end)) - 1),
        "e" => string(Integer(Dates.Day(dt_end))),
        "f" => string(Integer(Dates.Year(dt_end))),
        "g" => interval,
        "ignore" => ".csv"
    )
    r = get_response(url, query, dr)
    DataReaderResponseYahooDaily(r)
end

function get(dr::DataReaderYahooDaily, symbols::Vector{DataSymbol}, dt_start::DateTime, dt_end::DateTime)
    get_several_symbols_to_ordereddict(dr, symbols, dt_start, dt_end)
end

function DataFrame(response::DataReaderResponseYahooDaily)
    r = response.r
    stream = IOBuffer(readstring(r))
    df = readtable(stream)
    df[:Date] = Date(df[:Date], "yyyy-mm-dd")
    df = df[end:-1:1, :]
    return df
end

function TimeArray(response::DataReaderResponseYahooDaily)
    df = DataFrame(response)
    ta_price = TimeArray(df, colnames=[:Open, :High, :Low, :Close, :Adj_Close])
    ta_volume = TimeArray(df, colnames=[:Volume])
    ta_price, ta_volume
end