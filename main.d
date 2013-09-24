import std.stdio;

import log;

int
main() {

	Log log = new Log();
	log.addLogWriter(new ConsoleLogWriter);
	
	log.emergency("Esto es una emergencia.");
	log.alert("Esto es una alerta.");
	log.critical("Esto es un mensaje crítico.");
	log.error("Esto es un error.");
	log.notice("Esto es algo que hay que tener en cuenta.");
	log.info("Esto es información.");
	log.dbg("Esto es una línea de depuración.");
	log.trace("Esto es una línea de depuración pero a más bajo nivel.");

	return 0;
}
