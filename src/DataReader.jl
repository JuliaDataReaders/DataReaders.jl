__precompile__()

#=
A [Julia](http://julialang.org/) library to get remote data 
via [Requests.jl](https://github.com/JuliaWeb/Requests.jl).

Inspired by [Pandas-DataReader](https://github.com/pydata/pandas-datareader).

get_components_yahoo
get_data_famafrench
get_data_google
get_data_yahoo
get_data_yahoo_actions
get_quote_google
get_quote_yahoo
DataReader
Options

=#

module DataReader

    export get, get_data_google, DataSource, DataReaderParameters, DataSymbol, DataSymbols

    import Base: convert
    import Requests: get, get_streaming
    import DataFrames: readtable, DataFrame, rename!
    import DataStructures: OrderedDict

    immutable DataSource
        s::AbstractString
    end
    Base.hash(src::DataSource, h::UInt) = hash(src.s, hash(:DataSource, h))
    Base.(:(==))(src1::DataSource, src2::DataSource) = isequal(src1.s, src2.s) 

    immutable DataReaderParameters
        retry_count::Int
        pause::AbstractFloat
    end

    immutable DataSymbol
        s::AbstractString
    end
    Base.hash(symb::DataSymbol, h::UInt) = hash(symb.s, hash(:DataSymbol, h))
    Base.(:(==))(symb1::DataSymbol, symb2::DataSymbol) = isequal(symb1.s, symb2.s) 

    convert(::Type{DataSymbol}, s::ASCIIString) = DataSymbol(s)
    typealias DataSymbols Array{DataSymbol,1}

    function get(source::DataSource, symb::DataSymbol, dt_start::Date, dt_end::Date, params::DataReaderParameters)
        s_source = uppercase(source.s)
        if s_source == "GOOG" then
            get_data_google(symb, dt_start, dt_end, params)
        elseif s_source == "YAHOO" then
            get_data_yahoo(symb, dt_start, dt_end, params)
        else
            error("'$(source.s)' is not an allowed data source")
        end
    end

    function get(source::DataSource, symbols::DataSymbols, dt_start::Date, dt_end::Date, params::DataReaderParameters)
        d = OrderedDict{DataSymbol,DataFrame}()
        for symb in symbols
            data = get(source, symb, dt_start, dt_end, params)
            d[symb] = data
        end
        return d
    end

    function get_data_yahoo(symbol::DataSymbol, dt_start::Date, dt_end::Date, params::DataReaderParameters)
        error("ToDo")
    end

    function get_data_google(symbol::DataSymbol, dt_start::Date, dt_end::Date, params::DataReaderParameters)
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

    function get_response(url::AbstractString, query::Dict{AbstractString,AbstractString}, params::DataReaderParameters)
        r = get_streaming(url; query = query, timeout = 30.0)
        if r.response.status / 100 != 2
            error("Error downloading data")
        end
        return r
    end

end
