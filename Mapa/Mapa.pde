
import googlemapper.*;
import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
PImage mapa;
GoogleMapper gMapper; //codigo de la nueva libreria, busca un mapa, guarda la imagen dependiendo de las coordenadas

//primer intento para graficar el CO2
float GLP;
float CO2;

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
Knob perilladeCO2;
Knob perilladeGLP;
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
   ENASerial = new Serial (this, Serial.list()[0], 9600);//[numero serial] detectar automatico el puerto del arduino A
   background (200);
   noFill();
   stroke(#663399,25);
   smooth ();

     cp5 = new ControlP5(this);
coordenadaX01 = width-160;
     perilladeTemp = cp5.addKnob ("Temperatura")
              .setRange(-55, 90)
              .setValue(0)
              .setPosition(coordenadaX01,10)
              .setRadius(50)
              .setColorForeground(color(255, 200, 57))
              .setColorBackground(color(255, 0, 0))
              ;
     cp5 = new ControlP5(this);
     perilladeHumedad = cp5.addKnob ("Humedad")
              .setRange(-55, 90)
              .setValue(0)
              .setPosition(coordenadaX01,130)
              .setRadius(50)
              .setColorForeground(color(30, 144, 255))
              .setColorBackground(color(78, 29, 126))
              ;
             
       cp5 = new ControlP5(this);
     perilladeBarometro = cp5.addKnob ("Press")
              .setRange(800, 850)
              .setValue(0)
              .setPosition(coordenadaX01,250)
              .setRadius(50)
              .setColorForeground(color(0, 144, 70))
              .setColorBackground(color(78, 234, 12))
;
      cp5 = new ControlP5(this);
     perilladeTemp2 = cp5.addKnob ("temperatura y presion")
              .setRange(-55, 90)
              .setValue(0)
              .setPosition(coordenadaX01,370)
              .setRadius(50)
              .setColorForeground(color(80, 234, 80))
              .setColorBackground(color(200, 234, 12)) 
;
    
     cp5 = new ControlP5(this);
     perilladeGLP = cp5.addKnob ("GLP")
              .setRange(0, 10000)
              .setValue(0)
              .setPosition(730,485)
              .setRadius(50)
              .setColorForeground(color(69, 24, 80))
              .setColorBackground(color(20, 24, 12));
              
               cp5 = new ControlP5(this);
     perilladeCO2 = cp5.addKnob ("CO2")
              .setRange(0, 200)
              .setValue(0)
              .setPosition(coordenadaX01,485)
              .setRadius(50)
              .setColorForeground(color(87, 134, 190))
              .setColorBackground(color(240, 24, 120))
              
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
background(0);
image(mapa,0,0);

CatSatLatitud = Latitud ;
CatSatLongitud =Longitud;
                           //    22.6         21.49
Latitud = map(mapCenterLat, minLatCatSatY, maxLatCatSatY, 0, altoMapa);
Longitud = map(mapCenterLon, minLonCatSatX, maxLonCatSatX, 0, anchoMapa);



  if (valordecadena != null ) {
    String[] list = split(valordecadena, ','); 
   //printArray(list);
    int temperatura = int (list[1]);
    //println("temperatura: " + temperatura);
     perilladeTemp.setValue(temperatura);
    int humedad = int(list[2]);
    //println("humedad: " + humedad);
    int  press= int(list[3]);
     perilladeHumedad.setValue(humedad);
    //println("presión: " + press);
     perilladeBarometro.setValue(press);
    int  temperatura2= int(list[4]);
    //println("temperatura y presion: " + temperatura2);
     perilladeTemp2.setValue(temperatura2);
    int  mx= int(list[5]);
    //println("magnetómetro x: " + mx);
    int  my= int(list[6]);
    //println("magnetómetro y: " + my);
    int  mz= int(list[7]);
    //println("magnetómetro z: " + mz);
    int  ax= int(list[8]);
    //println("aceleración x: " + ax);
    int  ay= int(list[9]);
    //println("aceleración y: " + ay);
    int az = int(list[10]);
    //println("aceleración z: " + az);
    int  gx= int(list[11]);
    //println("giroscopio x: " + gx);
    int  gy= int(list[12]);
    //println("giroscopio y: " + gy);
    int  gz= int(list[13]);
    //println("giroscopio z: " + gz);
    float LatitudReal= float (list[14]);
    //println("latitud: " + LatitudReal);
    float  LongitudReal= float (list[15]);
    //println("longitud: " + LongitudReal);
    int MQ135 = int(list[16]); 
     println("MQ135:" + MQ135);
    int MQ2 = int(list[17]);
    println("M2:" + MQ2);
    
  //Sensor MQ135
float voltaje1 = MQ135 * (3.7 / 1023.0); //Convertimos la lectura en un valor de voltaje
float Rs1=1000*((3.7-voltaje1)/voltaje1);  //Calculamos Rs con un RL de 1k
CO2 = 132.01*pow(Rs1/1062, -2.737); // calculamos la concentración  de alcohol con la ecuación obtenida.
 
 
 // println("    voltaje:");
//  println(voltaje1);
  //println("    Rs:");
 // println(Rs1);
  print("CO2:" + CO2);
  println("ppm");
 perilladeCO2.setValue(CO2);
  
  
  //Sensor MQ2
  float voltaje2 = MQ2 * (3.7 / 1023.0); //Convertimos la lectura en un valor de voltaje
  float Rs2=1000*((3.7-voltaje2)/voltaje2);  //Calculamos Rs con un RL de 1k
  GLP = 629.05*pow(Rs2/3269, -2.041); // calculamos la concentración  de alcohol con la ecuación obtenida.
  
  //println("    voltaje:");
 // println(voltaje2);
  //println("    Rs:");
 // println(Rs2);
  print("GLP:" +  GLP);
  println("ppm");
  perilladeGLP.setValue(GLP);
    
    float Altura = (pow((1013.25 / press), 1/5.257) - 1.0) * (temperatura2 + 273.15)  / 0.0065;
    println("Altura" +  Altura); 
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
 
  //delay(100);
}



    
void controlEvent(ControlEvent theEvent) {
}



void serialEvent(Serial port){  
  valordecadena = ENASerial.readStringUntil('\n');
  //println(valordecadena);//impresion con salto de linea
}
              
  
void draw() {
background(255,100,100);
image(mapa,0,0);

CatSatLatitud = CatSatLatitud + random(-0.001, 0.002);
CatSatLongitud = CatSatLongitud + random(-0.002, 0.001);
                           //    22.6         21.49
latitud = map(CatSatLatitud, minLatCatSatY, maxLatCatSatY, 0, altoMapa);
longitud = map(CatSatLongitud, minLonCatSatX, maxLonCatSatX, 0, anchoMapa);

coordenadasX.append(longitud);
coordenadasY.append(latitud);

for ( int i = 0; i < coordenadasX.size(); i++) {
  
  
  if (i>0){
    stroke(255, 3, 44);
    strokeWeight(3);
    line(coordenadasX.get(i),coordenadasY.get(i),coordenadasX.get(i-1),coordenadasY.get(i-1));
  }
  
}  


fill(255);
ellipse(longitud, latitud, 30, 30);
 // bezier (0, height/2, width/2,x, width/2,height-x, width, height/2);
  
  if (valordecadena != null ) {
    String[] list = split(valordecadena, ','); 
   // printArray(list);
    int temperatura = int(list[1]);
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
    int  latitud= int(list[14]);
    println("latitud: " + latitud);
    int  longitud= int(list[15]);
    println("longitud: " + longitud);
    
  }
  
}





    
void controlEvent(ControlEvent theEvent) {
}



void serialEvent(Serial port){  
  valordecadena = ENASerial.readStringUntil('\n');
  //println(valordecadena);//impresion con salto de linea
}