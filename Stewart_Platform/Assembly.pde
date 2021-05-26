class Assembly{
  Base b;
  Platform p;
  Motor[] motors;
  
  Quaternion lastValidRot;
  float[] lastValidEuler;
  vec3 lastValidPos;
  
  float[] lastValidAlphas;
  float[] alpha_arr;
  
  Assembly(float brOut, float brIn, float prOut, float prIn){
    b = new Base(brOut, brIn);
    p = new Platform(prOut, prIn);
    
    //set initial platform height to optimum
    //  i.e. point in which rods and horns are orthogonal
    p.pos[2] = sqrt(rodLength*rodLength + hornLength*hornLength -
                 (p.B[0].x-b.B[0].x)*(p.B[0].x-b.B[0].x) -
                 (p.B[0].y-b.B[0].y)*(p.B[0].y-b.B[0].y) );
    
    placeMotors();
    
    lastValidRot = new Quaternion(p.R.W, p.R.X, p.R.Y, p.R.Z);
    lastValidPos = new vec3(p.O.x, p.O.y, p.O.z);
    lastValidEuler = new float[3];
    lastValidAlphas = new float[6];
    
    update();
  }
  
  void resetPos(){
    p.pos[0] = 0;
    p.pos[1] = 0;
    p.pos[2] = sqrt(rodLength*rodLength + hornLength*hornLength -
                 (p.B[0].x-b.B[0].x)*(p.B[0].x-b.B[0].x) -
                 (p.B[0].y-b.B[0].y)*(p.B[0].y-b.B[0].y) );
    p.euler[0] = 0;
    p.euler[1] = 0;
    p.euler[2] = 0;
  }
  
  void placeMotors(){
    //place motors on base anchors
    motors = new Motor[6];
    for(int i = 0; i < 6; i += 2){
      vec3 xAxis = new vec3(1,0,0);
      float beta = vec3.signedAngleBetween(vec3.sub(b.B[i], b.B[i+1]), xAxis, vec3.Z);
      
      //swap which is flipped if swapping motor orientation
      motors[i] = new Motor(b.B[i], beta, PI/4, true);
      motors[i+1] = new Motor(b.B[i+1], beta, PI/4);
    }
  }
  
  void drawAnchorVectors(int k){
    push();
    translate(b.O);
    
    stroke(0);
    vec3 T = vec3.sub(p.O, b.O);
    drawArrow(T);
    
    vec3 bk = b.B[k];
    drawArrow(bk);
    
    vec3 Pk = vec3.rotate(p.B[k], p.R);
    //println(Pk.x + " " + Pk.y + " " + Pk.z);
    push(); translate(T); //translate to be relative to platform
    drawArrow(Pk);
    pop();
    
    stroke(0,0,255);
    vec3 qk = vec3.add(T, Pk);
    drawArrow(qk);
    
    stroke(255,0,0);
    vec3 lk = vec3.sub(Pk, bk);
    lk.add(T);
    push(); translate(bk);
    drawArrow(lk);
    pop();
    
    pop();
  }
  
  
  void update(){
    p.update();
    
    alpha_arr = calculateAlphas();
    //check if valid
    for(int k = 0; k < 6; k++){
      if(Float.isNaN(alpha_arr[k])){
        //not valid configuration, revert to stable
        restoreLastValid();
        return;
      }
    }
    //update positions if valid
    for(int k = 0; k < 6; k++){
      motors[k].alpha = alpha_arr[k];
    }
    //store valid position
    storeNewValid();
  }
  
  //fancy calculations needed to find necessary alpha for each motor
  float[] calculateAlphas(){
    float[] alpha = new float[6];
    
    vec3 T = vec3.sub(p.O, b.O);
    for(int k = 0; k < 6; k++){
      
      vec3 bk = b.B[k];
      vec3 Pk = vec3.rotate(p.B[k], p.R);
      vec3 lk = vec3.sub(Pk, bk);
      lk.add(T);
      
      float beta_k = motors[k].beta;
      
      float e = 2 * hornLength * lk.z;
      float f = 2 * hornLength * 
             (cos(beta_k)*lk.x + sin(beta_k)*lk.y);
      float g = lk.sqrMag() - (rodLength*rodLength - hornLength*hornLength);
      
      alpha[k] = asin(g/sqrt(e*e + f*f)) - atan2(f, e);
      
      if(motors[k].flipped){
        //get projection of lk on motor face
        vec3 n = motors[k].normal;
        vec3 proj_lk = vec3.sub(lk, vec3.mult(n, vec3.dot(lk, n)));
        
        //get angle between proj_lk and alpha
        vec3 horn = new vec3(cos(alpha[k])*cos(motors[k].beta), cos(alpha[k])*sin(motors[k].beta), sin(alpha[k]));
        float angleDiff = vec3.angleBetween(proj_lk, horn);
        //add the angle difference to reflect over proj_lk
        alpha[k] += 2*angleDiff;
      }
    }
    return alpha;
  }
  
  void draw(){
    b.draw();
    p.draw();
    
    //draw vectors 
    for(int k = 0; k < 6; k++){
      //drawAnchorVectors(k);
    }
    
    //draw motors
    for(Motor m : motors){
      m.draw();
    }
    //highlight first and second motor
    push();
    stroke(255,0,0);
    translate(motors[0].O);
    sphere(2.5);
    pop();
    push();
    stroke(0,255,0);
    translate(motors[1].O);
    sphere(2.5);
    pop();
    
    //draw rods
    stroke(193, 255, 186);
    strokeWeight(5);
    vec3 T = vec3.sub(p.O, b.O);
    for(int k = 0; k < 6; k++){
      vec3 Pk = vec3.rotate(p.B[k], p.R);
      Pk.add(T);
      line(motors[k].Hk, Pk);
      //println(vec3.dist(motors[k].Hk, Pk));
    }
  }
  
  void restoreLastValid(){
    p.R.W = lastValidRot.W;
    p.R.X = lastValidRot.X;
    p.R.Y = lastValidRot.Y;
    p.R.Z = lastValidRot.Z;
    
    p.O.x = lastValidPos.x;
    p.O.y = lastValidPos.y;
    p.O.z = lastValidPos.z;
    
    p.pos[0] = lastValidPos.x;
    p.pos[1] = lastValidPos.y;
    p.pos[2] = lastValidPos.z;
    
    p.euler[0] = lastValidEuler[0];
    p.euler[1] = lastValidEuler[1];
    p.euler[2] = lastValidEuler[2];
    
    for(int i = 0; i < 6; i++){
      alpha_arr[i] = lastValidAlphas[i];
    }
  }
  void storeNewValid(){
    lastValidRot.W = p.R.W;
    lastValidRot.X = p.R.X;
    lastValidRot.Y = p.R.Y;
    lastValidRot.Z = p.R.Z;
    
    lastValidPos.x = p.O.x;
    lastValidPos.y = p.O.y;
    lastValidPos.z = p.O.z;
    
    lastValidEuler[0] = p.euler[0];
    lastValidEuler[1] = p.euler[1];
    lastValidEuler[2] = p.euler[2];
    
    for(int i = 0; i < 6; i++){
      lastValidAlphas[i] = alpha_arr[i];
    }
  }
}
