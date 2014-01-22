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
  
  void log(int facility, int Severity, String message, {DateTime timestamp, int processId, int messageId, String hostname : '', String appname: ''}) {
    int priority = _Syslog._priority(facility, Severity);
    ////PRI             = "<" PRIVAL ">"
    String pri = '<$priority>'; 
    int version = 1;
    String time = timestamp != null ? '${new DateTime.now()} ': '';
    String host = hostname == null || appname == ''  ? '' : '$hostname ';
    String app = appname == null || appname == '' ? '' : '$appname ';
    String procId = processId != null ? '$processId ' : '';
    String msgId = messageId != null ? '$messageId ' : '';
    
    //HEADER          = PRI VERSION SP TIMESTAMP SP HOSTNAME SP APP-NAME SP PROCID SP MSGID
    String header = '$pri$version $time$host$app$procId$msgId';
    String STRUCTURED_DATA = '';
    String Msg = 'TestingDart${new DateTime.now()}';

    //SYSLOG-MSG      = HEADER SP STRUCTURED-DATA [SP MSG]
    String sysMsg = '$header$STRUCTURED_DATA$Msg';
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