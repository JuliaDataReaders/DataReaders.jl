#__precompile__()

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
    #import RequestsCache: Session, CacheSession, get

    abstract DataSource
    type DataSourceGoogleDaily <: DataSource end
    type DataSourceGoogleQuotes <: DataSource end
    type DataSourceYahooDaily <: DataSource end

    function DataSource(s_source)
        if s_source == "google" then
            DataSourceGoogleDaily()
        elseif s_source == "google-quotes" then
            DataSourceGoogleQuotes()
        elseif s_source == "yahoo" then
            DataSourceYahooDaily()
        else
            error("'$s_source' is not an allowed data source")
        end
    end

    immutable DataReaderParameters
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
    end
    DEFAULT_PARAMS = DataReaderParameters(3, 0.1, 30)
    DEFAULT_DT_END = now(Dates.UTC)
    DEFAULT_DT_START = DEFAULT_DT_END - Dates.Day(7)

    immutable DataSymbol
        s::AbstractString
    end
    Base.hash(symb::DataSymbol, h::UInt) = hash(symb.s, hash(:DataSymbol, h))
    Base.(:(==))(symb1::DataSymbol, symb2::DataSymbol) = isequal(symb1.s, symb2.s) 

    convert(::Type{DataSymbol}, s::ASCIIString) = DataSymbol(s)
    typealias DataSymbols Array{DataSymbol,1}

    include("google/daily.jl")
    include("google/quotes.jl")
    include("yahoo/daily.jl")

    function get_several_symbols_to_ordereddict(source::DataSource, symbols::DataSymbols, args...; kwargs...)
        d = OrderedDict{DataSymbol,DataFrame}()
        for symb in symbols
            data = get(source, symb, args...; kwargs...)
            d[symb] = data
        end
        return d
    end

    function get_response(url::AbstractString, query::Dict{AbstractString,AbstractString}, params::DataReaderParameters)
        r = get_streaming(url; query = query, timeout = params.timeout)
        if r.response.status / 100 != 2
            error("Error downloading data")
        end
        return r
    end

end



