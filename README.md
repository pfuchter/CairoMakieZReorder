# CairoMakieZReorder

[![Build Status](https://github.com/pfuchter/CairoMakieZReorder.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/pfuchter/CairoMakieZReorder.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/pfuchter/CairoMakieZReorder.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/pfuchter/CairoMakieZReorder.jl)

Exports replot_lines! and replot_surfaces! that replots all the lines and surfaces in an axis as many sub-lines and sub-surfaces so that Z-layering / depth / occlusions are correct from the view of the camera when exported from CairoMakie. Has the issue of increasingly large filesizes as you split surfaces up more and more, and small artefacts where sub-surfaces meet.
