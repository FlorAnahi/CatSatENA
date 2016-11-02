
import googlemapper.*;
import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
PImage mapa;
GoogleMapper gMapper; //codigo de la nueva libreria, busca un mapa, guarda la imagen dependiendo de las coordenadas

//primer intento para graficar el CO2
float increment = 0.01;
float zoff = 0.0;
float zincrement = 0.02;

// Mapa
float mapCenterLat = 21.8538187;
float mapCenterLon = -102.2854984;
int zoomLevel = 15;
String mapType = GoogleMapper.MAPTYPE_HYBRID;
int anchoMapa = 1000; //dar informacio para la foto que vamos a necesitar 
int altoMapa = 600;

// Satelite CatSat
float Latitud;
float Longitud;
float minLatCatSatY;
float maxLatCatSatY;
float minLonCatSatX;
float maxLonCatSatX;
float CatSatLatitud;
float CatSatLongitud;
FloatList coordenadasX;
FloatList coordenadasY;

float x=0;
PImage globo;
PImage globo2;
float yglobo;
Knob perilladeTemp;
Knob perilladeHumedad;
Knob perilladeBarometro; 
Knob perilladeTemp2;
Slider BarradeAlt;
/*leer valores desde puerto serial de Arduino
fecha: 8 de octubre de 2016

*/
int coordenadaX01;
int coordenadaY02;

Serial ENASerial;

String valordecadena;


void setup(){
  size(1000,600);// creamos ventana de 700 por 400 pixeles
 
 
  
 gMapper = new GoogleMapper(mapCenterLat, mapCenterLon, zoomLevel, mapType, anchoMapa, altoMapa);
  mapa = gMapper.getMap();
  
  
 
  minLatCatSatY = 21.868097; //22.864707;
  maxLatCatSatY = 21.844466; //21.838856;
  minLonCatSatX = -102.309047; //-102.265379;
  maxLonCatSatX = -102.312018; //-102.321769;
  
  CatSatLatitud = mapCenterLat;
  CatSatLongitud = mapCenterLon;
  
  coordenadasX = new FloatList();
  coordenadasY = new FloatList();
  
  printArray(Serial. list());
   //ENASerial = new Serial (this, Serial.list()[0], 9600);//[numero serial] detectar automatico el puerto del arduino A
   background (200);
   noFill();
   stroke(#663399,25);
   smooth ();
   
/*
   fill(255, 0, 0);
   noStroke();
  */ 
     cp5 = new ControlP5(this);
coordenadaX01 = width-160;
     perilladeTemp = cp5.addKnob ("Temperatura")
              .setRange(-55, 90)
              .setValue(0)
              .setPosition(coordenadaX01,40)
              .setRadius(50)
              .setColorForeground(color(255, 200, 57))
              .setColorBackground(color(255, 0, 0))
              ;
     cp5 = new ControlP5(this);
     perilladeHumedad = cp5.addKnob ("Humedad")
              .setRange(-55, 90)
              .setValue(0)
              .setPosition(coordenadaX01,160)
              .setRadius(50)
              .setColorForeground(color(30, 144, 255))
              .setColorBackground(color(78, 29, 126))
              ;
             
       cp5 = new ControlP5(this);
     perilladeBarometro = cp5.addKnob ("Press")
              .setRange(800, 850)
              .setValue(0)
              .setPosition(coordenadaX01,280)
              .setRadius(50)
              .setColorForeground(color(0, 144, 70))
              .setColorBackground(color(78, 234, 12))
;
      cp5 = new ControlP5(this);
     perilladeTemp2 = cp5.addKnob ("temperatura y presion")
              .setRange(-55, 90)
              .setValue(0)
              .setPosition(coordenadaX01,400)
              .setRadius(50)
              .setColorForeground(color(80, 234, 80))
              .setColorBackground(color(200, 234, 12))
              ;
     BarradeAlt = cp5.addSlider("Altura")
             .setPosition(50, 30)
             .setSize(25, 500)
             .setRange(1000,27000)
             .setSliderMode(Slider.FLEXIBLE)
             .setColorForeground(color(0))
             .setColorBackground(color(255))
     ;
     
   {

     frameRate(30);
   }
}
              
  
void draw() {
background(255,100,100);
//image(mapa,0,0);
// Optional: adjust noise detail here
  // noiseDetail(8,0.65f);
  
  loadPixels();

  float xoff = 0.0; // Start xoff at 0
  
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 100; x < width/2; x++) {
    xoff += increment;   // Increment xoff 
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 60; y < height/2; y++) {
      yoff += increment; // Increment yoff
      
      // Calculate noise and scale by 255
      float bright = noise(xoff,yoff,zoff)*255;

      // Try using this line instead
      //float bright = random(0,255);
      
      // Set each pixel onscreen to a grayscale value
      pixels[x+y*width] = color(bright,bright,bright);
    }
  }
  updatePixels();
  
  zoff += zincrement; // Increment zoff


CatSatLatitud = Latitud ;
CatSatLongitud =Longitud;
                           //    22.6         21.49
Latitud = map(mapCenterLat, minLatCatSatY, maxLatCatSatY, 0, altoMapa);
Longitud = map(mapCenterLon, minLonCatSatX, maxLonCatSatX, 0, anchoMapa);



  if (valordecadena != null ) {
    String[] list = split(valordecadena, ','); 
   // printArray(list);
    int temperatura = int (list[1]);
    println("temperatura: " + temperatura);
     perilladeTemp.setValue(temperatura);
    int humedad = int(list[2]);
    println("humedad: " + humedad);
    int  press= int(list[3]);
     perilladeHumedad.setValue(humedad);
    println("presión: " + press);
     perilladeBarometro.setValue(press);
    int  temperatura2= int(list[4]);
    println("temperatura y presion: " + temperatura2);
     perilladeTemp2.setValue(temperatura2);
    int  mx= int(list[5]);
    println("magnetómetro x: " + mx);
    int  my= int(list[6]);
    println("magnetómetro y: " + my);
    int  mz= int(list[7]);
    println("magnetómetro z: " + mz);
    int  ax= int(list[8]);
    println("aceleración x: " + ax);
    int  ay= int(list[9]);
    println("aceleración y: " + ay);
    int az = int(list[10]);
    println("aceleración z: " + az);
    int  gx= int(list[11]);
    println("giroscopio x: " + gx);
    int  gy= int(list[12]);
    println("giroscopio y: " + gy);
    int  gz= int(list[13]);
    println("giroscopio z: " + gz);
    float LatitudReal= float (list[14]);
    println("latitud: " + LatitudReal);
    float  LongitudReal= float (list[15]);
    println("longitud: " + LongitudReal);
    int MQ2 = int (list[16]); 
    int MQ135 = int (list [17]); 
    
    float Altura = (pow((1013.25 / press), 1/5.257) - 1.0) * (temperatura2 + 273.15)  / 0.0065;
    println(Altura); 
    BarradeAlt.setValue(Altura);
     yglobo= map(Altura, 1000, 27000, 450, 10);
    globo2 = loadImage("globo.png");
    image (globo2, 115, yglobo);

    
    coordenadasX.append(LongitudReal);
    coordenadasY.append(LatitudReal);

for ( int i = 0; i < coordenadasX.size(); i++) {
  
  
  if (i>0){
    strokeWeight(3);
    line(coordenadasX.get(i),coordenadasY.get(i),coordenadasX.get(i-1),coordenadasY.get(i-1));
  }
  
}  

stroke(44,56,78);
globo = loadImage("globo.png");
image (globo, LongitudReal, LatitudReal);

  }
  /*
  {
    background(0);
    
    //iluminacion basica lights ();
    //Dibujaremos centrado en el (0, 0, 0); translate (width/2, height/2);
    
    rotateX(frameCount*PI/60.0);
    rotateY(frameCount*PI/120.0);
    rotateZ(frameCount*PI/180.0);
    box(200, 200, 200);
  }
  
  {
    loadPixels();
    
    float xoff = 0.0; // Start xoff at 0
    
  }
{
updatePixels();



   }*/
}



    
void controlEvent(ControlEvent theEvent) {
}



void serialEvent(Serial port){  
  valordecadena = ENASerial.readStringUntil('\n');
  //println(valordecadena);//impresion con salto de linea
}