#!/usr/bin/env bash

julia -e 'Pkg.clone(pwd())'
julia -e 'Pkg.test("DataReader", coverage=true)'
