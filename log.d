module log;

import std.stdio;
import std.format;
import std.array;

class Log {
	public:
	
		enum Facility {
			Kernel,
			User,
			Mail,
			Daemon,
			Auth,
			Syslog,
			LPR,
			News,
			UUCP,
			ClockDaemon,
			AuthPrivate,
			FTP,
			NTP,
			LogAudit,
			LogAlert,
			Cron,
			Local0,
			Local1,
			Local2,
			Local3,
			Local4,
			Local5,
			Local6,
			Local7
		}
		
		enum Severity {
			Emergency,
			Alert,
			Critical,
			Error,
			Warning,
			Notice,
			Info,
			Debug,
			Trace
		}
	
		class Record {
		
			private {
				string		fMessage;
				Severity	fSeverity;
				Facility	fFacility;
			}
			
			public {
			
				this(lazy string message, Severity severity, Facility facility) {
					this.fMessage = message;
					this.fSeverity = severity;
					this.fFacility = facility;
				}
				
				string message() {
					return fMessage;
				}
				
				Severity severity() {
					return fSeverity;
				}
				
				Facility facility() {
					return fFacility;
				}
				
			}
		}
	
	private:
	
		LogWriter[]		fWriters;
		Facility		fFacility = Facility.User;
		
		void doLog(Record record) {
			foreach(writer; fWriters) {
				writer.doLog(record);
			}
		}
		
		void doLog(lazy string message, Severity severity) {
			doLog(new Record(message, severity, this.fFacility));
		}
		
		string buildMessage(Args...)(Args args) {
			auto writer = appender!string();
			formattedWrite(writer, args);
			return writer.data;
		}
		
	public:
		this() {}
		
		~this() {}
		
		void addLogWriter(LogWriter writer) {
			if(writer !is null) {
				fWriters ~= writer;
			}
		}
		
		void setFacility(Facility facility) {
			fFacility = facility;
		}
		
		Facility facility() {
			return fFacility;
		}
		
		void emergency(string)(lazy string message) {
			doLog(message, Severity.Emergency);
		}
		
		void emergency(Args...)(Args args) {
			doLog(buildMessage(args), Severity.Emergency);
		}
		
		alias em = emergency;
		
		void alert(lazy string message) {
			doLog(message, Severity.Alert);
		}
		
		alias a = alert;
		
		void critical(lazy string message) {
			doLog(message, Severity.Critical);
		}
		
		alias c = critical;
		
		void error(lazy string message) {
			doLog(message, Severity.Error);
		}
		
		alias e = error;
		
		void warning(lazy string message) {
			doLog(message, Severity.Warning);
		}
		
		alias w = warning;
		
		void notice(lazy string message) {
			doLog(message, Severity.Notice);
		}
		
		alias n = notice;
		
		void info(lazy string message) {
			doLog(message, Severity.Info);
		}
		
		alias i = info;
		
		void dbg(lazy string message) {
			doLog(message, Severity.Debug);
		}
		
		alias d = dbg;
		
		void trace(lazy string message) {
			doLog(message, Severity.Trace);
		}
		
		alias t = trace;
}

class LogWriter {

	protected string severityToString(Log.Severity severity) {
		switch(severity) {
			case Log.Severity.Emergency:
				return "emergency";
			case Log.Severity.Alert:
				return "alert";
			case Log.Severity.Critical:
				return "critical";
			case Log.Severity.Error:
				return "error";
			case Log.Severity.Warning:
				return "warning";
			case Log.Severity.Notice:
				return "notice";
			case Log.Severity.Info:
				return "info";
			case Log.Severity.Debug:
				return "debug";
			case Log.Severity.Trace:
				return "trace";
			default:
				return "unknown";
		}
	}
	
	public:
	
		this() {}
		
		~this() {}
		
		abstract void doLog(Log.Record record);
		
}

class ConsoleLogWriter : LogWriter {

	private string recordToString(Log.Record record) {
		return "[" ~ severityToString(record.severity()) ~ "] " ~ record.message();
	}
	
	override public void doLog(Log.Record record) {
		recordToString(record).writeln;
	}
	
}
