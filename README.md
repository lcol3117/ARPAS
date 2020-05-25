# ARPAS
Code for the Adaptive Resolution Phased Array SONAR project

The main controller doing the phased array calculations and adaptive resolution mapping is the Arduino, programmed in C++. 

The FPGA (Numato Mimas, Xilinx XCS6LX9) is used to apply the precise timings and return the information. 

The Phased Array is 2 HC-SR04 SONAR modules. 

Arduino 1.8.10 is used to program the Arduino MKR1000 on MacOS X.
Xilinx ISE WebPack 14.7 is used to program the FPGA on Ubuntu 18.04. 
