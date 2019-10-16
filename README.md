# pc-lighting
Processing projects to animate led strips based on Sound ( Frequency and Amplitude Reactive) and Image (Pixel Average Ambient Lights)

# Ambilight

Uses the real time feedback from the screen to compute and average color each where each column represents one RGB led on the LED strip.
So an image like this:

![alt text](https://github.com/JohanpG/pc-lighting/blob/master/Ambilight/Images/AmbilightTest.PNG)

Creates a LED combination of colors like this:

![alt text](https://github.com/JohanpG/pc-lighting/blob/master/Ambilight/Images/Ambilight.PNG)

# Led Sound Average

Does a quick fourier transform and get the amplitude for 3 different frequency ranges as below:

![alt text](https://github.com/JohanpG/pc-lighting/blob/master/LedSoundAvrg/Images/RealTime_Frequency.png)

These 3 ranges control each an array of leds. 

## Video

Sample output of the leds reacting to pc sound on realtime here https://www.youtube.com/watch?v=kNa1CGnWyTQ.

# Author

By: Johan Porras (JohanpG)

