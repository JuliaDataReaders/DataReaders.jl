# DataReader.jl

WORK IN PROGRESS!!! NOT USABLE FOR NOW!!!

A [Julia](http://julialang.org/) library to get remote data via [Requests.jl](https://github.com/JuliaWeb/Requests.jl) and get DataFrames thanks to [DataFrames.jl](https://dataframesjl.readthedocs.org/).

Inspired by [Pandas-DataReader](https://github.com/pydata/pandas-datareader).

## Install

```julia
Pkg.clone("https://github.com/femtotrader/DataReader.jl.git")
```

## Usage

### Import DataReader
```julia
using DataReader
```

### Google daily finance

#### One symbol
```julia
julia> source = DataSource("google");

julia> symb = DataSymbol("MSFT");

julia> dt_start = Date("2015-04-01");

julia> dt_end = Date("2015-04-15");

julia> data = get(source, symb, dt_start, dt_end);

julia> println(data);
10x6 DataFrames.DataFrame
│ Row │ Date       │ Open  │ High  │ Low   │ Close │ Volume   │
┝━━━━━┿━━━━━━━━━━━━┿━━━━━━━┿━━━━━━━┿━━━━━━━┿━━━━━━━┿━━━━━━━━━━┥
│ 1   │ 2015-04-15 │ 41.76 │ 42.46 │ 41.68 │ 42.26 │ 27343581 │
│ 2   │ 2015-04-14 │ 41.8  │ 42.03 │ 41.39 │ 41.65 │ 24244382 │
│ 3   │ 2015-04-13 │ 41.4  │ 42.06 │ 41.39 │ 41.76 │ 30276692 │
│ 4   │ 2015-04-10 │ 41.63 │ 41.95 │ 41.41 │ 41.72 │ 28022002 │
│ 5   │ 2015-04-09 │ 41.25 │ 41.62 │ 41.25 │ 41.48 │ 25723861 │
│ 6   │ 2015-04-08 │ 41.46 │ 41.69 │ 41.04 │ 41.42 │ 24753438 │
│ 7   │ 2015-04-07 │ 41.61 │ 41.91 │ 41.31 │ 41.53 │ 28809375 │
│ 8   │ 2015-04-06 │ 40.34 │ 41.78 │ 40.18 │ 41.54 │ 39223692 │
│ 9   │ 2015-04-02 │ 40.66 │ 40.74 │ 40.12 │ 40.29 │ 37487476 │
│ 10  │ 2015-04-01 │ 40.6  │ 40.76 │ 40.31 │ 40.72 │ 36865322 │
```

#### Several symbols

```julia
julia> source = DataSource("google");

julia> symbols = DataSymbols(["IBM", "MSFT"])
2-element Array{DataReader.DataSymbol,1}:
 DataReader.DataSymbol("IBM")
 DataReader.DataSymbol("MSFT")

julia> dt_start = Date("2015-04-01");

julia> dt_end = Date("2015-04-15");

julia> data = get(source, symbols, dt_start, dt_end);

julia> println(data)
DataStructures.OrderedDict(DataReader.DataSymbol("IBM")=>10x6 DataFrames.DataFrame
│ Row │ Date       │ Open   │ High   │ Low    │ Close  │ Volume  │
┝━━━━━┿━━━━━━━━━━━━┿━━━━━━━━┿━━━━━━━━┿━━━━━━━━┿━━━━━━━━┿━━━━━━━━━┥
│ 1   │ 2015-04-15 │ 162.63 │ 164.96 │ 162.5  │ 164.13 │ 3498756 │
│ 2   │ 2015-04-14 │ 162.42 │ 162.74 │ 160.79 │ 162.3  │ 2719287 │
│ 3   │ 2015-04-13 │ 162.37 │ 164.0  │ 162.36 │ 162.38 │ 3868911 │
│ 4   │ 2015-04-10 │ 162.34 │ 163.33 │ 161.25 │ 162.86 │ 2515703 │
│ 5   │ 2015-04-09 │ 161.7  │ 162.47 │ 160.72 │ 162.34 │ 2263490 │
│ 6   │ 2015-04-08 │ 161.72 │ 163.55 │ 161.01 │ 161.85 │ 2524323 │
│ 7   │ 2015-04-07 │ 161.67 │ 163.84 │ 161.62 │ 162.07 │ 3147975 │
│ 8   │ 2015-04-06 │ 159.69 │ 162.8  │ 158.7  │ 162.04 │ 3465682 │
│ 9   │ 2015-04-02 │ 159.52 │ 162.54 │ 158.89 │ 160.45 │ 4671578 │
│ 10  │ 2015-04-01 │ 160.23 │ 160.62 │ 158.39 │ 159.18 │ 3700791 │,DataReader.DataSymbol("MSFT")=>10x6 DataFrames.DataFrame
│ Row │ Date       │ Open  │ High  │ Low   │ Close │ Volume   │
┝━━━━━┿━━━━━━━━━━━━┿━━━━━━━┿━━━━━━━┿━━━━━━━┿━━━━━━━┿━━━━━━━━━━┥
│ 1   │ 2015-04-15 │ 41.76 │ 42.46 │ 41.68 │ 42.26 │ 27343581 │
│ 2   │ 2015-04-14 │ 41.8  │ 42.03 │ 41.39 │ 41.65 │ 24244382 │
│ 3   │ 2015-04-13 │ 41.4  │ 42.06 │ 41.39 │ 41.76 │ 30276692 │
│ 4   │ 2015-04-10 │ 41.63 │ 41.95 │ 41.41 │ 41.72 │ 28022002 │
│ 5   │ 2015-04-09 │ 41.25 │ 41.62 │ 41.25 │ 41.48 │ 25723861 │
│ 6   │ 2015-04-08 │ 41.46 │ 41.69 │ 41.04 │ 41.42 │ 24753438 │
│ 7   │ 2015-04-07 │ 41.61 │ 41.91 │ 41.31 │ 41.53 │ 28809375 │
│ 8   │ 2015-04-06 │ 40.34 │ 41.78 │ 40.18 │ 41.54 │ 39223692 │
│ 9   │ 2015-04-02 │ 40.66 │ 40.74 │ 40.12 │ 40.29 │ 37487476 │
│ 10  │ 2015-04-01 │ 40.6  │ 40.76 │ 40.31 │ 40.72 │ 36865322 │)
```

## Done / ToDo

###Done:

- Yahoo Finance daily DataReader
- Support several symbols for Google Finance daily DataReader - return as OrderedDict
- Google Finance daily DataReader (only one symbol at a time)

###ToDo:

 - Support several symbols for Google (daily) DataReader - return as Panel (see https://github.com/JuliaStats/DataFrames.jl/issues/941 )
 - Support others data source (Yahoo...)
 - Requests-cache mechanism (see https://github.com/JuliaLang/HDF5.jl/issues/296 )
 - Unit testing
 - Continuous Integration
 - Packaging
 - ...
 