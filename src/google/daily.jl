function get_data_google(symbol::DataSymbol, dt_start::Date, dt_end::Date; params=DEFAULT_PARAMS)
    url = "http://www.google.com/finance/historical"
    fmt = "uuu dd, yyyy"  # "%b %d, %Y"
    query = Dict{AbstractString,AbstractString}(
        "q" => symbol.s,
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
