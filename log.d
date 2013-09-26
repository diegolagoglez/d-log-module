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
	
	private {
	
		LogWriter[]		fWriters;
		
		Severity		fSeverity = Severity.Debug;
		Facility		fFacility = Facility.User;
		
		void writeRecord(Record record) {
			foreach(writer; fWriters) {
				writer.log(record);
			}
		}
		
		void log(lazy string message, Severity severity) {
			writeRecord(new Record(message, severity, this.fFacility));
		}
		
		string buildMessage(Args...)(lazy Args args) {
			auto writer = appender!string();
			formattedWrite(writer, args);
			return writer.data;
		}
		
	}
		
	public {
	
		this(Severity severity, LogWriter writer = null) {
			fSeverity = severity;
			addLogWriter(writer);
		}
		
		~this() {}
		
		void addLogWriter(LogWriter writer) {
			if(writer !is null) {
				fWriters ~= writer;
			}
		}
		
		void setSeverity(Severity severity) {
			fSeverity = severity;
		}
		
		Severity severity() {
			return fSeverity;
		}
		
		void setFacility(Facility facility) {
			fFacility = facility;
		}
		
		Facility facility() {
			return fFacility;
		}
		
		void emergency(string)(lazy string message) {
			log(message, Severity.Emergency);
		}
		
		void emergency(Args...)(Args args) {
			log(buildMessage(args), Severity.Emergency);
		}
		
		alias em = emergency;
		
		void alert(string)(lazy string message) {
			log(message, Severity.Alert);
		}
		
		void alert(Args...)(Args args) {
			log(buildMessage(args), Severity.Alert);
		}
		
		alias a = alert;
		
		void critical(string)(lazy string message) {
			log(message, Severity.Critical);
		}
		
		void critical(Args...)(Args args) {
			log(buildMessage(args), Severity.Critical);
		}
		
		alias c = critical;
		
		void error(string)(lazy string message) {
			log(message, Severity.Error);
		}
		
		void error(Args...)(Args args) {
			log(buildMessage(args), Severity.Error);
		}
		
		alias e = error;
		
		void warning(string)(lazy string message) {
			log(message, Severity.Warning);
		}
		
		void warning(Args...)(Args args) {
			log(buildMessage(args), Severity.Warning);
		}
		
		alias w = warning;
		
		void notice(string)(lazy string message) {
			log(message, Severity.Notice);
		}
		
		void notice(Args...)(Args args) {
			log(buildMessage(args), Severity.Notice);
		}
		
		alias n = notice;
		
		void info(string)(lazy string message) {
			log(message, Severity.Info);
		}
		
		void info(Args...)(Args args) {
			log(buildMessage(args), Severity.Info);
		}
		
		alias i = info;
		
		void dbg(string)(lazy string message) {
			log(message, Severity.Debug);
		}
		
		void dbg(Args...)(Args args) {
			log(buildMessage(args), Severity.Debug);
		}
		
		alias d = dbg;
		
		void trace(string)(lazy string message) {
			log(message, Severity.Trace);
		}
		
		void trace(Args...)(lazy Args args) {
			log(buildMessage(args), Severity.Trace);
		}
		
		alias t = trace;
	}
}

class LogWriter {

	protected Log.Severity	fSeverity = Log.Severity.Debug;
	protected Log.Facility	fFacility = Log.Facility.User;

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
	
	protected bool shouldLog(Log.Record record) {
		// TODO Parametter constness attributes.
		return record.severity >= fSeverity;
	}
	
	public {
	
		this(Log.Severity severity, Log.Facility facility = Log.Facility.User) {
			fSeverity = severity;
			fFacility = facility;
		}
		
		~this() {}
		
		void setSeverity(Severity severity) {
			fSeverity = severity;
		}
		
		Severity severity() {
			return fSeverity;
		}
		
		void setFacility(Facility facility) {
			fFacility = facility;
		}
		
		Facility facility() {
			return fFacility;
		}
		
		abstract void log(Log.Record record);
		
	}
		
}

class ConsoleLogWriter : LogWriter {

	private string recordToString(Log.Record record) {
		return "[" ~ severityToString(record.severity()) ~ "] " ~ record.message();
	}
	
	override public void log(Log.Record record) {
		if(shouldLog(record)) {
			recordToString(record).writeln;
		}
	}
	
}
