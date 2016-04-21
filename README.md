# DataReader.jl

WORK IN PROGRESS!!! NOT USABLE FOR NOW!!!

A [Julia](http://julialang.org/) library to get remote data via [Requests.jl](https://github.com/JuliaWeb/Requests.jl).

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
source = DataSource("GOOG")
params = DataReaderParameters(3, 0.1)  # default parameters for DataReader (retry_count, pause, cache...)

symb = DataSymbol("MSFT")

dt_start = Date("2015-04-01")
dt_end = Date("2015-04-15")

data = get(source, symb, dt_start, dt_end, params)
```

#### Several symbols

```julia
source = DataSource("GOOG")
params = DataReaderParameters(3, 0.1)  # default parameters for DataReader (retry_count, pause, cache...)

symbols = DataSymbols(["IBM", "MSFT"])

dt_start = Date("2015-04-01")
dt_end = Date("2015-04-15")

data = get(source, symbols, dt_start, dt_end, params)

println(data)
```

## Done / ToDo

###Done:

- Support several symbols for Google (daily) DataReader - return as OrderedDict
- Google daily DataReader (only one symbol at a time)

###ToDo:

 - Support several symbols for Google (daily) DataReader - return as Panel (see https://github.com/JuliaStats/DataFrames.jl/issues/941 )
 - Support others data source (Yahoo...)
 - Requests-cache mechanism (see https://github.com/JuliaLang/HDF5.jl/issues/296 )
 - Unit testing
 - Continuous Integration
 - Packaging
 - ...
 