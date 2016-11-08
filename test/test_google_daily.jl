using Base.Test

using DataReaders

dr = DataReader("google");

symb = DataSymbol("MSFT");

dt_start = DateTime("2015-04-01");

dt_end = DateTime("2015-04-15");

data = get(dr, symb, dt_start, dt_end);

