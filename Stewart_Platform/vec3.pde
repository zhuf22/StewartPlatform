static class vec3{
  static final vec3 ZERO;
  static final vec3 X;
  static final vec3 Y;
  static final vec3 Z;
  static{
    ZERO = new vec3();
    X = new vec3(1,0,0);
    Y = new vec3(0,1,0);
    Z = new vec3(0,0,1);
  }
  float x, y, z;
  
  vec3(float x, float y, float z){
    this.x = x; this.y = y; this.z = z;
  }
  vec3(){
    this.x = 0; this.y = 0; this.z = 0;
  }
  
  
  vec3 add(vec3 o){
    this.x += o.x;
    this.y += o.y;
    this.z += o.z;
    return this;
  }
  static vec3 add(vec3 a, vec3 b){
    return new vec3(a.x+b.x, a.y+b.y, a.z+b.z);
  }
  
  vec3 sub(vec3 o){
    this.x -= o.x;
    this.y -= o.y;
    this.z -= o.z;
    return this;
  }
  static vec3 sub(vec3 a, vec3 b){
    return new vec3(a.x-b.x, a.y-b.y, a.z-b.z);
  }
  
  vec3 mult(float s){
    this.x *= s; this.y *= s; this.z *= s;
    return this;
  }
  static vec3 mult(vec3 v, float s){
    return new vec3(v.x*s, v.y*s, v.z*s);
  }
  
  vec3 div(float s){
    this.x /= s; this.y /= s; this.z /= s;
    return this;
  }
  static vec3 div(vec3 v, float s){
    return new vec3(v.x/s, v.y/s, v.z/s);
  }
  
  float dist(vec3 v){
    return sqrt(sqrDist(v));
  }
  float sqrDist(vec3 v){
    return (this.x-v.x)*(this.x-v.x) + (this.y-v.y)*(this.y-v.y) + (this.z-v.z)*(this.z-v.z);
  }
  static float dist(vec3 v1, vec3 v2){
    return sqrt(vec3.sqrDist(v1, v2));
  }
  static float sqrDist(vec3 v1, vec3 v2){
    return (v1.x-v2.x)*(v1.x-v2.x) + (v1.y-v2.y)*(v1.y-v2.y) + (v1.z-v2.z)*(v1.z-v2.z);
  }
  
  float sqrMag(){
    return x*x + y*y + z*z;
  }
  float mag(){
    return sqrt(sqrMag());
  }
  static float sqrMag(vec3 v){
    return v.x*v.x + v.y*v.y + v.z*v.z;
  }
  static float mag(vec3 v){
    return sqrt(vec3.sqrMag(v));
  }
  
  static float angleBetween(vec3 v1, vec3 v2){
    float angle = acos((v1.x*v2.x + v1.y*v2.y + v1.z*v2.z) / (v1.mag() * v2.mag()));
    return angle;
  }
  static float signedAngleBetween(vec3 v1, vec3 v2, vec3 n){
    //n is the normal of the plane
    float angle = acos(vec3.dot(vec3.normalize(v1), vec3.normalize(v2)));
    vec3 cross = vec3.cross(v1, v2);
    if(n.dot(cross) > 0)
      angle = -angle;
    return angle;
  }
  
  void normalize(){
    div(mag());
  }
  static vec3 normalize(vec3 v){
    return vec3.div(v, v.mag());
  }
  
  float dot(vec3 v){
    return x*v.x + y*v.y + z*v.z;
  }
  static float dot(vec3 a, vec3 b){
    return a.x*b.x + a.y*b.y + a.z*b.z;
  }
  
  vec3 cross(vec3 o){
    return new vec3(y*o.z - z*o.y, z*o.x - x*o.z, x*o.y - y*o.x);
  }
  static vec3 cross(vec3 a, vec3 b){
    return a.cross(b);
  }
  
  void rotate(Quaternion q){
    Quaternion quat = new Quaternion(0, x, y, z);
    quat = Quaternion.mult(q, quat).mult(q.conjugate());
    this.x = quat.X; this.y = quat.Y; this.z = quat.Z;
  }
  static vec3 rotate(vec3 v, Quaternion q){
    Quaternion quat = new Quaternion(0, v.x, v.y, v.z);
    quat = Quaternion.mult(q, quat).mult(q.conjugate());
    return new vec3(quat.X, quat.Y, quat.Z);
  }
}
