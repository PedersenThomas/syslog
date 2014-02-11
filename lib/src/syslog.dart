part of syslog;

DateFormat _format = new DateFormat('MMM d HH:mm:ss');

class _Syslog extends Syslog {
  RawDatagramSocket _socket;
  int _port;
  InternetAddress _hostname;
  
  _Syslog(RawDatagramSocket socket, InternetAddress hostname, int port): 
    _socket = socket, 
    _hostname = hostname, 
    _port = port;
  
  static Future<Syslog> open (InternetAddress hostname, {int port: 514}) { 
    const int randomPort = 0;
    return RawDatagramSocket.bind(InternetAddress.LOOPBACK_IP_V4, randomPort)
        .then((RawDatagramSocket socket) => new _Syslog(socket, hostname, port));
  }
  
  void log(int facility, int Severity, String message, {DateTime timestamp, String hostname : '', String appname: ''}) {
    String time = timestamp != null ? '${_format.format(timestamp)} ': '${_format.format(new DateTime.now())} ';
    int priority = _Syslog._priority(facility, Severity);
    String host = '';
    String app = '';
    
    if(hostname != null) {
      String trimmedHostname = hostname.trim();
      host = trimmedHostname == ''  ? '' : '${trimmedHostname} ';
    }
    
    if(appname != null) {
      String trimmedAppname = appname.trim();
      app = trimmedAppname == '' ? '' : '${trimmedAppname}';
    }
    
    String sysMsg = '<${priority}>${time}${host}${app}[${pid}]: ${message}';
    if(sysMsg.length > 2048) {
      throw('Message to long');
    }
    _socket.send(sysMsg.codeUnits, _hostname, _port);
  }
  
  void close() {
    _socket.close();
  }
  
  static int _priority(int facility, int severity) => facility * 8 + severity;
}