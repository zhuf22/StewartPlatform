final float motorHeight = 40;
final float motorWidth = 20;
final float motorDepth = 30;

final float hornLength = 14.5;
final float rodLength = 118.5;

final float outwardOffset = 15; //distance the joint extends from the platform
class Motor{
  vec3 O; //origin
  float beta; //angle of rotation
  float alpha; //servo angle from parallel to ground
  boolean flipped = false; //note that the angle changes must be reversed if flipped
  
  vec3 Hk;
  vec3 normal;
  
  Motor(vec3 v, float beta, float startAngle, boolean flipped){
    O = v;
    this.beta = beta;
    alpha = startAngle;
    this.flipped = flipped;
    
    PVector shaft = PVector.fromAngle(beta + PI/2);
    shaft.normalize();
    normal = new vec3(shaft.x, shaft.y, 0);
    normal.normalize();
    
    Hk = new vec3();
    calcHk();
  }
  Motor(vec3 v, float beta, float startAngle){
    this(v, beta, startAngle, false);
  }
  
  void calcHk(){
    //note that since the transformation of the origin
    //   is included, it will store absolute (not relative)
    //   position
    
    vec3 horn = new vec3(cos(alpha)*cos(beta), cos(alpha)*sin(beta), sin(alpha));
    horn.mult(hornLength);
    Hk = vec3.add(O, horn);
    
    //translate outwards from the platform
    Hk.add(vec3.mult(normal, outwardOffset));
  }
  
  void update(){
    calcHk();
  }
  
  void draw(){
    push();
    translate(O);
    rotateZ(beta);
    
    stroke(255);
    sphere(3);
    
    //draw motor body
    push();
    translate(0, -motorDepth/2.0, -motorHeight/4);
    fill(100);
    stroke(0);
    strokeWeight(1);
    box(motorWidth, motorDepth, motorHeight);
    pop();
    
    
    pop();
    
    //draw end joint (absolute)
    calcHk();
    push();
    translate(Hk);
    stroke(0);
    fill(0);
    sphere(2);
    pop();
    
    vec3 offsetO = vec3.add(O, vec3.mult(normal,outwardOffset));
    //draw servo outward offset
    strokeWeight(3);
    stroke(0);
    line(O, offsetO);
    
    //draw arm
    strokeWeight(4);
    stroke(255, 184, 229);
    line(offsetO, Hk);
    
    //draw normal
    strokeWeight(0.5);
    stroke(255);
    //drawArrow(O, vec3.add(O, vec3.mult(normal, 10)));
  }
}
