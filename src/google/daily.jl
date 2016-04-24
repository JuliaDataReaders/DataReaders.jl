function get(dr::DataReaderGoogleDaily, symb::DataSymbol, dt_start::DateTime, dt_end::DateTime)
    url = "http://www.google.com/finance/historical"
    fmt = "uuu dd, yyyy"  # "%b %d, %Y"
    query = Dict{AbstractString,AbstractString}(
        "q" => symb.s,
        "startdate" => Dates.format(dt_start, fmt),
        "enddate" => Dates.format(dt_end, fmt),
        "output" => "csv"
    )
    r = get_response(url, query, dr)
    stream = IOBuffer(readall(r))
    df = readtable(stream)  # from DataFrames.jl
    #df = readtimearray(r.response)  # from TimeSeries.jl
    rename!(df, :_Date, :Date)
    df[:Date] = Date(df[:Date], "d-uuu-yy") + Base.Dates.Year(2000)
    df = df[end:-1:1, :]
    return df
end

function get(dr::DataReaderGoogleDaily, symbols::DataSymbols, dt_start::DateTime, dt_end::DateTime)
    get_several_symbols_to_ordereddict(dr, symbols, dt_start, dt_end)
end
