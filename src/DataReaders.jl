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

    export get, DataReader, DataSymbol, DataSymbols
    export DataFrame, TimeArray

    import Base: convert
    import Requests: get, get_streaming
    import DataFrames: readtable, DataFrame, rename!
    import TimeSeries: readtimearray
    import DataStructures: OrderedDict
    import RequestsCache: create_query, execute

    abstract DataReader
    type DataReaderGoogleDaily <: DataReader
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
        session
    end
    type DataReaderGoogleQuotes <: DataReader
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
        session
    end
    type DataReaderYahooDaily <: DataReader
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
        session
    end
    
    abstract DataReaderResponse

    function DataReader(s_source::String; retry_count=3, pause=0.1, timeout=30, session=nothing)
        s_source = lowercase(s_source)
        if s_source in ["google", "google-daily"]
            DataReaderGoogleDaily(retry_count, pause, timeout, session)
        elseif s_source == "google-quotes"
            DataReaderGoogleQuotes(retry_count, pause, timeout, session)
        elseif s_source in ["yahoo", "yahoo-daily"]
            DataReaderYahooDaily(retry_count, pause, timeout, session)
        else
            error("'$s_source' is not an allowed data source")
        end
    end

    DEFAULT_DT_END = now(Dates.UTC)
    DEFAULT_DT_START = DEFAULT_DT_END - Dates.Day(7)

    immutable DataSymbol
        s::AbstractString
    end
    Base.hash(symb::DataSymbol, h::UInt) = hash(symb.s, hash(:DataSymbol, h))
    Base.:(==)(symb1::DataSymbol, symb2::DataSymbol) = isequal(symb1.s, symb2.s) 

    convert(::Type{DataSymbol}, s::String) = DataSymbol(s)
    typealias DataSymbols Array{DataSymbol,1}

    include("google/daily.jl")
    include("google/quotes.jl")
    include("yahoo/daily.jl")

    function get_several_symbols_to_ordereddict(dr::DataReader, symbols::DataSymbols, args...; kwargs...)
        d = OrderedDict{DataSymbol,DataReaderResponse}()
        for symb in symbols
            data = get(dr, symb, args...; kwargs...)
            d[symb] = data
        end
        return d
    end

    function get_response(url::AbstractString, query::Dict{AbstractString,AbstractString}, dr::DataReader)
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

    function DataFrame(multi_symbol_response::OrderedDict{DataSymbol,DataReaderResponse})
        d = OrderedDict{DataSymbol,DataFrame}()
        for (symb, response) in multi_symbol_response
            d[symb] = DataFrame(response)
        end
        return d    
    end

end
