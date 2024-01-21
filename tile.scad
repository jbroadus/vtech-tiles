// Base tile bounds (not including extruded text).
tile_size = [40, 37, 10.5];
// Key cutout box size.
key_area_size = [24.5, 4, 6.5];
// Individual key size.
key_size = [2, 4, 6.5];
// Radius of circle used for minkowski function.
radius = 11;

// Text
font = "Cantarell Bold";
text_size = 24;
// Extrusion height
text_depth = 5;
// Radius of circle used for minkowski function.
text_radius = 2;

tile_blank = [[0,0,0,0,0,0], " "];

tile_a =  [[1,0,0,0,0,1], "A"];
tile_b =  [[1,0,0,1,0,1], "B"];
tile_c =  [[1,0,1,0,0,1], "C"];
tile_d =  [[1,0,1,1,0,1], "D"];
tile_e =  [[1,0,0,0,1,0], "E"];
tile_f =  [[1,0,0,1,1,0], "F"];
tile_g =  [[1,0,1,0,1,0], "G"];
tile_h =  [[1,0,1,1,1,0], "H"];
tile_i =  [[1,0,0,0,1,1], "I"];
tile_j =  [[1,0,0,1,1,1], "J"];
tile_k =  [[1,0,1,0,1,1], "K"];
tile_l =  [[1,0,1,1,1,1], "L"];
tile_m =  [[0,1,0,0,0,1], "M"];
tile_n =  [[0,1,0,1,0,1], "N"];
tile_o =  [[0,1,1,0,0,1], "O"];
tile_p =  [[0,1,1,1,0,1], "P"];
tile_q =  [[0,1,0,0,1,0], "Q"];
tile_r =  [[0,1,0,1,1,0], "R"];
tile_s =  [[0,1,1,0,1,0], "S"];
tile_t =  [[0,1,1,1,1,0], "T"];
tile_u =  [[0,1,0,0,1,1], "U"];
tile_v =  [[0,1,0,1,1,1], "V"];
tile_w =  [[0,1,1,0,1,1], "W"];
tile_x =  [[0,1,1,1,1,1], "X"];
tile_y =  [[1,1,0,0,0,1], "Y"];
tile_z =  [[1,1,0,1,0,1], "Z"];

tile_1 =  [[1,1,1,0,0,1], "1"];
tile_2 =  [[1,1,1,1,0,1], "2"];
tile_3 =  [[1,1,0,0,1,0], "3"];
tile_4 =  [[1,1,0,1,1,0], "4"];
tile_5 =  [[1,1,1,0,1,0], "5"];
tile_6 =  [[1,1,1,1,1,0], "6"];
tile_7 =  [[1,1,0,0,1,1], "7"];
tile_8 =  [[1,1,0,1,1,1], "8"];
tile_9 =  [[1,1,1,0,1,1], "9"];
tile_10 = [[1,1,1,1,1,1], "10"];

// This variable can be set on the command line.
which_tile=tile_j;

// Build the tile.
tile(which_tile);

module half_tile_poly() {
    left=0;
    right=tile_size[0]/2-radius;
    bottom=radius;
    top=tile_size[1]-radius;
    mid=(top+bottom)/2;
    mirror([1,0,0]) polygon([[left, bottom], [left+1, bottom], [right, bottom+1], [right, mid], [right-1, top-1.5], [left+2,top], [left,top]]);
}

module tile_poly() {
    union() {
        half_tile_poly();
        mirror([1,0,0]) half_tile_poly();
    }
}

module tile_2d() {
    minkowski()
    {
        tile_poly();
        circle(r=radius);
    }
}

module tile_3d(txt) {
    union() {
        linear_extrude(height=tile_size[2])
            tile_2d();
        translate([0,tile_size[1]/2,tile_size[2]])
            linear_extrude(height=text_depth)
                minkowski() {
                    text(txt, halign="center", valign="center", size=text_size, font=font);
                    circle(r=text_radius);
                }
    };
}

module keys(bits) {
    key_space=key_area_size[0] / 6;
    offset = (key_space - key_size[0])/2;
    for (k=[0:5])
        if(bits[k]) {
            key_pos = key_space * k + offset;
            translate([key_pos, 0, 0])
            cube(key_size, center=false);
        }
}

module key_area_neg(bits) {
    translate([-key_area_size[0]/2,0,0])
    difference() {
        cube(key_area_size, center=false);
        keys(bits);
    };
}

module tile(info) {
    difference() {
        tile_3d(info[1]);
        key_area_neg(info[0]);
    };
}
