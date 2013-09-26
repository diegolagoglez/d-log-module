import std.stdio;

import log.logger;

int
main() {

	Logger log = new Logger(Logger.Severity.Trace);
	log.addLogWriter(new ConsoleLogWriter());
	
	foreach(severity; 0..9) {
		(cast(Logger.Severity)severity).writeln;
		log.setSeverity(cast(Logger.Severity)severity);
		log.emergency("Esto es una emergencia.");
		log.emergency("Esto es una emergencia con nombre: %s", "Juanito");
		log.em("Emergencia con método abreviado.");
		log.alert("Esto es una alerta.");
		log.a("Alerta con método abreviado.");
		log.critical("Esto es un mensaje crítico.");
		log.c("Error crítico con método abreviado.");
		log.error("Esto es un error.");
		log.e("Error con método abreviado.");
		log.warning("Esto es un Warning.");
		log.w("Warning con método abreviado.");
		log.notice("Esto es algo que hay que tener en cuenta.");
		log.n("Notice con método abreviado.");
		log.info("Esto es información.");
		log.i("Información con método abreviado.");
		log.dbg("Esto es una línea de depuración.");
		log.d("Depuración con método abreviado.");
		log.trace("Esto es una línea de depuración pero a más bajo nivel.");
		log.t("Trace con método abreviado.");
		log.t("Trace con valores: %d, %d", 42, 69);
		log.t("Con array: [%(%d, %)]", [1, 2, 3]);
		"----------------------------------------------".writeln;
	}

	return 0;
}
