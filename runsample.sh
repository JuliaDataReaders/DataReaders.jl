#!/usr/bin/env bash

julia -e 'Pkg.rm("DataReader")'
#julia -e 'Pkg.clone("https://github.com/femtotrader/DataReader.jl.git")'
julia -e 'Pkg.clone(pwd())'

#julia -e 'Pkg.test("DataReader", coverage=true)'

julia -e'Pkg.build("DataReader")'

julia sample.jl
