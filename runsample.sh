#!/usr/bin/env bash

#rm -rf ~/.julia/v0.4/DataReader
#rm -rf ~/.julia/lib/v0.4/DataReader.ji

julia -e 'Pkg.rm("DataReader")'
#julia -e 'Pkg.clone("https://github.com/femtotrader/DataReader.jl.git")'
julia -e 'Pkg.clone(pwd())'
julia -e 'Pkg.checkout("DataReader")'

#julia -e 'Pkg.test("DataReader", coverage=true)'

julia -e'Pkg.build("DataReader")'

julia sample.jl
