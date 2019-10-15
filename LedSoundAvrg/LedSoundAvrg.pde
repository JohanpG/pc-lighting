/*
**this program includes sections of various example available online**

This program is to read audio from your computer, analyze it, and sent PWM levels to your arduino for LED PWM.

Minim AudoInput reads the default recording device for your computer (Windows)
To set it so it reads the audio from your computer and NOT your default recording device (aka microphone) do this:
1) right - click the colume icon on the taskbar and click the recording devices tab.
2) right click in the selection window and click the "Show Disabled Devices" tab. this should now show a "Stereo Mix" option
3) right click "Stereo Mix" and go to properties
4) go to "Listen tab in properties and ensure that "Listen to this device" is UN-CHECKED. otherwise you will get loud feedback.
5) select "OK" at the bottom
6) left-click stereo mic and click the "Set Default" icon below it

This should set your computer's output audio as the input for this program.
If you use your mic for VOIP programs, such as Ventrilo or Teamspeak, you need to select your microphone as the recording device 
  in the program instead of use default device for this to work simultaneously

*/



import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.serial.*;

Serial myPort;

AudioPlayer jingle;

Minim minim;
//AudioPlayer jingle;
AudioInput in;
//AudioOutput out;
FFT fft;

BeatDetect beat;

//variables for FFT
int buffer_size = 1024;  // also sets FFT size (frequency resolution)
float sample_rate = 20000;

void setup()
{
  size(512, 255, P3D);
  
  minim = new Minim(this);
  
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  
  in = minim.getLineIn(Minim.MONO,buffer_size,sample_rate);
   
  fft = new FFT( in.bufferSize(), in.sampleRate() );
   beat = new BeatDetect();
    
}

void draw()
{
  
  float[] rA = new float[11];
  float[] gA = new float[11];
  float[] bA = new float[11];
  
  background(0);
  stroke(255);
  
  //Change-able; range parameters for each band
  int a = 75;
  int b = 150;
  int c = 512;
  
  //Change-able; multipliers to fft results to scale each band
  int xR = 3;
  int xG = 3;
  int xB = 1;
  
  //initialize variables
  int peakR = 0;
  int peakG = 0;
  int peakB = 0;
 float lastPeak =0;
  int i;
  int ns=1;
  int bass=0;
  
  // perform FFT and write to window for visual spectrum breakdown    
  fft.forward( in.mix ); //combine stereo to mono 
  beat.detect(in.mix);
 
  //FFT spectrum breakdown into LED colors

  //frequency ranges for each RGB color - set for easy tweaking
  //set as max based on fft specs
  //set variables to record peaks

  
  
    //Method to determine peaks within a given range for each color
    //Blue: 0 through a
    for ( i = 0; i < a; i++){
      
      if (fft.getBand(i)*(xB) > peakB){  //fundtion to determine peaks in frequency bands
        peakB = (int)fft.getBand(i)*(xB);
      }
      

      
      stroke(0,0,255);  //draw frequency breakdown in band's color
      line( i, height, i, height - fft.getBand(i)*(xB));
      
      stroke(255);      //add a white pixel at top of bar
      line( i, height - fft.getBand(i)*(xB)-1, i, height - fft.getBand(i)*(xB));
    }
    
    
    //Green: a through b
    for ( i = a; i < b; i++){
      if (fft.getBand(i)*(xG) > peakG){
        peakG = (int)fft.getBand(i)*(xG);
      }  
      
      stroke(0,255,0);
      line( i, height, i, height - fft.getBand(i)*(xG));
      
      stroke(255);
      line( i, height - fft.getBand(i)*(xG)-1, i, height - fft.getBand(i)*(xG));
    }
    
    //Red: b through c
    for ( i = b; i < c; i++){
      if (fft.getBand(i)*(xR) > peakR){
        peakR = (int)fft.getBand(i)*(xR);
      }
      
      stroke(255,0,0);
      line( i, height, i, height - fft.getBand(i)*(xR));
      
      stroke(255);
      line( i, height - fft.getBand(i)*(xR)-1, i, height - fft.getBand(i)*(xR));
    }
    

    
    //add horizontal bar to show peak signal being sent to arduino
    stroke(255);
    line(0, height - peakB, a , height - peakB);
    stroke(255);
    line(a, height - peakG, b , height - peakG);
    stroke(255);
    line(b, height - peakR, c , height - peakR);
    
    if ( beat.isOnset() ) bass = 20;
    if ((peakB==0) && (peakG==0) && (peakR==0)){
      ns=0;
    
    }
    for (int LED = 1; LED < 11; LED++){
   if((peakB>peakG)&&(peakB>peakR)){
  rA[LED] = peakR;
  gA[LED] = peakG;
  bA[LED] = peakB+(LED*4*ns);
   
   }
   if((peakG>peakB)&&(peakG>peakR)){
  rA[LED] = peakR;
  gA[LED] = peakG+(LED*4*ns);
  bA[LED] = peakB;
   
   }
   if((peakR>peakB)&&(peakG>peakG)){
  rA[LED] = peakR+(LED*4*ns);
  gA[LED] = peakG;
  bA[LED] = peakB;
   
   }
  else{
  rA[LED] = peakR+(LED*4*ns);
  gA[LED] = peakG+(LED*4*ns);
  bA[LED] = peakB+(LED*4*ns);
  }
}
  
  //LEDS CON BAJO AZUL MEDIOS VERDES ALTOS ROJOS  
  // for (int LED = 1; LED < 5; LED++){
  
  // rA[LED] =  bass;
  // gA[LED] =  bass;
  // bA[LED] = peakB + bass+(LED*2);
  // }
  
  // for (int LED = 5; LED < 8; LED++){
  
  // rA[LED] =  bass;
  // gA[LED] = peakG + bass+(LED*2);
  // bA[LED] = bass;
  // }
  // for (int LED = 8; LED < 11; LED++){
  
  // rA[LED] = peakR + bass+(LED*2);
  // gA[LED] =  bass;
  // bA[LED] =  bass;
  // }
  
    //write variables to console and arduino. set so arduino can use Serial.parseInt to breakout data
  println("Led 1 "+bA[1]+","+gA[1]+","+rA[1]+"\n");
  println("Led 10 "+bA[10]+","+gA[1]+","+rA[10]+"\n");
    println("size "+fft.specSize()+"\n");
  //myPort.write(peakR+","+peakG+","+peakB+"\n");
  
   myPort.write(0x3e); //write marker, arduino is looking for this
   for (int Br = 1; Br < 11; Br++){
   myPort.write((byte)(rA[Br]));
   myPort.write((byte)(gA[Br]));
   myPort.write((byte)(bA[Br]));
  }
 
  delay(10); //delay for safety
    
}

void stop(){
   float[] rA = new float[11];
  float[] gA = new float[11];
  float[] bA = new float[11];
// Do whatever you want here.
for (int LED = 1; LED < 11; LED++){
  
  rA[LED] = 0;
  gA[LED] = 0;
  bA[LED] = 0;
  }
  
   myPort.write(0x3e); //write marker, arduino is looking for this
   for (int Br = 1; Br < 11; Br++){
   myPort.write((byte)(rA[Br]));
   myPort.write((byte)(gA[Br]));
   myPort.write((byte)(bA[Br]));
  }

super.stop();
}
