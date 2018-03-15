## Love2d Conway's Game of Life (GPU Accelerated)

Just a little experiment in using an OpenGL fragment shader to calculate the next generation in a game of life. Most of the work is done inside `calculationShader.glsl`. `main.lua` handles shuffling the textures around to the fragment shader.

View more screenshots and information here : [abusing lovë2D pixel shaders](http://matt.egan.me/entry/abusing-love2d-pixel-shaders).

#### Controls
* `space` - stop/start the simulation
* `left click` - bring alive the cell underneath the mouse
* `left click` + `g` - spawn a glider underneath the mouse
* `right click` - kill the cell underneath the mouse
* `s` - "single step" the simulation (calculate the next generation)
* `up, down` - increase/decrease the simulation rate
* `r` - fill the screen with randomly alive or dead cells
* `c` - kill all the cells
* `h` - fill the entire screen with gliders (very fun to disturb)
