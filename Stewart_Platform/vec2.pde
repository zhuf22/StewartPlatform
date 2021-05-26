static class vec2{
  float x, y;
  vec2(float x, float y){
    this.x = x; this.y = y;
  }
  
  vec2 add(vec2 o){
    this.x += o.x;
    this.y += o.y;
    return this;
  }
  static vec2 add(vec2 a, vec2 b){
    return new vec2(a.x+b.x, a.y+b.y);
  }
  
  vec2 sub(vec2 o){
    this.x -= o.x;
    this.y -= o.y;
    return this;
  }
  static vec2 sub(vec2 a, vec2 b){
    return new vec2(a.x-b.x, a.y-b.y);
  }
  
  vec2 mult(float s){
    this.x *= s; this.y *= s;
    return this;
  }
  static vec2 mult(vec2 v, float s){
    return new vec2(v.x*s, v.y*s);
  }
  
  vec2 div(float s){
    this.x /= s; this.y /= s;
    return this;
  }
  static vec2 div(vec2 v, float s){
    return new vec2(v.x/s, v.y/s);
  }
  
  float dist(vec2 v){
    return sqrt(sqrDist(v));
  }
  float sqrDist(vec2 v){
    return (this.x-v.x)*(this.x-v.x) + (this.y-v.y)*(this.y-v.y);
  }
  static float dist(vec2 v1, vec2 v2){
    return sqrt(vec2.sqrDist(v1, v2));
  }
  static float sqrDist(vec2 v1, vec2 v2){
    return (v1.x-v2.x)*(v1.x-v2.x) + (v1.y-v2.y)*(v1.y-v2.y);
  }
  
  float sqrMag(){
    return x*x + y*y;
  }
  float mag(){
    return sqrt(sqrMag());
  }
  static float sqrMag(vec2 v){
    return v.x*v.x + v.y*v.y;
  }
  static float mag(vec2 v){
    return sqrt(vec2.sqrMag(v));
  }
  
  static float angleBetween(vec2 v1, vec2 v2){
    float angle = acos((v1.x*v2.x + v1.y*v2.y) / (v1.mag() * v2.mag()));
    return angle;
  }
  
  void normalize(){
    div(mag());
  }
  static vec2 normalize(vec2 v){
    return vec2.div(v, v.mag());
  }
  
  float dot(vec2 v){
    return x*v.x + y*v.y;
  }
  static float dot(vec2 a, vec2 b){
    return a.x*b.x + a.y*b.y;
  }
  
  static vec2 orthoClockwise(vec2 v){
    return new vec2(v.y, -v.x);
  }
  static vec2 orthoCounterclockwise(vec2 v){
    return new vec2(-v.y, v.x);
  }
  
}
