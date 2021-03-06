// defines pins numbers
const int trigPinA = 4;
const int trigPinB = 5;
const int echoPinB = 6;
const int echoPinA = 7;
const int fpgaPin = 2;
// defines variables
long duration;
int distance;
boolean desiredangle = true; //direction
int desiredb = 45; //angle
int microsdelay; //Actual phased array delay
int leftout;
int rightout;
int farleftout;
int farrightout;
boolean leftentity;
boolean rightentity;
boolean farleftentity;
boolean farrightentity;
String outstr;
//Adaptive resolution marks
boolean ar0mark;
boolean ar1mark;
boolean ar2mark;
boolean ar3mark;
boolean ar4mark;
boolean ar5mark;
boolean ar6mark;
boolean ar7mark;
// timing vars
unsigned long starttime;
unsigned long endtime;
//mode
const boolean ADAPTIVE_MODE_SONAR = true;
void setup() {
  pinMode(trigPinA, OUTPUT); // Sets the trigPins as Outputs
  pinMode(trigPinB, OUTPUT);
  pinMode(echoPinA, INPUT); // Sets the echoPins as Inputs
  pinMode(echoPinB, INPUT);
  pinMode(fpgaPin, INPUT); //Sets the FPGA pin (P3/P2-9 on board, P34 in code) as an input from FPGA to arduino
  Serial.begin(9600); // Starts the serial communication
}
void loop() {
  //Get timing
  microsdelay = (desiredb<=45)?3945:812; //3495 if for 45 degs, 812 is for 70 degs
  //Run SONAR in order, 45/70 degs
  runSONAR(false^desiredangle);
  endtime = micros(); //save end time
  delayMicroseconds(microsdelay-(endtime-starttime)); //The phase shift for 45/70 degs, account for delay 
  runSONAR(true^desiredangle);
  delayMicroseconds(1000); //Allow the signal to propogate before measurement
  readSONAR(-1);
  //Delay for good measure
  delay(5);
  //Switch angle
  desiredangle = !desiredangle;
  //Run SONAR in order, 45 degs
  runSONAR(false^desiredangle);
  endtime = micros(); //save end time
  delayMicroseconds(3945-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
  runSONAR(true^desiredangle);
  delayMicroseconds(1000); //Allow the signal to propogate before measurement
  readSONAR(-1);
  //Delay for good measure
  delay(5);
  //Switch angle
  desiredangle = !desiredangle;
  //Switch b
  desiredb = (desiredb<=45)?60:45;
  //Get timing
  microsdelay = (desiredb<=45)?3495:812; //3495 if for 45 degs, 812 is for 70 degs, 6734 is for 30 degs, 458 is for 75 degs
  //Run SONAR in order, 45/70 degs
  runSONAR(false^desiredangle);
  endtime = micros(); //save end time
  delayMicroseconds(microsdelay-(endtime-starttime)); //The phase shift for 45/70 degs, account for delay 
  runSONAR(true^desiredangle);
  delayMicroseconds(1000); //Allow the signal to propogate before measurement
  readSONAR(-1);
  //Delay for good measure
  delay(5);
  //Switch angle
  desiredangle = !desiredangle;
  //Get timing
  microsdelay = (desiredb<=45)?3495:812; //3495 if for 45 degs, 812 is for 70 degs, 6734 is for 30 degs, 458 is for 75 degs
  //Run SONAR in order, 45 degs
  runSONAR(false^desiredangle);
  endtime = micros(); //save end time
  delayMicroseconds(microsdelay-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
  runSONAR(true^desiredangle);
  delayMicroseconds(1000); //Allow the signal to propogate before measurement
  readSONAR(-1);
  //Delay for good measure
  delay(5);
  //Switch angle
  desiredangle = !desiredangle;
  //Switch b
  desiredb = (desiredb<=45)?60:45;
  //Interpret result
  leftentity = (leftout<=20);
  rightentity = (rightout<=20);
  farleftentity = (farleftout<=20);
  farrightentity = (farrightout<=20);
  outstr = "";
  if (ADAPTIVE_MODE_SONAR) {
    if (farrightentity) {
      //Run SONAR in order, 45 degs
      runSONAR(false);
      endtime = micros(); //save end time
      delayMicroseconds(204-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(0);
      //Delay for good measure
      delay(5);
      //Run SONAR in order, 45 degs
      runSONAR(false);
      endtime = micros(); //save end time
      delayMicroseconds(1804-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(1);
      //Delay for good measure
      delay(5);
    } else {ar0mark=farrightentity;ar1mark=farrightentity;}
    if (rightentity) {
      //Run SONAR in order, 45 degs
      runSONAR(false);
      endtime = micros(); //save end time
      delayMicroseconds(2435-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(2);
      //Delay for good measure
      delay(5);
      //Run SONAR in order, 45 degs
      runSONAR(false);
      endtime = micros(); //save end time
      delayMicroseconds(5743-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(3);
      //Delay for good measure
      delay(5);
    } else {ar2mark=rightentity;ar3mark=rightentity;}
    if (leftentity) {
      //Run SONAR in order, 45 degs
      runSONAR(!false);
      endtime = micros(); //save end time
      delayMicroseconds(5743-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(!true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(4);
      //Delay for good measure
      delay(5);
      //Run SONAR in order, 45 degs
      runSONAR(!false);
      endtime = micros(); //save end time
      delayMicroseconds(2435-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(!true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(5);
      //Delay for good measure
      delay(5);
    } else {ar4mark=leftentity;ar5mark=leftentity;}
    if (farleftentity) {
      //Run SONAR in order, 45 degs
      runSONAR(!false);
      endtime = micros(); //save end time
      delayMicroseconds(1804-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(!true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(6);
      //Delay for good measure
      delay(5);
      //Run SONAR in order, 45 degs
      runSONAR(!false);
      endtime = micros(); //save end time
      delayMicroseconds(204-(endtime-starttime)); //The phase shift for 45 degs, account for delay 
      runSONAR(!true);
      delayMicroseconds(1000); //Allow the signal to propogate before measurement
      readSONAR(7);
      //Delay for good measure
      delay(5);
    } else {ar6mark=farleftentity;ar7mark=farleftentity;}
  }
  runSONAR(false);
  desiredangle = true;
  double resja = readSONAR(-1);
  runSONAR(true);
  desiredangle = false;
  double resjb = readSONAR(-1);
  Serial.println(resja);
  Serial.println(resjb);
  if ((resjb - resja) > 100) {
    if(ar7mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(farleftentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar6mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar5mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(leftentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar4mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar3mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(rightentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar2mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar1mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(farrightentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar0mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
  } else {
    if(ar0mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(farrightentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar1mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar2mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(rightentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar3mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar4mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(leftentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar5mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar6mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(farleftentity){outstr=outstr+"#";}else{outstr=outstr+"_";}
    if(ar7mark){outstr=outstr+"#";}else{outstr=outstr+"_";}
  }
  Serial.println(outstr);
}
void runSONAR(boolean isRight) {
  // Clears the trigPin
  digitalWrite((isRight?trigPinB:trigPinA), LOW);
  delayMicroseconds(2);
  starttime = micros(); //Save the start time
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite((isRight?trigPinB:trigPinA), HIGH);
  delayMicroseconds(10);
  digitalWrite((isRight?trigPinB:trigPinA), LOW);
}
double readSONAR(int wheretogo) {
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(getAppropriateEchoPort(), HIGH); //Use appropriate sensing port as determined by FPGA
  // Calculating the distance
  distance = duration*0.034/2;
  //Save data
  if(wheretogo==-1) {
    if (desiredb<=45) {
      if (desiredangle) {
        leftout = distance;
      } else {
        rightout = distance;
      }
    } else {
      if (desiredangle) {
        farleftout = distance;
      } else {
        farrightout = distance;
      }
    }
  }
  if (wheretogo==0){if(distance<=20){ar0mark=true;}else{ar0mark=false;}}
  if (wheretogo==1){if(distance<=20){ar1mark=true;}else{ar1mark=false;}}
  if (wheretogo==2){if(distance<=20){ar2mark=true;}else{ar2mark=false;}}
  if (wheretogo==3){if(distance<=20){ar3mark=true;}else{ar3mark=false;}}
  if (wheretogo==4){if(distance<=20){ar4mark=true;}else{ar4mark=false;}}
  if (wheretogo==5){if(distance<=20){ar5mark=true;}else{ar5mark=false;}}
  if (wheretogo==6){if(distance<=20){ar6mark=true;}else{ar6mark=false;}}
  if (wheretogo==7){if(distance<=20){ar7mark=true;}else{ar7mark=false;}}
  if (wheretogo==-1){return distance;}
  return 0;
}
int getAppropriateEchoPort() {
  //Get the appropriate port to recieve the echo from, as determined by the FPGA
  boolean FPGAResult = digitalRead(fpgaPin) == HIGH;
  int pinResult = FPGAResult?echoPinA:echoPinB;
  if (!FPGAResult) {
    FPGAResult = desiredangle;
  }
  return pinResult;
}
