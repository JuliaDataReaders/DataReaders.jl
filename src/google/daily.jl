type DataReaderResponseGoogleDaily <: DataReaderResponse
    r
end

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
    DataReaderResponseGoogleDaily(r)
end

function get(dr::DataReaderGoogleDaily, symbols::Vector{DataSymbol}, dt_start::DateTime, dt_end::DateTime)
    get_several_symbols_to_ordereddict(dr, symbols, dt_start, dt_end)
end

function DataFrame(response::DataReaderResponseGoogleDaily)
    r = response.r
    stream = IOBuffer(readstring(r))
    df = readtable(stream)  # from DataFrames.jl
    rename!(df, :_Date, :Date)
    df[:Date] = Date(df[:Date], "d-uuu-yy") + Base.Dates.Year(2000)
    df = df[end:-1:1, :]
    return df
end

function TimeArray(response::DataReaderResponseGoogleDaily)
    df = DataFrame(response)
    ta_price = TimeArray(df, colnames=[:Open, :High, :Low, :Close])
    ta_volume = TimeArray(df, colnames=[:Volume])
    ta_price, ta_volume
end
