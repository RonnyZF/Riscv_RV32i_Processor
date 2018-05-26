//defines e includes
#include <SPI.h>
#include <RH_RF69.h>
#include <Adafruit_SleepyDog.h>
#define RF69_FREQ 915.0


#if defined (__AVR_ATmega32U4__) //  se designa el uso del modulo Feather 32u4 w/Radio
#define RFM69_CS      8 // asignacion y configuracion de los puertos
#define RFM69_INT     7
#define RFM69_RST     4
#define LED           13
#endif


uint8_t Alarma1=HIGH;  // se define el tipo de dato uint8_t para definir un tamaño establecido de bits para las alarmas
uint8_t Alarma2=HIGH;
uint8_t Alarma3=HIGH;
uint8_t Alarma4=HIGH;
char Pila_alarmas[2]; //se define una variabe de tipo char para almacenar las alarmas

int btn_1=0;  //se definen los botone para las alarmas y el de borrado
int btn_2=1;
int btn_3=2;
int btn_4=3;
int borrado;

//variables utilizadas
/*variables para estados*/
int alarma = 0;
int mio = 0;
int alarma_pila = 0;
int tramas_pila = 0;
int T = 20;
int NumT = 0;
int RTS_reci = 0;
int CTS_env = 0;
int rec_alarma = 0;
int CHECK = 0;
int Correcion = 0;
int Res_peticion_trama = 0;
int PT = 0;
int RTS_env = 0;
int CTS_reci = 0;
int Trama_ack = 0;
int cont = 0;
int Estado = 0; //variable que defini el estado de la maquina general del sistema
int level_ADM = 255;
int start = millis();
int thread_level;
int x, y;
int MCL = 3;
int level_AMD;
bool cluster = 0;
int conth = 0;
int alarm = 0;
int conta = 0;
int start1 = millis();
int NIVEL_ADM;
int NIVEL_AMD;
//escucha
int tiempoenmilis;
int MAC_destinatario;
int MAC_emisor;
int NIVEL_ADM_emisor;
int CHECK_SUM_recibido;
int CHECK_SUM_enviado;

int mace; //valores de salida de la funcion escucha
int pte; 
int ctse;
int rtse;
int acke;
int alarmae;
uint8_t buf[RH_RF69_MAX_MESSAGE_LEN]; //de esta forma es captado un mensaje
uint8_t len = sizeof(buf); // con la variable len se determina el  tamaño del mensaje



RH_RF69 rf69(RFM69_CS, RFM69_INT);
int16_t packetnum = 0;  //cantiad de paquetes que son enviados
int MAC_destinario; // variable de tipo entera para la direccion MAC
/*COMPRESION*/
int XC = 0;
int LC = 0;
int TC = 0;
int CC = 0;
char stringc[999999];
int cambioc1 = 0;
int cambioc2 = 0;
int Alarmac;
int NODOC;
int TIPOC;
int MAC_local;

//definicion de variables para la funcion
/*PETICION TRAMA*/
int B = 5;  //factor de tiempo definido en el instructivo
char PT1[4];  //conformacion de la trama PT1
char CTS[5];
char RTS[5] ;
char ACK_IN[3] ; //conformacion de la trama ACK de entrada
char ACK_OUT[3] ; //conformacion de la trama ACK saliente
char Malarma[1];
char TRAMA[1]; // trama de alarma
int contador_p = {0};
int mac;
int CHECK_SUM;  //codigo contenido en el ACK que verifica que se ha recibido correctamente
int checksum_trama;
int len_trama;
int pos_trama;


//estados de la funcion peticion de trama
enum state { primera_fase, segunda_fase, escuchar, verificacion };
enum state current_state = primera_fase;

//estados de la funcion transmision
enum state_f {prim_f, seg_f, ter_f,cuar_f};
enum state_f fase_actual = prim_f;

/* Transferencia */
char data[5];
int ID_NODE = {10}; // ID del nodo actual
int ID_NODE_IN = {20}; // ID del nodo escuchado
int contador_pr = {0}; // contador del primer estado de espera
int contador_s = {0}; // contador del segundo estado de espera
int contador_t = {0}; // contador del tercer estado de espera
int contador_c = {0}; // contador del cuarto estado de espera

//estados de la funcion de estados de espera
enum state_st {primer_estado, segundo_estado, tercer_estado, cuarto_estado};
enum state_st current_state_st = primer_estado;

/*COMPRESION*/
void setup() {
  Serial.begin(115200);
  
  pinMode(btn_1,INPUT_PULLUP);
  pinMode(btn_2,INPUT_PULLUP);
  pinMode(btn_3,INPUT_PULLUP);
  pinMode(btn_4,INPUT_PULLUP);
  
// asignacion de los pines de alarma
  attachInterrupt(digitalPinToInterrupt((btn_1)),Fuego,FALLING);
  attachInterrupt(digitalPinToInterrupt((btn_2)),Moto_sierra,FALLING);
  attachInterrupt(digitalPinToInterrupt((btn_3)),Disparo,FALLING);
  attachInterrupt(digitalPinToInterrupt((btn_4)),AD,FALLING);


    while (!Serial) ; // wait for Arduino Serial Monitor 
  Serial.begin(115200); // velocidad de baudios
  pinMode(LED, OUTPUT);    //led que indica que hay comunicacion
  pinMode(RFM69_RST, OUTPUT);
  digitalWrite(RFM69_RST, LOW);
  Serial.println("Feather RFM69 RX Test!"); //para el serial ploter
  Serial.println();
  digitalWrite(RFM69_RST, HIGH);
  delay(10);
  digitalWrite(RFM69_RST, LOW);
  delay(10);
  if (!rf69.init()) {
    Serial.println("RFM69 radio init failed");
    while (1);
  }
  Serial.println("RFM69 radio init OK!");
  if (!rf69.setFrequency(RF69_FREQ)) {
    Serial.println("setFrequency failed");
  }
  rf69.setTxPower(20, true);  // define el rango va de 14-20 el true debe estar siempre activo en el hwc
  // esto es como una encriptacion
  uint8_t key[] = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
                    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
                  };
  rf69.setEncryptionKey(key); //uso de una funcion de la libreria Radio Head
  pinMode(LED, OUTPUT);//definicion del led de comunicacion
  Serial.print("RFM69 radio @");  Serial.print((int)RF69_FREQ);  Serial.println(" MHz"); // se imprime el radio de frecuencia
}

/* Estados
  hibernacion=0
  escuchapt=1
  clusterdefinicion=2
  primera fase de peticion de trama=3
  segunda fase de peticion de trama=4
  escucha=5
  verificacion=6
  guardar la alarma en la pila=7
  alarmas en la pila=8
  hay tramas por transmitir=9
  comprimir alarmas y enviar siguiente salto de amd=10
  primer estado de espera=11
  segundo estado de esepera=12
  tercer estado de espera=13
  cuarto estado de espera =14
  se conprimen las alarmas  se enmvian hacia el siguente estado de ADM=15
*/

/*maquina de estados principal de acuerdi al diagrama de estados dado en la especificacion del proyecto
que comtempla la implementacion de todas las funciones*/

void loop() {
  switch (Estado)
  {
    case 0:
      if (alarma == 1)/* busca si tiene alarmas*/
      {
        hibernacion(cont,alarma);
        Estado = 3;
        Serial.print(Estado);
      }
      if (alarma == 0)/* si hay alarmas va a la funcion peticion de tramas*/
      {
        hibernacion(cont,alarma); //llamada de la funcion hibernacion con los parametros cont y alarma
        Estado = 1;
        Serial.print(Estado); //imprime el estado, esto se realizo para comprobacion de funcionamiento
      }
      break;
    case 1:
      nivel();
      Estado = 0;
      Serial.print(Estado);
      break;
    case 2:
      Estado = 0;
      Serial.print(Estado);
      break;
    case 3:
      peticion_trama();
      Serial.print(Estado);
      break;
    case 4:
     peticion_trama();
     Serial.print(Estado);
      break;
    case 5:
      peticion_trama();
      Serial.print(Estado);
      break;
    case 6:
      peticion_trama();
      Serial.print(Estado);
      break;
    case 7:
      Estado = 3;
      Serial.print(Estado);
      break;
    case 8:
      if (alarma_pila == 1)
      {
        Estado = 9;
        Serial.print(Estado);
      }
      if (alarma_pila == 0)
      {
        Estado = 0;
        Serial.print(Estado);
      }
      break;
    case 9:
      if (tramas_pila == 1)
      {
        Estado = 15;
        Serial.print(Estado);
      }
      if (tramas_pila == 0)
      {
        Estado = 10;
        Serial.print(Estado);
      }
      break;
    case 10:
      Estado = 11;
      Serial.print(Estado);
    case 11:
    prim_estado();
    Serial.print(Estado);
      break;
    case 12:
    seg_estado();
    Serial.print(Estado);
      break;
    case 13:
    terc_estado();
    Serial.print(Estado);
    break;
    case 14:
    cuar_estado();
    Serial.print(Estado);
      break;
    case 15:
      Estado = 11;
      Serial.print(Estado);
      break;


  }
}

/*Nivel de Pertenencia ADM*/
void nivel()
{
  while (millis() < start + 600) {
    if (thread_level < NIVEL_ADM) {
      NIVEL_ADM = thread_level;
    }
  }
  NIVEL_ADM++;
  /*Nivel de Pertenencia AMD*/
  x = NIVEL_ADM % (MCL * 2);
  y = (MCL * 2) - x;

  if (x < y)
    NIVEL_AMD = x;
  else
    NIVEL_AMD = y;
  if (x == 0)
    cluster = 1;
}

// Funcion de hibernacion
void hibernacion(int cont, int alarm) {
  delay(1000);
  int sleepMS = Watchdog.sleep(200);

  if (alarm == 0)
  {
    if (conta >= 20){
      return;
    }
    if (conta <= 20)
    {
      conth = conth + 1;
      hibernacion(cont, alarm);
    }
  }
  if (alarm != 0){
    return;
  }

}

void escucha(int tiempoenmilis)  {
  start1 = millis();
  if (rf69.available()) { // verifico que el sistema de rf este habilitado

    while (millis() <= (start1 + tiempoenmilis)) { // tomo un tiempo determinado de escucha para reducir la potencia consumida
      uint8_t buf[RH_RF69_MAX_MESSAGE_LEN]; // codigo para recuperar el mensaje
      uint8_t len = sizeof(buf); // longitud del codigo recuperado
      if (rf69.recv(buf, &len)) { // verifico el dato recuperado y su longitud
        if (!len) return;
        buf[len] = 0;
        Serial.print("Received [");
        Serial.print(len);// longitud del mensaje recuperado
        Serial.print("]: ");
        Serial.println((char*)buf);// asi imprimen el mensaje al serial ya que al ser un uint8_t solo con el char* podría imprimirse
        Serial.print("RSSI: ");
        Serial.println(rf69.lastRssi(), DEC);
        if (buf[0] == 243 && buf[4] == mace) { // comparador del dato principal del pt y la direccion
          pte = 0;
          ctse = 1;
          rtse = 0;
          alarmae = 0;
          acke = 0;
          mio = 1;
        }
        if (buf[0] == 243 && buf[4] != mace) {
          pte = 0;
          ctse = 1;
          rtse = 0;
          alarmae = 0;
          acke = 0;
          mio = 0;
        }

        if (buf[0] == 241) {
          pte = 1;
          ctse = 0;
          rtse = 0;
          alarmae = 0;
          acke = 0;
        }
        if (buf[0] == 242) {
          pte = 0;
          ctse = 0;
          rtse = 1;
          acke = 0;
          alarmae = 0;
        }
        if (buf[0] == 244) {
          pte = 0;
          ctse = 0;
          rtse = 0;
          acke = 0;
          alarmae = 1;
        }
        if (buf[0] == 245) {
          pte = 0;
          ctse = 0;
          rtse = 0;
          acke = 1;
          alarmae = 0;
        }
      }
    }
  }
  else {
    Serial.println("Receive failed");
  }
}


/*compresion de datos*/

void compresion() {
  int XC = 0;
  int LC = 0;
  int TC = 0;
  int CC = 0;
  char stringc[999999];
  int cambioc1 = 0;
  int cambioc2 = 0;
  int Alarmac;
  int NODOC;
  int TIPOC;
  while (XC != LC) {
    if (stringc[XC] == Alarmac) {
      stringc[XC + 1] = stringc[XC + 1] + 1;
      cambioc1 = stringc[XC + 2];
      for (int i = XC + 2; i <= LC + 1; i++) {
        cambioc2 = stringc[i + 1];
        stringc[i + 1] = cambioc1;
        cambioc1 = cambioc2;
      }
      stringc[XC + 2] = NODOC;
    }
    else {
      stringc[0] = cambioc1;
      for (int i = 0; i <= 2; i++) {
        cambioc2 = stringc[i + 1];
        stringc[i + 1] = cambioc1;
        cambioc1 = cambioc2;
      }
      stringc[0] = TIPOC;
      stringc[1] = 1;
      stringc[2] = NODOC;

    }
  }
}

//funcion que genera el CHECKSUM pra a comprobacion de la trama
void gen_ACK(char* TRAMA){
  if (TRAMA != 0){
    pos_trama = len_trama - 1;
    checksum_trama = 0;    
    while (pos_trama >= 0){
      checksum_trama= TRAMA[pos_trama] + checksum_trama;
      pos_trama = pos_trama - 1;
      }
  } 
  return;
}

// funcion peticion de trama en la que el sistema detecta tramas sino se encarga de enviar peticiones de trama
int peticion_trama()
{
  
    switch (current_state)
    {
      case primera_fase:
        {
          escucha(2 * B);
          if (ctse == 0 or rtse == 0)   // verifica si no hay un cts o rts para enviar la peticion de trama
          {
            PT1[0] = 240;              // se conforma cada uno de los bytes de la trama PT
            PT1[1] = 48;
            PT1[2] = NIVEL_ADM;
            PT1[3] = MAC_local;
            rf69.send(PT1, sizeof(PT1)); // por medio de este comando se envia la trama PT conformada en las lineas anteriores
            escucha(2*B);                //hace un llamado a la funcion escucha por un tiempo determinado
            if (rtse != 0){               //verifica si hay un rts para cambiar de fase de peticion de trama
              current_state = segunda_fase; //se asigna el estado a segunda fase
              
              return;
            }
            else{
            Estado=0; //en caso de no escuhar un rts se envia al estado de hibernacion
            return;   
            }
               
        }
        else{
          if (alarma==0){ 
            Estado=0; // en caso de que no existan alarmas se envia al estado de hibernacion
            return;
          }
          else{
            Estado=11;
            return;
            }
        }
        }

          
      case segunda_fase: 
        {                 //se conforma la trama CTS
            CTS[0] = 243;
            CTS[1] = NIVEL_AMD;
            CTS[2] = NIVEL_ADM;
            CTS[3] = TRAMA[3]; //Reenvia el valor del tamaño de la trama RTS que recibio anteriormenete
            CTS[4] = TRAMA[4];
            MAC_destinatario = TRAMA[4];
            rf69.send(CTS, sizeof(CTS)); //se envia la trama CTS
            current_state = escuchar;
            Estado=5; 
            return;
        }
      case escuchar:
        {
          escucha(2*B); //se llama a la funcion de escucha por un tiempo determinado
          if (alarmae!= 0) {  //verifica si han llegado alarmas
            current_state = verificacion; //permance en estado de verificacion
            Estado=6;
            return;
          }
          else  {
            Estado=0;  //vuelve al estado de hibernacion
            
            return;
          }
        }
      case verificacion:
        {               // se genera la trama ACK para verificar si se recibio bien la trama
          gen_ACK(TRAMA);
          ACK_OUT[0] = 245;
          ACK_OUT[1] = checksum_trama;
          ACK_OUT[2] = MAC_destinario; //revisa si el mensje me pertenece
          escucha(2*B); //llamada de la funcion
          if (alarmae == 0){
            borrado=0;
            pila_alarmas();
            current_state = primera_fase; //vuelve al estado de primera fase a iniciar el proceso
            Estado=3;
            return;
          }
          else { 
            current_state = verificacion;
            Estado=6;  //llama la funcion para iniciar el proceso de peticion de trama
            return;
          }
        }
    }
  }



void Trasmision(){
  case prim_f:
  {
    if (ctse != 0 or rtse != 0){ //se condiciona que CTS o RTS deben estar activos para ingresar 
      delay(10); //tiempo de trasmisión
      fase_actual = prim_f; // devuelve al estado base de la funcion, primer fase 
      }
    else if (pte != 0){ // si existe un PT entrante
      MAC_emisor=TRAMA[4]; // la MAC del emisor proviene de la trama de entrada
      NIVEL_ADM_emisor = TRAMA[3]; // se almacena el nivel en la estructura del emisor
      if (NIVEL_ADM_emisor == NIVEL_ADM-1) // si se tiene un nivel de eisor inmediatamente inferior al nivel actual se reconfigura la red
      { 
        fase_actual = seg_f; // ago paso la segunda fase
        }
    } 
    }
    break;
    
  case seg_f:
  {
    delay((rand() % 12 + 2)*B) ; // se espera un tiempo aleatorio en un rango para no colisionar con otras señales
    escucha(2*B); // se llama la funcion de escuchar
    if (ctse !=0){
      if(MAC_local==TRAMA[5]){ // verificar si el dato me pertenece
        if (contador_s == 3){
          Estado=0;// entra en el estado de hibernacion
          contador_s = 0; // reinicio contador de repeticiones de segunda fase
        }
        else{
              contador_s = contador_s +1; // aumento en 1 el contador de fase 2
              fase_actual = prim_f;
            }
        }
      }
    else {//Se envia la trama RTS
      contador_s = 0;
      fase_actual = ter_f;
      }
  }
  case ter_f:
  {
    if (ctse != 0) {
      if (TRAMA[5]==MAC_local){// se analizan las MAC Address del local y emisor del CTS
            fase_actual = cuar_f;
            contador_t = 0; // se reinicia el contador de tercer estado
            }
      }
    else if (ctse == 0) { // si no existe ctse en el momento 
      if (contador_t == 12) { // al contador llegar al maximo
        Estado=0;// Pasa a modo Hibernación
        contador_t = 0;
        }
        else {
          contador_t = contador_t +1;
          fase_actual = prim_f;
        }
      } 
    break;
  }
  case cuar_f:
  {
    uint8_t data [3] ; // trama de datos de envio
    data[0]=245; // partes de trama
    data[1]=TRAMA[len-1]; // partes de trama
    data[2]=MAC_emisor; // parte de la trama
    rf69.send(data, sizeof(data)); // comando envio de datos en el rf69 
    delay(10); // tiempo de espera 
    if (acke != 0){ // escucha por el ack entrante
      CHECK_SUM_recibido=TRAMA[2];
      if (CHECK_SUM_recibido==CHECK_SUM_enviado){ // si ack recibido en este caso CHECK_SUM existe y es igual al que se envio
        borrado=1;
        pila_alarmas();
        borrado=0;
        Estado=0;// pasa a HIBERNACIÓN
        }
        else {
          fase_actual = cuar_f;
          }
      }
      else {
        Estado=0;
        } 
    break;
    }
    return;
}

//alarmas
void Fuego() {
  Pila_alarmas[0]=4;
  Pila_alarmas[1]=NIVEL_ADM;
  alarma=1;
}
void Moto_sierra() {
  Pila_alarmas[0]=2;
  Pila_alarmas[1]=NIVEL_ADM;
  alarma=1;
}
void Disparo() {
  Pila_alarmas[0]=1;
  Pila_alarmas[1]=NIVEL_ADM;
  alarma=1;
}
void AD() {
  Pila_alarmas[0]=5;
  Pila_alarmas[1]=NIVEL_ADM;
  alarma=1;
}
void pila_alarmas() {
  if (borrado==1){
  Pila_alarmas[0]=0;
  Pila_alarmas[1]=0;
  alarma=0;
  }
  else {
    Pila_alarmas[0]=TRAMA[1];
    Pila_alarmas[1]=TRAMA[2];
    alarma=1;
    
  }
}
  

