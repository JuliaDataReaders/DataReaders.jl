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

    immutable DataSource
        s::AbstractString
    end
    Base.hash(src::DataSource, h::UInt) = hash(src.s, hash(:DataSource, h))
    Base.(:(==))(src1::DataSource, src2::DataSource) = isequal(src1.s, src2.s) 

    immutable DataReaderParameters
        retry_count::Int
        pause::AbstractFloat
        timeout::AbstractFloat
    end
    DEFAULT_PARAMS = DataReaderParameters(3, 0.1, 30)

    immutable DataSymbol
        s::AbstractString
    end
    Base.hash(symb::DataSymbol, h::UInt) = hash(symb.s, hash(:DataSymbol, h))
    Base.(:(==))(symb1::DataSymbol, symb2::DataSymbol) = isequal(symb1.s, symb2.s) 

    convert(::Type{DataSymbol}, s::ASCIIString) = DataSymbol(s)
    typealias DataSymbols Array{DataSymbol,1}

    include("google/daily.jl")
    include("yahoo/daily.jl")

    #=
    f_dict = Dict{ASCIIString,Function}(
        "google"=>get_data_google,
        "yahoo"=>get_data_yahoo
    )
    =#

    function get(source::DataSource, symb::DataSymbol, dt_start::Date, dt_end::Date; params=DEFAULT_PARAMS)
        s_source = lowercase(source.s)
        if s_source == "google" then
            get_data_google(symb, dt_start, dt_end, params=params)
        elseif s_source == "yahoo" then
            get_data_yahoo(symb, dt_start, dt_end, params=params)
        else
            error("'$(source.s)' is not an allowed data source")
        end
    end

    function get_several_symbols_to_ordereddict(source::DataSource, symbols::DataSymbols, dt_start::Date, dt_end::Date; params=params::DataReaderParameters)
        d = OrderedDict{DataSymbol,DataFrame}()
        for symb in symbols
            data = get(source, symb, dt_start, dt_end, params=params)
            d[symb] = data
        end
        return d
    end

    function get(source::DataSource, symbols::DataSymbols, dt_start::Date, dt_end::Date; params=DEFAULT_PARAMS)
        s_source = lowercase(source.s)
        if s_source in ["google", "yahoo"] then
            get_several_symbols_to_ordereddict(source, symbols, dt_start, dt_end, params=params)
        else
            error("'$(source.s)' is not an allowed data source")
        end        
    end

    function get_response(url::AbstractString, query::Dict{AbstractString,AbstractString}, params::DataReaderParameters)
        r = get_streaming(url; query = query, timeout = params.timeout)
        if r.response.status / 100 != 2
            error("Error downloading data")
        end
        return r
    end

end



