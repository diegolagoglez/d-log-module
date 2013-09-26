# D programming language module for logging facilities

## Introduction

This is a module developed with the D programming language to allow logging facilities to applications.

This module is modular and you can develop log writers in order to write logging records to diferent sites, such as console, file, database, syslog, etc.

You can add more than one log writer to the logger to log records to several sites simultaneously.

## Compiling

In order to compile the module (as an static object file), you can do the next steps:

```bash
user@host:~:$ cd Projects/d-log-module/log
user@host:~/Projects/d-log-module/log:$ dmd -c logger.d writer.d writers/console.d -ofdlogmodule.o
```

## Use in your application

In order to use this module in your application, you have to compile your application with the module object file indicating module path. 

```bash
user@host:~/Projects/d-log-module-test:$ dmd -I../d-log-module my_test.d ../d-log-module/log/dlogmodule.o
```

## Examples

```d
import log.logger;
import log.writers.console;

int
main() {
  Logger log = new Logger(Logger.Severity.Warning);
  log.addLogWriter(new ConsoleLogWriter());
  
  log.e("This is an error.");
  log.w("This is a warning.");
  log.d("This is a debug string."); // Not shown due to set severity in Logger constructor.
  
  return 0;
}

```
