//rotating platform
vec2[] plat_xRotPos = {new vec2(5, 5), new vec2(110, 25)};
vec2[] plat_yRotPos = {new vec2(5, 30), new vec2(110, 50)};
vec2[] plat_zRotPos = {new vec2(5, 55), new vec2(110, 75)};
void displayPlatformRotation(){
  push();
  fill(255,0,0); text("x: " + stewart.p.euler[0], 10, 20);
  fill(0,255,0); text("y: " + stewart.p.euler[1], 10, 45);
  fill(0,0,255); text("z: " + stewart.p.euler[2], 10, 70);
  push();
  rectMode(CORNERS);
  noFill();
  
  stroke(255,0,0);
  rect(plat_xRotPos[0].x, plat_xRotPos[0].y, plat_xRotPos[1].x, plat_xRotPos[1].y);
  stroke(0,255,0);
  rect(plat_yRotPos[0].x, plat_yRotPos[0].y, plat_yRotPos[1].x, plat_yRotPos[1].y);
  stroke(0,0,255);
  rect(plat_zRotPos[0].x, plat_zRotPos[0].y, plat_zRotPos[1].x, plat_zRotPos[1].y);

  pop();
  pop();
}

//moving platform
vec2[] plat_xMovePos = {new vec2(5, 5+90), new vec2(110, 25+90)};
vec2[] plat_yMovePos = {new vec2(5, 30+90), new vec2(110, 50+90)};
vec2[] plat_zMovePos = {new vec2(5, 55+90), new vec2(110, 75+90)};
void displayPlatformMovement(){
  push();
  fill(255,0,0); text("x: " + stewart.p.O.x, 10, 20+90);
  fill(0,255,0); text("y: " + stewart.p.O.y, 10, 45+90);
  fill(0,0,255); text("z: " + stewart.p.O.z, 10, 70+90);
  push();
  rectMode(CORNERS);
  noFill();
  
  stroke(255,0,0);
  rect(plat_xMovePos[0].x, plat_xMovePos[0].y, plat_xMovePos[1].x, plat_xMovePos[1].y);
  stroke(0,255,0);
  rect(plat_yMovePos[0].x, plat_yMovePos[0].y, plat_yMovePos[1].x, plat_yMovePos[1].y);
  stroke(0,0,255);
  rect(plat_zMovePos[0].x, plat_zMovePos[0].y, plat_zMovePos[1].x, plat_zMovePos[1].y);

  pop();
  pop();
}


//rotating camera
float cam_zRot = 0;
float cam_xRot = PI/2 - 0.05;

PVector mousePos = new PVector();
float cam_zRotTemp = 0;
float cam_xRotTemp = 0;

boolean platformRotate = false;
int platformRotateIndex = -1;
float platformRotateTemp;

boolean platformMove = false;
int platformMoveIndex = -1;
float platformMoveTemp;
void mousePressed(){
  mousePos.x = mouseX;
  mousePos.y = mouseY;
  cam_zRotTemp = cam_zRot;
  cam_xRotTemp = cam_xRot;
  
  if(mouseInRect(plat_xRotPos) || 
     mouseInRect(plat_yRotPos) ||
     mouseInRect(plat_zRotPos)){
     platformRotate = true;
     
     if(mouseInRect(plat_xRotPos))platformRotateIndex = 0;
     else if(mouseInRect(plat_yRotPos)) platformRotateIndex = 1;
     else if(mouseInRect(plat_zRotPos)) platformRotateIndex = 2;
     
     platformRotateTemp = stewart.p.euler[platformRotateIndex];
  }
  else if(mouseInRect(plat_xMovePos) || 
     mouseInRect(plat_yMovePos) ||
     mouseInRect(plat_zMovePos)){
     platformMove = true;
     
     if(mouseInRect(plat_xMovePos))platformMoveIndex = 0;
     else if(mouseInRect(plat_yMovePos)) platformMoveIndex = 1;
     else if(mouseInRect(plat_zMovePos)) platformMoveIndex = 2;
     
     platformMoveTemp = stewart.p.pos[platformMoveIndex];
  }
}
void mouseDragged(){
  if(platformRotate){
    stewart.p.euler[platformRotateIndex] = platformRotateTemp + 0.01*(mouseX-mousePos.x);
    stewart.p.euler[platformRotateIndex] = constrain(stewart.p.euler[platformRotateIndex], -PI, PI);
    return;
  }
  else if(platformMove){
    stewart.p.pos[platformMoveIndex] = platformMoveTemp + 0.1*(mouseX-mousePos.x);
    return;
  }
  
  else{
    if(keyPressed && keyCode == SHIFT){
      cam_xRot = cam_xRotTemp - 0.005*(mouseY-mousePos.y);
      cam_xRot = constrain(cam_xRot, 0.3, PI);
    }
    else{
      cam_zRot = cam_zRotTemp + 0.005*(mouseX-mousePos.x);
    }
  }
}
void mouseReleased(){
  platformRotate = false;
  platformMove = false;
}

void keyPressed(){
  if(key == 'r'){
    stewart.resetPos();
  }
}

boolean mouseInRect(vec2[] rect){
  return mouseX >= rect[0].x && mouseX <= rect[1].x && mouseY >= rect[0].y && mouseY <= rect[1].y;
}

//arrow drawing function
public void drawArrow(vec3 o, vec3 v) {
  push();
  strokeWeight(0.5);
  line(o.x,o.y,o.z, v.x,v.y,v.z);
  
  pushMatrix();
    translate(v.x, v.y, v.z);
    float a = atan2(o.x-v.x, v.y-o.y);
    rotate(a);
    a = acos(dist(o.x, o.y, v.x, v.y)/vec3.dist(o, v));
    rotateX(a);
    line(0, 0, -3, -5);
    line(0, 0, 3, -5);
    line(0, 0, 0, 0, -5, -3);
    line(0, 0, 0, 0, -5, 3);
  popMatrix();
  pop();
}
public void drawArrow(vec3 v) {
  drawArrow(vec3.ZERO, v);
}

//draw axes
void drawAxes(float l, float strokeWeight){
  push();
  strokeWeight(strokeWeight);
  stroke(255,0,0, 100);
  line(0,0,0,l,0,0);
  stroke(0,255,0, 100);
  line(0,0,0,0,l,0);
  stroke(0,0,255, 100);
  line(0,0,0,0,0,l);
  pop();
}

void translate(vec3 v){
  translate(v.x, v.y, v.z);
}

void line(vec3 v1, vec3 v2){
  line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
}
