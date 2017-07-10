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

module DataReaders

    export get, DataReader, DataSymbol
    export DataFrame, TimeArray
    export D_DATAREADERS
    
    import Base: convert
    import Requests: get, get_streaming
    import DataFrames: readtable, DataFrame, rename!
    import DataStructures: OrderedDict
    import RequestsCache: create_query, execute
    using TimeSeriesIO: TimeArray

    abstract type AbstractDataReader end
    struct DataReaderGoogleDaily <: AbstractDataReader
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
        session
    end
    struct DataReaderGoogleQuotes <: AbstractDataReader
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
        session
    end
    struct DataReaderYahooDaily <: AbstractDataReader
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
        session
    end
    
    abstract type AbstractDataReaderResponse end

    D_DATAREADERS = OrderedDict(
        "google" => DataReaderGoogleDaily,
        "google-daily" => DataReaderGoogleDaily,
        "google-quotes" => DataReaderGoogleQuotes,
        "yahoo" => DataReaderYahooDaily,
        "yahoo-daily" => DataReaderYahooDaily
    )

    function DataReader(s_source::String; retry_count=3, pause=0.1, timeout=30, session=nothing)
        s_source = lowercase(s_source)
        if haskey(D_DATAREADERS, s_source)
            dr = D_DATAREADERS[s_source]
            dr(retry_count, pause, timeout, session)
        else
            allowed_data_source = keys(D_DATAREADERS)
            s_allowed_data_source = "[" * join(map(s->"\""*s*"\"", allowed_data_source), ", ") * "]"
            error("'$s_source' is not an allowed data source. It must be in $s_allowed_data_source.")
        end
    end

    DEFAULT_DT_END = now(Dates.UTC)
    DEFAULT_DT_START = DEFAULT_DT_END - Dates.Day(7)

    struct DataSymbol
        s::AbstractString
    end
    Base.hash(symb::DataSymbol, h::UInt) = hash(symb.s, hash(:DataSymbol, h))
    Base.:(==)(symb1::DataSymbol, symb2::DataSymbol) = isequal(symb1.s, symb2.s) 

    convert(::Type{DataSymbol}, s::String) = DataSymbol(s)

    include("google/daily.jl")
    include("google/quotes.jl")
    include("yahoo/daily.jl")

    function get_several_symbols_to_ordereddict(dr::AbstractDataReader, symbols::Vector{DataSymbol}, args...; kwargs...)
        d = OrderedDict{DataSymbol,AbstractDataReaderResponse}()
        for symb in symbols
            data = get(dr, symb, args...; kwargs...)
            d[symb] = data
        end
        return d
    end

    function get_response(url::AbstractString, query::Dict{AbstractString,AbstractString}, dr::AbstractDataReader)
        if dr.session==nothing
            #r = get_streaming(url; query = query, timeout = dr.timeout)
            r = get(url; query = query, timeout = dr.timeout)
        else
            #error("cached session not supported")
            #r = get(dr.session, url; query = query)
            prepared_query = create_query("get", url; query = query, timeout = dr.timeout)
            r = execute(prepared_query; session=dr.session)
        end
        #println(r)
        #println(typeof(r))
        #println(r.response)
        #if r.response.status / 100 != 2
        if r.status / 100 != 2
            error("Error downloading data")
        end
        return r
    end

    function DataFrame(multi_symbol_response::OrderedDict{DataSymbol,AbstractDataReaderResponse})
        d = OrderedDict{DataSymbol,DataFrame}()
        for (symb, response) in multi_symbol_response
            d[symb] = DataFrame(response)
        end
        return d    
    end

end
