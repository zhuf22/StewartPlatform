#include <Servo.h>

int updateSpeed = 50;

String val;
double angles[6];
int i;
bool foundAngles = false;
//char *arrstr = malloc(sizeof(char) * 70);

Servo servos[6];

void setup() {
  Serial.begin(9600);
  establishContact();

  for(i = 0; i < 6; i++){
    servos[i].attach(i+2);
    angles[i] = servos[i].read();
  }
}

void loop()
{
  if (Serial.available() > 0) {
    //val = Serial.readString();
    //Serial.println(val);

    //check if input read contains starting character
    foundAngles = Serial.find("<");
    if(!foundAngles){
      //invalid input read
      Serial.print("invalid input read");
      foundAngles = false;
      delay(updateSpeed);
      return;
    }

    //parse data
    for(i = 0; i < 6; i++){
      angles[i] = processAngle(Serial.parseFloat());
      if(servos[i].attached()){
        if(angles[i] >= 0  && angles[i] <= 180){
          servos[i].write(angles[i]);
        }
        else{
          angles[i] = -1;
        }
      }
      Serial.find(',');
    }
    //find terminating character
    Serial.find(">");
    
    //printing recieved data to serial
    for(i = 0; i < 6; i++){
      Serial.print(angles[i], 5); Serial.print(", ");
    }
    Serial.print('\n');
    
    delay(updateSpeed);
  } 
  else {
    //empty serial
    Serial.println("empty");

    //reset motors
    for(i = 0; i < 6; i++){
      angles[i] = 0;
      servos[i].write(90);
    }
    
    delay(100);
  }
  foundAngles = false;
}

float processAngle(float f){
  return round((180-f)*10)/10.0;
  
}

void establishContact(){
  while(Serial.available() <= 0){
    Serial.println("contact");
    delay(300);
  }
  
}
