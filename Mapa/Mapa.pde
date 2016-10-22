/*
CATSAT TRAcKING DE ENA 
Viridiana N.C 
Nicole F.
*/
import googlemapper.*;
import controlP5.*;
import processing.serial.*;
//Insertar libreria
ControlP5 cp5;
PImage mapa;
GoogleMapper gMapper; //codigo de la nueva libreria, busca un mapa, guarda la imagen dependiendo de las coordenadas

// Mapa
float mapCenterLat = 21.8857347;
float mapCenterLon = -102.2912996;
int zoomLevel = 10;
String mapType = GoogleMapper.MAPTYPE_HYBRID;
int anchoMapa = 900; //dar informacio para la foto que vamos a necesitar 
int altoMapa = 600;

// Satelite CatSat
float latitud;
float longitud;
float minLatCatSatY;
float maxLatCatSatY;
float minLonCatSatX;
float maxLonCatSatX;
float CatSatLatitud;
float CatSatLongitud;
FloatList coordenadasX;
FloatList coordenadasY;

float x=0;
Knob perilladeTemp;
Knob perilladeHumedad;
Knob perilladeBarometro; 
Knob perilladeTemp2;
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
  minLatCatSatY = 22.2683885;
  maxLatCatSatY = 21.4986971;
  minLonCatSatX = -102.9348029;
  maxLonCatSatX = -101.6658820;
  
  CatSatLatitud = mapCenterLat;
  CatSatLongitud = mapCenterLon;
  
  coordenadasX = new FloatList();
  coordenadasY = new FloatList();
  
  printArray(Serial. list());
   ENASerial= new Serial (this, Serial.list()[0], 9600);//[numero serial] detectar automatico el puerto del arduino A
   background (200);
   noFill();
   stroke(#663399,25);
   smooth ();
   
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