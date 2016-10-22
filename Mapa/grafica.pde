import processing.serial.*;
 
 Serial myPort;        // The serial port
 int xPos = 1;         // horizontal position of the graph
 
 void setup () {
 // set the window size:
 size(800, 600);       
 
 // List all the available serial ports
 println(Serial.list());
 // I know that the first port in the serial list on my mac
 // is always my  Arduino, so I open Serial.list()[0].
 // Open whatever port is the one you're using.
 myPort = new Serial(this, Serial.list()[0], 9600);
 // don't generate a serialEvent() unless you get a newline character:
 myPort.bufferUntil('\n');
 // set inital background:
 background(0);
 textSize(32);
 }
 void draw () {
 // everything happens in the serialEvent()
 }
 
 float x1 = 0;
 float x2;
 float y1;
 float y2 = height / 2;
 
 
void escalax(){
   
}
 
 
void serialEvent (Serial myPort) {
 // get the ASCII string:
 String inString = myPort.readStringUntil('\n');
 
 if (inString != null) {
   // trim off any whitespace:
   inString = trim(inString);
   // convert to an int and map to the screen height:
   float inByte = float(inString);
    
   fill(0);
   rect(0, 0, 100, 100);
   fill(204, 102, 0);
   text(inString, 10, 80);
   inByte = map(inByte, 0, 70, 0, height);
 
   // draw the line:
   stroke(204);
   line(xPos - 10, y1, xPos, y2);
    
   y1 = y2;
   y2 = height - inByte;
 
   // at the edge of the screen, go back to the beginning:
   if (xPos >= width) {
   xPos = 0;
   background(0);
 }
 else {
   // increment the horizontal position:
   xPos+=10;
   }
 }
}