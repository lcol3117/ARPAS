int image [1024];
int hilbertResolutionPath [1024];

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
  digitalWrite(4,LOW);
  digitalWrite(5,LOW);
  digitalWrite(6,LOW);
  digitalWrite(7,LOW);
  digitalWrite(8,LOW);
  digitalWrite(9,LOW);
  digitalWrite(10,LOW);
  attachInterrupt(digitalPinToInterrupt(1),updateImage);
  for (int i = 0; i < 1023; i++) {
    hilbertResolutionPath[i] = i;
    image[i] = 0;
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  if (millis()%1000<=5) {
    scan(hilbertResolutionPath, image);
    hilbertResolutionPath = hilbertEdgeDetection(image);
  }
}

void scan(int [1024] resolutionPath, int [1024] prevImage) {
  // code to calculate degrees here
  // then call phasedArray(angX,angY,pointToSave)
  for (int i = 0; i < 1023; i++) {
    currentPoint = resolutionPath[i];
    currentX = currentPoint % 32;
    currentY = floor(currentPoint / 32);
    currentD = prevImage[currentPoint];
    degX = asin(currentX / currentD);
    degY = asin(currentY / currentD);
    phasedArray(degX, degY, currentPoint);
  }
}

void phasedArray(float angX, float angY, int pointToSave) {
  directionEncodingA = (angX >= 0)?0:1;
  directionEncodingB = (angY >= 0)?0:2;
  timingA = calcPhasedArrayTimings(angX);
  timingB = calcPhasedArrayTimings(angY);
  timingA = timingA*100;
  timingB = timingB*100;
}

int calcPhasedArrayTimings(float ang) {
  //calculate phased array timngs here
}


