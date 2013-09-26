module log.writers.console;

import log.logger;
import log.writer;

import std.stdio;

class ConsoleLogWriter : LogWriter {

	this() {
		super();
	}

	this(Logger.Severity severity, Logger.Facility facility = Logger.Facility.User) {
		super(severity, facility);
	}

	private string recordToString(Logger.Record record) {
		return "[" ~ severityToString(record.severity()) ~ "] " ~ record.message();
	}
	
	override public void log(Logger.Record record) {
		if(shouldLog(record)) {
			recordToString(record).writeln;
		}
	}
	
}
