extern float grid_width;
extern float grid_height;

int cellOccupied(Image cells, vec2 cell_coord)  {
    int x = int(cell_coord.x * grid_width);
    int y = int(cell_coord.y * grid_height);
    if (x < 0 || x > grid_width ||
        y < 0 || y > grid_height) {
            return 0;
    } else if(Texel(cells, cell_coord) == vec4(1.0, 1.0, 1.0, 1.0)) {
        return 1;
    } else {
        return 0;
    }
}

int neighborCount(Image cells, vec2 c) {
    int neighborCount = 0;

    //we need to index the texture by coordinates [0, 1], so we need to
    //
    float x = c.x;
    float y = c.y;
    float xInc = 1.0 / float(grid_width);
    float yInc = 1.0 / float(grid_height);

    //checks right 3 cells
    neighborCount += cellOccupied(cells, vec2(c.x - xInc, c.y + yInc));
    neighborCount += cellOccupied(cells, vec2(c.x - xInc, c.y));
    neighborCount += cellOccupied(cells, vec2(c.x - xInc, c.y - yInc));

    //checks left 3 cells
    neighborCount += cellOccupied(cells, vec2(c.x + xInc, c.y + yInc));
    neighborCount += cellOccupied(cells, vec2(c.x + xInc, c.y));
    neighborCount += cellOccupied(cells, vec2(c.x + xInc, c.y - yInc));

    //checks middle 2 cells
    neighborCount += cellOccupied(cells, vec2(c.x, c.y + yInc));
    neighborCount += cellOccupied(cells, vec2(c.x, c.y - yInc));

    return neighborCount;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    bool alive = cellOccupied(texture, texture_coords) == 1;
    int neighborCount = neighborCount(texture, texture_coords);
    bool willBeAlive = false;
    //  if alive, lives if 2 or 3 surround it
    //  if dead, becomes alive is exactly 3 neighbors
    if (alive) {
        if (neighborCount == 2 || neighborCount == 3) {
            willBeAlive = true;
        }
    } else {
        if (neighborCount == 3) {
            willBeAlive = true;
        }
    }

    if (willBeAlive) {
        return vec4(1.0, 1.0, 1.0, 1.0);
    } else {
        return vec4(0.0, 0.0, 0.0, 1.0);
    }
}
