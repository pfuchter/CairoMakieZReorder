struct mysurface
    x::Matrix{Float64}
    y::Matrix{Float64}
    z::Matrix{Float64}
    color::Any
    distance_to_camera::Float64
end


"""
`split_surface(surface,Nx,Ny,eyeposition)`

Splits up surface `surface` into `Nx*Ny` sub-surfaces and returns a vector of `mysurface` objects.

`Nx` and `Ny` are the number of sub-surfaces in the x and y directions respectively. (e.g. how the x,y,z matrices of the surface are split up)

`eyeposition` is the position of the camera in 3D space and is used to sort the sub-surfaces by distance from the camera.
"""
function split_surface(surface,Nx,Ny,eyeposition)
    s = surface
    x = s[1][]
    y = s[2][]
    z = s[3][]
    color = s.color[]
    # colorrange = s.colorrange[]

    # if s.color[] isa Matrix{Float32}
    #     colorrange = (minimum(s.color[]),maximum(s.color[]))
    # else
    #     colorrange = nothing
    # end

    newsurfaces=Vector{mysurface}()

    interp_x = linear_interpolation((1:size(x,1),1:size(x,2)),x)
    interp_y = linear_interpolation((1:size(y,1),1:size(y,2)),y)
    interp_z = linear_interpolation((1:size(z,1),1:size(z,2)),z)

    total_width  = size(x,2)-1
    total_height = size(x,1)-1

    sub_surface_width = total_width/Ny
    sub_surface_height = total_height/Nx

    sub_surface_Nx = 20
    sub_surface_Ny = 20

    for i in 1:Nx
        for j in 1:Ny                        
            row_start = 1+(i-1)*sub_surface_height
            row_end = 1+i*sub_surface_height
            col_start = 1+(j-1)*sub_surface_width
            col_end = 1+j*sub_surface_width

            x_surface = [interp_x(i,j) for i in range(row_start,row_end,length=sub_surface_Nx), j in range(col_start,col_end,length=sub_surface_Ny)]
            y_surface = [interp_y(i,j) for i in range(row_start,row_end,length=sub_surface_Nx), j in range(col_start,col_end,length=sub_surface_Ny)]
            z_surface = [interp_z(i,j) for i in range(row_start,row_end,length=sub_surface_Nx), j in range(col_start,col_end,length=sub_surface_Ny)]
            distance_from_cam = norm([mean(x_surface),mean(y_surface),mean(z_surface)] .- eyeposition)
            push!(newsurfaces,mysurface(x_surface,y_surface,z_surface,s.color,distance_from_cam))
        end
    end
    return newsurfaces
end


function get_surfaces(ax)
    surfaces = []
    for obj in ax.scene.plots
        if typeof(obj) == Surface{Tuple{Matrix{Float32}, Matrix{Float32}, Matrix{Float32}}}
            push!(surfaces,obj)
        end
    end
    surfaces
end

"""
`replot_surfaces!(ax)`

Splits each surface into many surfaces and then replots all the lines in axis `ax` in order of distance from the camera. Allows for vectorized 3D axes using CairoMakie that respects Z-layering.
"""
function replot_surfaces!(ax)
    surfaces_in_axis = get_surfaces(ax)
    newsurfaces=vcat([split_surface(surfaces_in_axis[i],5,4,ax.scene.camera.eyeposition[]) for i in eachindex(surfaces_in_axis)]...)
    sort!(newsurfaces,by=x->x.distance_to_camera)
    empty3!(ax,[Surface{Tuple{Matrix{Float32}, Matrix{Float32}, Matrix{Float32}}}])

    
    for s in newsurfaces[end:-1:1]
            surface!(ax,s.x,s.y,s.z,color=s.color)
    end
    nothing
end

