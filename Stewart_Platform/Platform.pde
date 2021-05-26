class Platform extends Base{
  final float anchorDist = 3.5; //how far down each anchor is on the side (mm)
  final float outwardOffset = 4.3; //how far out (in mm) from the platform each joint is
  
  Quaternion R; //platform rotation
  float[] euler;
  float[] pos;
  vec3[] B_origin;
  
  Platform(float rOut, float rIn){
    super(rOut, rIn);
    R = new Quaternion();
    
    euler = new float[3];
    pos = new float[3];
  }
  
  void update(){
    R.calcFromEuler(euler[0], euler[1], euler[2]);
    O.x = pos[0]; O.y = pos[1]; O.z = pos[2];
  }
  
  //rotates the platform by PI/3
  /*
  @Override
  vec2 e(int k){
    float gamma = 2*PI/3*floor(k/2.0);
    gamma += PI/3; //this is just to rotate the platform so that it's rotationally offset from the base
    
    vec2 v1 = new vec2(cos(gamma), sin(gamma));
    vec2 v2 = new vec2(sin(gamma), -cos(gamma));
    
    v1.mult(ro);
    v2.mult(((k%2==0)?1:-1) * a/2.0);
    
    return vec2.add(v1, v2);
  }*/
  
  //want anchors to line up with closest anchors on base, so offset
  @Override
  void placeAnchors(){
    B = new vec3[6];
    B_origin = new vec3[6];
    for(int i = 0; i < 3; i++){
      int b = (2*i+1)%6;
      int a = 2*i;
      vec2 side = vec2.sub(vertices[b], vertices[a]);
      side.normalize();
      vec2 ortho = vec2.orthoClockwise(side);
      
      side.mult(anchorDist);
      vec2 b1 = vec2.add(side, vertices[a]);
      side.mult(-1);
      vec2 b2 = vec2.add(side, vertices[b]);
      
      //offset from platform
      ortho.mult(outwardOffset);
      b1.add(ortho);
      b2.add(ortho);
      
      B[(i*2-1+6)%6] = new vec3(b1.x, b1.y, 0);
      B[(i*2)%6] = new vec3(b2.x, b2.y, 0);
      B_origin[(i*2-1+6)%6] = new vec3(b1.x, b1.y, 0);
      B_origin[(i*2)%6] = new vec3(b2.x, b2.y, 0);
    }
  }
  
  @Override
  void draw(){
    pushMatrix();
    translate(O.x, O.y, O.z);
    applyMatrix(R.getRotMatrix());
    
    //draw base shape
    stroke(0);
    strokeWeight(1);
    fill(255,255,0);
    beginShape();
    for(vec2 v : vertices){
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    //println(vec2.dist(vertices[0], vertices[1]));
    //println(vec2.dist(vertices[1], vertices[2]));
    
    //draw the motor points
    stroke(36, 168, 0);
    for(vec3 v : B){
      push();
      translate(v);
      sphere(2);
      pop();
    }
    //highlight first and second anchor
    push();
    stroke(255,0,0);
    translate(B[0]);
    sphere(2.2);
    pop();
    push();
    stroke(0,255,0);
    translate(B[1]);
    sphere(2.2);
    pop();
    //println(vec3.dist(B[1], B[2]));
    
    
    //draw bounding radii
    /*
    noFill();
    stroke(202, 91, 227, 150);
    circle(0,0,2*ro);
    circle(0,0,2*ri);
    */
    
    //draw relative axes
    drawAxes(10, 5);
    
    popMatrix();
  }
}
