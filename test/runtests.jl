using Base.Test

using DataReaders

include("test_google_daily.jl")
# include("test_google_quote.jl")  # ToDo
include("test_yahoo_daily.jl")

@test 1 == 1
