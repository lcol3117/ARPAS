int image [1024];
int hilbertResolutionPath [1024];

int * currPixel;

int currentPoint = 0;
int currentX = 0;
int currentY = 0;
float currentD = 0;
float degX = 0;
float degY = 0;

int directionEncoding = 0;

int directionEncodingA = 2;
int directionEncodingB = 2;

int timingA = 0;
int timingB = 0;

int timingAcc = 0;
int timingBcc = 0;

int pixelLoc = 0;

boolean didFPGAInterrupt = false;

struct sonar {
  enum pins {trig=true,echo=false};
}

void onFPGAUpdate(){didFPGAInterrupt = true;}

void setup() {
  // put your setup code here, to run once:
  pinMode(0,INPUT);   //FORWARDED
  pinMode(4,OUTPUT);  //DATA
  pinMode(5,OUTPUT);  //CLOCK
  pinMode(6,OUTPUT);  //DORUN
  pinMode(7,OUTPUT);  //REGSEL
  pinMode(8,OUTPUT);  //PHMUXA
  pinMode(9,OUTPUT);  //PHMUXB
  pinMode(10,OUTPUT); //RSTALL
  pinMode(15,INPUT); //NEXTPHASEDARRAY
  digitalWrite(4,LOW);
  digitalWrite(5,LOW);
  digitalWrite(6,LOW);
  digitalWrite(7,LOW);
  digitalWrite(8,LOW);
  digitalWrite(9,LOW);
  digitalWrite(10,LOW);
  attachInterrupt(digitalPinToInterrupt(1),onFPGAUpdate, RISING);
  for (int i = 0; i < 1023; i++) {
    hilbertResolutionPath[i] = i;
    image[i] = 0;
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
    scan(hilbertResolutionPath);
    updateHilbertResolutionPath(image);
  }
}

void onImageUpdate(int * pixelToUpdate){
  int currPin = getSONARPin(sonar::pins::trig,pixelLoc)
  digitalWrite(currPin,LOW);
  delayMicroseconds(2);
  digitalWrite(currPin,HIGH);
  delayMicroseconds(10);
  digitalWrite(currPin,LOW);
  updatePixelLoc();
  mPLocFDir = gMPLocFDirGiven(directionEncodingA,directionEncodingB);
  if (pixelLoc==mPLocFDir) {updatePixel(pixelToUpdate,pixelLoc);}
}

int gMPLocFDirGiven(gDirEA,gDirEB){
  if (gDirEA){
    if (gDirEB){return 1;} else {return 3;}
  } else {
    if (gDirEB){return 0;} else {return 2;}
  }
}

void updatePixel(int ** pixelToUpdate, int pixelLoc){
  double dur = pulseIn(getSONARPin(sonar::pins::echo,pixelLoc));
  double dist = dur*0.034/2;
  **pixelToUpdate = threshold(dist);
}

int updatePixelLoc(){
  if (pixelLoc==3) {pixelLoc=0;return -1;}
  pixelLoc=pixelLoc+1;
  return -1;
}

int getSONARPin(boolean isTrig, int pLoc) {
  if (!isTrig) {return 16;}
  if (pLoc==0) {return 17;}
  if (pLoc==1) {return 18;}
  if (pLoc==2) {return 19;}
  if (pLoc==3) {return 20;}
}

void scan(int * [1024] resolutionPath) {
  // code to calculate degrees here
  // then call phasedArray(angX,angY,pointToSave)
  for (int i = 0; i < 1023; i++) {
    currentPoint = (*resolutionPath)[i];
    currentX = currentPoint % 32;
    currentY = floor(currentPoint / 32);
    currentPixel = &(image[currentPoint]);
    currentD = prevImage[currentPoint];
    degX = asin(currentX / currentD);
    degY = asin(currentY / currentD);
    phasedArray(degX, degY, currentPoint);
  }
}

void phasedArray(float angX, float angY, int pointToSave) {
  directionEncodingA = (angX >= 0);
  directionEncodingB = (angY >= 0);
  timingA = calcPhasedArrayTimings(angX);
  timingB = calcPhasedArrayTimings(angY);
  timingA = timingA*100;
  timingB = timingB*100;
  runPhasedArray(timingA,timingB,directionEncodingA,directionEncodingB)
}

int calcPhasedArrayTimings(float ang) {
  //calculate phased array timings here
}

void runPhasedArray(int timingA, int timingB, boolean directionEncodingA, boolean directionEncodingB) {
  //run the phased array
  digitalWrite(6,LOW); //reset dorun
  digitalWrite(10,HIGH);
  delay(1);                  //RESET ALL
  digitalWrite(10,LOW);
  
  digitalWrite(7,LOW); //SELECT A REGISTER
  
  for(int i = 0; i<19; i++){
    digitalWrite((bitRead(timingA, i) == 0)?HIGH:LOW);
    digitalWrite(5,HIGH);
    delay(1);                  //CLOCK
    digitalWrite(5,LOW);
  }
  digitalWrite(7,HIGH); //SELECT B REGISTER
  
  for(int i = 0; i<19; i++){
    digitalWrite((bitRead(timingB, i) == 0)?HIGH:LOW);
    digitalWrite(5,HIGH);
    delay(1);                  //CLOCK
    digitalWrite(5,LOW);
  }
  //set and run
  digitalWrite(8,directionEncodingA?HIGH:LOW);
  digitalWrite(9,directionEncodingB?HIGH:LOW);
  digitalWrite(6,HIGH);
}
