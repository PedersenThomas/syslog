library syslog;

import 'dart:async';
import 'dart:io';

part 'src/syslog.dart';

/**
 * Connects to a syslog, over UDP.
 */
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
   * Closes the socket to the syslog server.
   */
  void close();
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