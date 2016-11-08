using Base.Test

using DataReaders

dr = DataReader("google-quotes")

symb = DataSymbol("MSFT")

data = get(dr, symb)
