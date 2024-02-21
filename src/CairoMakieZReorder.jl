module CairoMakieZReorder

using CairoMakie, Interpolations

include("useful_functions.jl") #empty3!, mean, norm
include("reorder_lines.jl")
include("reorder_surfaces.jl")

export empty3!
export replot_lines!
export replot_surfaces!


end # module CairoMakieZReorder
