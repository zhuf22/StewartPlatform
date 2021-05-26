import processing.serial.*;

Serial uno;
boolean firstContact = false;
String val;

float tol = 0.1; //tolerance from the laser cutting

Assembly stewart;
void setup(){
  size(600, 600, P3D);
  stewart = new Assembly(80 - tol, 64 - tol, 60 - tol, 48 - tol);
  
  String portName = Serial.list()[2];
  
  uno = new Serial(this, portName, 9600);
  uno.bufferUntil('\n');
}

void draw(){
  background(170);
  strokeWeight(1);
  displayPlatformRotation();
  displayPlatformMovement();
  
  translate(width/2, height/3*2);
  rotateX(cam_xRot);
  rotateZ(cam_zRot);
  drawAxes(1000, 2);
  
  scale(1);
  stewart.update();
  stewart.draw();
  
}

void serialEvent(Serial uno){
  val = uno.readStringUntil('\n');
  
  if (val != null) {
    val = trim(val);
    println(val);
    
    if (firstContact == false) {
      //TODO: recieve initial motor positions
      if (val.equals("contact")) {
        uno.clear();
        firstContact = true;
        println("connected to Arduino");
        sendAnglesToArduino();
      }
    }
    else{
      //send over motor angles 
      sendAnglesToArduino();
    }
  }
}

float getMotorAngle(int k){
  float angle = stewart.alpha_arr[k];
  if(stewart.motors[k].flipped) angle = -(PI-stewart.alpha_arr[k]);
  angle = 90 + degrees(angle);
  angle = constrain(angle, 0, 180);
  return angle;
}

void sendAnglesToArduino(){
  uno.write("<"); //starting character
  print("sent: ");
  for(int i = 0; i < 6; i++){
    //convert to motor angle in degrees
    float angle = getMotorAngle(i);
    print(angle + ", ");
    uno.write(("" + angle + ','));
  }
  uno.write(">"); //terminating character
  println();
}
