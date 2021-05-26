class Base{
  final float anchorDist = 21; //how far down each anchor is on the side (mm)
  
  vec3 O; //base origin
  
  //base dimensions
  float ro; //outer radius
  float ri; //inner radius
  
  vec2[] vertices;
  vec3[] B; //anchors
  Motor[] motors;
  
  Base(float rOut, float rIn){
    O = new vec3();
    ro = rOut;
    ri = rIn;
    
    calculateVertices();
    placeAnchors();
  }
  
  //TODO: shift the motors outwards from the frame slightly
  void placeAnchors(){
    B = new vec3[6];
    //interp should be the distance from the edge to the center of servo
    for(int i = 0; i < 6; i+=2){
      int b = (i+2)%6;
      int a = i+1;
      vec2 side = vec2.sub(vertices[b], vertices[a]);
      side.normalize();
      side.mult(anchorDist);
      vec2 b1 = vec2.add(side, vertices[a]);
      side.mult(-1);
      vec2 b2 = vec2.add(side, vertices[b]);
      
      B[i] = new vec3(b1.x, b1.y, 0);
      B[i+1] = new vec3(b2.x, b2.y, 0);
    }
  }
  
  float a;
  void calculateVertices(){
    vertices = new vec2[6];
    a = (4*ri - 2*ro)/sqrt(3); //sidelength of short side of base
    //println(a);
    
    for(int i = 0; i < 6; i++){
      vertices[i] = e(i);
      //println(vertices[i].x + " " + vertices[i].y);
      //even->odd is short side
    }
  }
  vec2 e(int k){
    float gamma = 2*PI/3*floor(k/2.0);
    
    vec2 v1 = new vec2(cos(gamma), sin(gamma));
    vec2 v2 = new vec2(sin(gamma), -cos(gamma));
    
    v1.mult(ro);
    v2.mult(((k%2==0)?1:-1) * a/2.0);
    
    return vec2.add(v1, v2);
  }
  
  void draw(){
    push();
    translate(O.x, O.y, O.z);
    
    //draw base shape
    stroke(0);
    strokeWeight(1);
    fill(0,255,255);
    beginShape();
    for(vec2 v : vertices){
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    
    
    //draw bounding radii
    /*
    noFill();
    stroke(202, 91, 227, 150);
    circle(0,0,2*ro);
    circle(0,0,2*ri);
    */
    
    //draw the motor points
    /*
    stroke(36, 168, 0);
    for(vec3 v : B){
      push();
      translate(v.x, v.y, v.z);
      sphere(1);
      pop();
    }
    */
    
    pop();
    
    
  }
}
