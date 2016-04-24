function get(source::DataSourceYahooDaily, symb::DataSymbol, dt_start::DateTime, dt_end::DateTime; params=DEFAULT_PARAMS)
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
    r = get_response(url, query, params)
    df = readtable(r)
    df[:Date] = Date(df[:Date], "yyyy-mm-dd")
    return df
end

function get(source::DataSourceYahooDaily, symbols::DataSymbols, dt_start::DateTime, dt_end::DateTime; params=DEFAULT_PARAMS)
    get_several_symbols_to_ordereddict(source, symbols, dt_start, dt_end, params=params)
end
