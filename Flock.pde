int [][][] world; 
int sx, sy;
int x, y;
int pressG = 0;
int pressSpace = 0;
int current = 0, next =1;
float density = 0.5;

void setup(){  
  size(600, 600);
  frameRate(30);
  sx = 100;
  sy = 100;
  background(0);
  world = new int [sx][sy][2];
  for(int i = 0; i < sx; i++){
    for(int j = 0; j < sy; j++){
      world [i][j][current] = 0;
      world [i][j][next] = 0;
    }
  }
  //stop the loop at the beginning
  noLoop();
}

void draw(){
  for(int i = 0; i < sx; i++){
    for(int j = 0; j < sy; j++){
      fill (world[i][j][next]%2*255);
      rect(i*6, j*6, 6, 6); 
    }
  }
  //control the life simulation
  if(((pressG%2) == 1 || (pressSpace > 0))){
    Swap();
    for(int i = 0; i < sx; i++){
      for(int j = 0; j < sy; j++){
         int count = Neighbors (i, j);
         if ((world[i][j][current] == 0 )&& (count ==3)){
           world[i][j][next] = 1;
         }
         if ((world[i][j][current] == 0 )&& (count !=3)){
           world[i][j][next] = 0;
         } 
         if ((world[i][j][current] == 1)&&((count <2)||(count >3))){
           world [i][j][next] = 0;
         }
         if ((world[i][j][current] == 1)&&((count == 2)||(count == 3))){
            world [i][j][next] = 1;
         }
      }
    }
  }
}

//create cell patterns by mouse clicks
void mousePressed(){
  x = mouseX;
  y = mouseY;
  world [x/6][y/6][next] = (world [x/6][y/6][next] +1)%2;
  //prevent the automatical life simulation
  pressG = 0;
  pressSpace = 0;
  //conduct one draw to create one point
  redraw();
}

//method to determine the number of the neighbors from eight cells 
//and the grid of cells can be toroidal by the expression like 'x + sx - 1) % sx'
int Neighbors (int x, int y){
  return world[(x + 1) % sx][y][current] + 
         world[x][(y + 1) % sy][current] + 
         world[(x + sx - 1) % sx][y][current] + 
         world[x][(y + sy - 1) % sy][current] + 
         world[(x + 1) % sx][(y + 1) % sy][current] + 
         world[(x + sx - 1) % sx][(y + 1) % sy][current] + 
         world[(x + sx - 1) % sx][(y + sy - 1) % sy][current] + 
         world[(x + 1) % sx][(y + sy - 1) % sy][current]; 
}

//swap the values of two array variables in order to update the values in array
void Swap(){
  next = (next + 1)%2;
  current = (next +1)%2;
}

//control the behavior by keyPress()
void keyPressed(){
  //use switch to manage different keys
  switch(key){
    //clear the grid to black
    case 'c':
    case 'C':{
      for(int i = 0; i < sx; i++){
        for(int j = 0; j < sy; j++){
          world [i][j][next] = 0;
          world [i][j][current] = 0;
        }
      }
      redraw();
      break;
    }
    //randomize the stable if the grid
    case 'r':
    case 'R':{
      pressG = 0;
      pressSpace = 0;
      for(int i = 0; i < sx; i++){
        for(int j = 0; j < sy; j++){
          world [i][j][current] = 0;
          world [i][j][next] = 0;
        }
      }
      for (int i = 0; i < sx * sy * density; i++){ 
        world[(int)random(sx)][(int)random(sy)][next] = 1; 
      } 
      redraw();
      break;
    }
    //toggle between single-step and continuous update mode
    case 'g':
    case 'G':{
      noLoop();
      pressG++;
      pressSpace = 0;
      loop();
      break;
    }
    //switch to sigle step and take one simulation step
    case ' ':{
      noLoop();
      pressSpace++; 
      redraw();
    }
  }
}
