module log.writer;

import log.logger;

class LogWriter {

	private		bool			fUseParentSeverity	= true;
	private		Logger			fParentLogger		= null;
	
	private void checkParent() {
		if(fParentLogger is null) {
			throw new Exception("Log writer must belong to a Logger.");
		}
	}

	protected	Logger.Severity	fSeverity = Logger.Severity.Warning;
	protected	Logger.Facility	fFacility = Logger.Facility.User;

	protected string severityToString(Logger.Severity severity) {
		switch(severity) {
			case Logger.Severity.Emergency:
				return "emergency";
			case Logger.Severity.Alert:
				return "alert";
			case Logger.Severity.Critical:
				return "critical";
			case Logger.Severity.Error:
				return "error";
			case Logger.Severity.Warning:
				return "warning";
			case Logger.Severity.Notice:
				return "notice";
			case Logger.Severity.Info:
				return "info";
			case Logger.Severity.Debug:
				return "debug";
			case Logger.Severity.Trace:
				return "trace";
			default:
				return "unknown";
		}
	}
	
	protected bool shouldLog(Logger.Record record) {
		// TODO Parametter constness attributes.
		return record.severity() <= (fUseParentSeverity ?  fParentLogger.severity() : fSeverity);
	}
	
	public {
	
		this() {}
	
		this(Logger.Severity severity, Logger.Facility facility = Logger.Facility.User) {
			fSeverity = severity;
			fUseParentSeverity = false;
			fFacility = facility;
		}
		
		~this() {}
		
		void setSeverity(Logger.Severity severity) {
			fSeverity = severity;
			fUseParentSeverity = false;
		}
		
		Logger.Severity severity() {
			return fSeverity;
		}
		
		void setFacility(Logger.Facility facility) {
			fFacility = facility;
		}
		
		Logger.Facility facility() {
			return fFacility;
		}
		
		bool useParentSeverity() {
			return fUseParentSeverity;
		}
		
		void setParentLogger(Logger logger) {
			fParentLogger = logger;
		}
		
		Logger parentLogger() {
			return fParentLogger;
		}
		
		abstract void log(Logger.Record record);
		
	}
		
}
