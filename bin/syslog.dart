import 'dart:async';
import 'dart:convert';
import 'dart:io';

Syslog log;
int port = 514;
void main() {
  print("Hello, World!");
  int priority = _Syslog._priority(Facility.local0, Severity.Debug);
  int version = 1;
  String timestamp = '2014-01-19T19:29:53';
  String hostname = '127.0.0.1';
  String app_name = 'dartSys';
  String procId = '9080';
  String msgId = '1';
  String header = '<$priority>$version $timestamp $hostname $app_name $procId $msgId';
  String STRUCTURED_DATA = '';
  String Msg = 'TestingDart${new DateTime.now()}';
  String sysMsg = '$header $STRUCTURED_DATA $Msg';
  print(sysMsg);
  print(sysMsg.codeUnits.join(','));
  udpSocket(sysMsg);
}

void udpSocket(String message) {
  RawDatagramSocket.bind(InternetAddress.LOOPBACK_IP_V4, 0).then((RawDatagramSocket socket) {
    socket.listen((RawSocketEvent event) {
      print('event: $event');
      if (event == RawSocketEvent.READ) {
        Datagram data = socket.receive();
        print('Message: ${ASCII.decode(data.data)}');
        data.data.forEach(print);
      }
    });
    
    print('Broadcast? ${socket.isBroadcast}');
    print('Address? ${socket.address}');
    print('Port? ${socket.port}');
    
    //new Future.delayed(new Duration(seconds: 2), () => socket.send([66], InternetAddress.LOOPBACK_IP_V4, 514));
    new Future.delayed(new Duration(seconds: 2), () { 
      socket.send(message.codeUnits, InternetAddress.LOOPBACK_IP_V4, port);
    });
  });
}

abstract class Syslog {  
  RawDatagramSocket socket;
    
  /**
   * Binds the Syslog class to a specified host for further logging.
   * See the Syslog constructor for details on the parameters.
   */
  static Future<Syslog> open(hostname, String name, int flags ) {
    return _Syslog.open(hostname, name, flags);
  }
  
  /**
   * Performs a syslog to the currently bound syslog host.
   */
  void log(int facility, int level, String message);
  
  /**
   * Unbinds the current syslog host.
   */
  void close();
}

class _Syslog extends Syslog {
  RawDatagramSocket _socket;
  
  _Syslog(RawDatagramSocket socket): _socket = socket;
  
  static Future<Syslog> open (hostname, String name, int flags) { 
    return RawDatagramSocket.bind(hostname, port)
        .then((RawDatagramSocket value) => new _Syslog(value));
  }
  
  void log(int facility, int level, String message) {
    List<int> bytes = [65];
    socket.send(bytes, socket.address, socket.port);
  }
  
  void close() {
    
  }
  
  static int _priority(int facility, int severity) => facility * 8 + severity;
}

class Facility {
  static const int kernal = 0;
  static const int userlevel = 1;
  static const int mail = 2;
  static const int systemDaemons = 3;
  static const int security = 4;
  static const int syslogdInternal = 5;
  static const int lineprinter = 6;
  static const int networkNews = 7;
  static const int UUCP = 8;
  static const int clock = 9;
  static const int authorization = 10;
  static const int FTP = 11;
  static const int NTP = 12;
  static const int logAudit = 13;
  static const int logAlert = 14;
  static const int clockDaemon2 = 15;
  static const int local0 = 16;
  static const int local1 = 17;
  static const int local2 = 18;
  static const int local3 = 19;
  static const int local4 = 20;
  static const int local5 = 21;
  static const int local6 = 22;
  static const int local7 = 23;
}

class Severity {
  static const int Emergency = 0;
  static const int Alert = 1;
  static const int Critical = 2;
  static const int Error = 3;
  static const int Warning = 4;
  static const int Notice = 5;
  static const int Informational = 6;
  static const int Debug = 7;
}
