module log.logger;

import std.stdio;
import std.format;
import std.array;

import log.writer;

class Logger {

	public {
	
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
		
	}
	
	private {
	
		bool			fEnabled = true;
	
		LogWriter[]		fWriters;
		
		Severity		fSeverity = Severity.Debug;
		Facility		fFacility = Facility.User;
		
		// TODO Parametter constness attributes.
		bool shouldLog(Severity recordSeverity, LogWriter writer) {
			return !writer.useParentSeverity() || recordSeverity <= fSeverity;
		}
		
		void log(lazy string message, Severity severity) {
			if(fEnabled) {
				foreach(writer; fWriters) {
					if(writer.enabled) {
						if(shouldLog(severity, writer)) {
							writer.log(new Record(message, severity, fFacility));
						}
					}
				}
			}
		}
		
		string buildMessage(Args...)(lazy Args args) {
			auto writer = appender!string();
			formattedWrite(writer, args);
			return writer.data;
		}
		
	}
		
	public {
	
		this() {}
	
		this(Severity severity, LogWriter writer = null) {
			fSeverity = severity;
			addLogWriter(writer);
		}
		
		~this() {}
		
		@property
		bool enabled() {
			return fEnabled;
		}
		
		@property
		void enabled(bool enable) {
			fEnabled = enable;
		}
		
		void addLogWriter(LogWriter writer) {
			if(writer !is null) {
				writer.setParentLogger(this);
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
