"""
`empty3!(ax,types)`

Removes all objects from axis `ax` that have type contained in vector of types `types`
"""
function empty3!(ax,types)
    c = 0
    for i = 1:length(ax.scene.plots)
        if typeof(ax.scene.plots[i+c]) in types
            delete!(ax.scene,ax.scene.plots[i+c])            
            c = c - 1
        end
    end
end

"""
`empty3!(ax,)`

Removes all lines in vector `lines_to_delete` from axis `ax`
"""
function empty3!(ax,lines_to_delete::Vector{Lines{Tuple{Vector{Point{3,Float32}}}}})
    c = 0
    for i = 1:length(ax.scene.plots)
        if ax.scene.plots[i+c] in lines_to_delete
            delete!(ax.scene,ax.scene.plots[i+c])            
            c = c - 1
        end
    end
end


mean(x) = sum(x) / length(x)
norm(x) = sqrt(sum(x.^2))

