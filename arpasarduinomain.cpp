boolean image [1024];
int hilbertResolutionPath [1024];

boolean * currPixel;

int distThreshold = 51;

int currentPoint = 0;
int currentX = 0;
int currentY = 0;
float currentD = 0;
float degX = 0;
float degY = 0;

int directionEncoding = 0;

int directionEncodingA = 2;
int directionEncodingB = 2;

float timingA = 0;
float timingB = 0;

float timingAcc = 0;
float timingBcc = 0;

boolean isEdge = false;

int pixelLoc = 0;

volatile boolean didFPGAInterrupt = false;

const int pin_regdat = 4;
const int pin_regclk = 5;
const int pin_pdorun = 6;
const int pin_regsla = 7;
const int pin_regslb = 8;
const int pin_rstall = 9;
const int pin_allout = 1;

struct sonar {
  enum pins {trig=true,echo=false};
};

void onFPGAUpdate(){didFPGAInterrupt = true;}

boolean threshold(int distToThresh) {return (distToThresh<distThreshold);}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600); //baud
  pinMode(0,INPUT);   //HC-SR04 ECHO
  pinMode(pin_regdat,OUTPUT);  //REGDAT
  pinMode(pin_regclk,OUTPUT);  //REGCLK
  pinMode(pin_pdorun,OUTPUT);  //PDORUN
  pinMode(pin_regsla,OUTPUT);  //REGSLA
  pinMode(pin_regslb,OUTPUT);  //REGSLB
  pinMode(pin_rstall,OUTPUT); //RSTALL
  pinMode(10,OUTPUT);
  pinMode(11,OUTPUT);
  pinMode(12,OUTPUT);
  pinMode(13,OUTPUT);
  pinMode(pin_allout,INPUT); //ALLOUT
  digitalWrite(4,LOW);
  digitalWrite(5,LOW);
  digitalWrite(6,LOW);
  digitalWrite(7,LOW);
  digitalWrite(8,LOW);
  digitalWrite(9,LOW);
  digitalWrite(10,LOW);
  digitalWrite(11,LOW);
  digitalWrite(12,LOW);
  digitalWrite(13,LOW);
  digitalWrite(14,LOW);
  attachInterrupt(digitalPinToInterrupt(pin_allout),onFPGAUpdate, CHANGE);
  for (int i = 0; i < 1023; i++) {
    hilbertResolutionPath[i] = i;
    image[i] = false;
  }
  currPixel = &(image[0]);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (didFPGAInterrupt) {
    onImageUpdate(currPixel);
    didFPGAInterrupt = false;
  }
  if (millis()%1000<=5) {
    scan();
    updateHilbertResolutionPath(image);
  }
  Serial.println("---NEW IMAGE---");
  Serial.print("&");
  for (int i = 0;i<1023;i++){
    Serial.print((image[i])?"X":"_");
    if (i%32==0){Serial.println("&");}
  }
  Serial.println("---END IMAGE---");
}

void onImageUpdate(boolean * pixelToUpdate){
  int currPin = getSONARPin(sonar::pins::trig,pixelLoc);
  digitalWrite(currPin,LOW);
  delayMicroseconds(2);
  digitalWrite(currPin,HIGH);
  delayMicroseconds(10);
  digitalWrite(currPin,LOW);
  updatePixelLoc();
  int mPLocFDir = gMPLocFDirGiven(directionEncodingA,directionEncodingB);
  if (pixelLoc==mPLocFDir) {updatePixel(pixelToUpdate,pixelLoc);}
}

int gMPLocFDirGiven(int gDirEA, int gDirEB){
  if (gDirEA){
    if (gDirEB){return 1;} else {return 3;}
  } else {
    if (gDirEB){return 0;} else {return 2;}
  }
}

void updatePixel(boolean * pixelToUpdate, int pixelLoc){
  double dur = pulseIn(getSONARPin(sonar::pins::echo,pixelLoc),HIGH);
  double dist = dur*0.034/2;
  *pixelToUpdate = threshold(dist);
}

int updatePixelLoc(){
  if (pixelLoc==3) {pixelLoc=0;return -1;}
  pixelLoc=pixelLoc+1;
  return -1;
}

int getSONARPin(boolean isTrig, int pLoc) {
  if (!isTrig) {return 0;}
  if (pLoc==0) {return 10;}
  if (pLoc==1) {return 11;}
  if (pLoc==2) {return 12;}
  if (pLoc==3) {return 13;}
}

void scan() {
  // code to calculate degrees here
  // then call phasedArray(angX,angY,pointToSave)
  for (int i = 0; i < 1023; i++) {
    currentPoint = hilbertResolutionPath[i];
    if (!(currentPoint == -1)) {
      currentX = currentPoint % 32;
      currentY = floor(currentPoint / 32);
      currPixel = &(image[currentPoint]);
      currentD = (image[currentPoint])?25:153;
      degX = asin(currentX / currentD);
      degY = asin(currentY / currentD);
      phasedArray(degX, degY, currentPoint);
    }
  }
}

void phasedArray(float angX, float angY, int pointToSave) {
  directionEncodingA = (angX >= 0);
  directionEncodingB = (angY >= 0);
  timingA = calcPhasedArrayTimings(angX);
  timingB = calcPhasedArrayTimings(angY);
  int itimingA = int(timingA*100);
  int itimingB = int(timingB*100);
  runPhasedArray(timingA,timingB,directionEncodingA,directionEncodingB);
}

int calcPhasedArrayTimings(float ang) {
  //calculate phased array timings here
  return ((PI*sin(ang)-PI)/-2);
}

void runPhasedArray(int timingA, int timingB, boolean directionEncodingA, boolean directionEncodingB) {
  int timingC = timingA + timingB;
  //run the phased array
  digitalWrite(pin_pdorun,LOW); //reset dorun
  digitalWrite(pin_rstall,HIGH);
  delay(2);                  //RESET ALL
  digitalWrite(pin_rstall,LOW);
  
  digitalWrite(pin_regsla,LOW); //SELECT A REGISTER
  digitalWrite(pin_regslb,LOW);
  
  for(int i = 0; i<14; i++){
    digitalWrite(pin_regdat,(bitRead(timingA, i) == 0)?HIGH:LOW);
    digitalWrite(pin_regclk,HIGH);
    delay(1);                  //CLOCK
    digitalWrite(pin_regclk,LOW);
  }
  digitalWrite(pin_regsla,HIGH); //SELECT B REGISTER
  digitalWrite(pin_regslb,LOW);
  
  for(int i = 0; i<14; i++){
    digitalWrite(pin_regdat,(bitRead(timingB, i) == 0)?HIGH:LOW);
    digitalWrite(pin_regclk,HIGH);
    delay(1);                  //CLOCK
    digitalWrite(pin_regclk,LOW);
  }
  digitalWrite(pin_regsla,LOW); //SELECT C REGISTER
  digitalWrite(pin_regslb,HIGH);
  
  for(int i = 0; i<14; i++){
    digitalWrite(pin_regdat,(bitRead(timingC, i) == 0)?HIGH:LOW);
    digitalWrite(pin_regclk,HIGH);
    delay(1);                  //CLOCK
    digitalWrite(pin_regclk,LOW);
  }
  
  //run fpga
  digitalWrite(6,HIGH);
}

void updateHilbertResolutionPath(boolean img[]){
  for (int i = 33; i < 990; i++) {
    isEdge = ((img[i]^img[i+1])|(img[i]^img[i-1])|(img[i]^img[i+32])|(img[i]^img[i-32]));
    if ((i%32<=1)|(i%32==31)) {isEdge=((img[i]^img[i+32])|(img[i]^img[i-32]));}
    if (isEdge) {
      hilbertResolutionPath[i] = i;
    } else {
      if (i%2==0) {
        hilbertResolutionPath[i] = i;
      } else {
        hilbertResolutionPath[i] = -1;
      }
    }
  }
}
