part of syslog;

class _Syslog extends Syslog {
  RawDatagramSocket _socket;
  int _port;
  var _hostname;
  
  _Syslog(RawDatagramSocket socket, hostname, int port): 
    _socket = socket, 
    _hostname = hostname, 
    _port = port;
  
  static Future<Syslog> open (hostname, String name, int flags, {int port: 514}) { 
    const int randomPort = 0;
    return RawDatagramSocket.bind(hostname, randomPort)
        .then((RawDatagramSocket socket) => new _Syslog(socket, hostname, port));
  }
  
  void log(int facility, int Severity, String message) {
    int priority = _Syslog._priority(facility, Severity);
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
    if(sysMsg.length > 65000) {
      throw('Message to long');
    }
    _socket.send(sysMsg.codeUnits, _hostname, _port);
  }
  
  void close() {
    _socket.close();
  }
  
  static int _priority(int facility, int severity) => facility * 8 + severity;
}