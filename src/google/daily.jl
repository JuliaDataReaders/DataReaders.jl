function get(source::DataSourceGoogleDaily, symb::DataSymbol, dt_start::DateTime, dt_end::DateTime; params=DEFAULT_PARAMS)
    url = "http://www.google.com/finance/historical"
    fmt = "uuu dd, yyyy"  # "%b %d, %Y"
    query = Dict{AbstractString,AbstractString}(
        "q" => symb.s,
        "startdate" => Dates.format(dt_start, fmt),
        "enddate" => Dates.format(dt_end, fmt),
        "output" => "csv"
    )
    r = get_response(url, query, params)
    df = readtable(r)
    rename!(df, :_Date, :Date)
    df[:Date] = Date(df[:Date], "d-uuu-yy") + Base.Dates.Year(2000)
    return df
end

function get(source::DataSourceGoogleDaily, symbols::DataSymbols, dt_start::DateTime, dt_end::DateTime; params=DEFAULT_PARAMS)
    get_several_symbols_to_ordereddict(source, symbols, dt_start, dt_end, params=params)
end
