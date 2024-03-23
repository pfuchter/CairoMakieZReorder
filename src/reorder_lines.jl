struct myline
    x::Vector{Float64}
    y::Vector{Float64}
    z::Vector{Float64}
    color::Any
    distance_to_camera::Float64
end

"""
`get_lines(ax)`

Returns all of the line objects in an axis `ax`.
"""
function get_lines(ax)
    lines = []
    for obj in ax.scene.plots
        if typeof(obj) == Lines{Tuple{Vector{Point{3,Float32}}}}
            push!(lines,obj)
        end
    end
    lines
end

"""
`get_line_data(line)`

Returns the x, y and z data of line object `line`
"""
function get_line_data(line)
    points = line[1][]
    xyz = hcat(points...)'
    x,y,z = xyz[:,1],xyz[:,2],xyz[:,3]
end

"""
`split_line(line,Nlines)`

Takes a Makie `line` object and splits into Nlines `myline` objects. 
"""
function split_line(line,Nlines,eyeposition)
    x,y,z = get_line_data(line)
    color = line.color[]
    Ndata = length(x)
    
    interp_x = linear_interpolation(1:Ndata,x)
    interp_y = linear_interpolation(1:Ndata,y)
    interp_z = linear_interpolation(1:Ndata,z)

    line_endpoints = range(1,Ndata,length=Nlines+1)    
    width = line_endpoints[2] - line_endpoints[1]

    newlines = Vector{myline}()

    new_line_discretisation = max(2,round(Ndata / Nlines)) |> Int

    for i in 1:Nlines
        #Make each subline 5% longer than original so sublines all overlap and there are no gaps        
        stretch_factor = 0.05 * (i != 1 && i != Nlines) + 0
        
        start = line_endpoints[i] - width*stretch_factor
        stop = line_endpoints[i+1] + width*stretch_factor

        xline = [interp_x(t) for t in range(start,stop,length=new_line_discretisation)]
        zline = [interp_z(t) for t in range(start,stop,length=new_line_discretisation)]
        yline = [interp_y(t) for t in range(start,stop,length=new_line_discretisation)]
        distance_from_cam = norm([mean(xline),mean(yline),mean(zline)] .- eyeposition)

        push!(newlines,myline(xline,yline,zline,color,distance_from_cam))
    end
    
    newlines
end

"""
`replot_lines!(ax,Nlines)`

Splits each line into `Nlines` lines and then replots all the lines in axis `ax` in order of distance from the camera. Allows for vectorized 3D axes using CairoMakie that respects Z-layering.
"""
function replot_lines!(ax,Nlines)
    lines_in_axis = get_lines(ax)
    x,y,z=get_line_data(lines_in_axis[1])

    newlines=vcat([split_line(lines_in_axis[i],Nlines,ax.scene.camera.eyeposition[]) for i in eachindex(lines_in_axis)]...)
    sort!(newlines,by=x->x.distance_to_camera)
    empty3!(ax,[Lines{Tuple{Vector{Point{3,Float32}}}}])
    for line in newlines[end:-1:1]
        lines!(ax,line.x,line.y,line.z,color=line.color)
    end
    nothing
end

