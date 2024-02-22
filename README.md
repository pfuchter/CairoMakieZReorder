# CairoMakieZReorder

[![Build Status](https://github.com/pfuchter/CairoMakieZReorder.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/pfuchter/CairoMakieZReorder.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/pfuchter/CairoMakieZReorder.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/pfuchter/CairoMakieZReorder.jl)

Exports replot_lines! and replot_surfaces! that replots all the lines and surfaces in an axis as many sub-lines and sub-surfaces so that Z-layering / depth / occlusions are correct from the view of the camera when exported from CairoMakie. Has the issue of increasingly large filesizes as you split surfaces up more and more, and small artefacts where sub-surfaces meet.

Example usage, that saves figures "line_test.pdf" and "surface_test.pdf":
```
function test_replot_surfaces()
        f = Figure()
        ax1 = Axis3(f[1,1],aspect=:data,title="Old")
        ax2 = Axis3(f[1,2],aspect=:data,title="New")
        
        x = [0 1; 0 1]
        y = [0 0; 1 1]
        z = [0 0; 0 0]
        s = surface!(ax1,x,y,z,color=fill(:red,1,1))
        s = surface!(ax2,x,y,z,color=fill(:red,1,1))
    
    
        x = [0 1; 0 1]
        y = [0 0; 1 1]
        z = [-1 1; -1 1]
        s = surface!(ax1,x,y,z,color=fill(:blue,1,1))
        s = surface!(ax2,x,y,z,color=fill(:blue,1,1))
        display(s.colorrange[])
    
        ax1.azimuth=4.1
        ax1.elevation=0.3
    
        ax2.azimuth=4.1
        ax2.elevation=0.3
    
        replot_surfaces!(ax2,4,4,20,20)
        
        f
    end
    

    function test_replot_lines()
        theta = 0:0.1:2*pi
        f = Figure(linewidth=5)
        ax1 = Axis3(f[1,1],title="Old")
        ax2 = Axis3(f[1,2],title="New")
    
        ax1.azimuth=4.7
        ax1.elevation=0.05
    
        ax2.azimuth=4.7
        ax2.elevation=0.05
    
        lines!(ax1,[0,0],[0,0],[-1,1])  
        lines!(ax1,cos.(theta),sin.(theta),cos.(theta))
        lines!(ax1,1.5.*cos.(theta),1.5.*sin.(theta),2 .*cos.(theta))
    
        lines!(ax2,[0,0],[0,0],[-1,1])  
        lines!(ax2,cos.(theta),sin.(theta),cos.(theta))
        lines!(ax2,1.5.*cos.(theta),1.5.*sin.(theta),2 .*cos.(theta))
        
        replot_lines!(ax2,20)
        f
    end    

    f1=test_replot_lines()
    save("line_test.pdf",f1)

    f2=test_replot_surfaces()
    save("surface_test.pdf",f2)
```

Corrected surfaces:
![image](https://github.com/pfuchter/CairoMakieZReorder/assets/93337642/645466cb-6212-45cb-8966-866c53085744)

Corrected lines:
![image](https://github.com/pfuchter/CairoMakieZReorder/assets/93337642/6cacc7c0-e26d-4409-8d8d-f401d1e86327)



