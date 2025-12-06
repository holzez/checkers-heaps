enum LogLevel {
	Debug;
	Info;
	Warning;
	Error;
}

class Logger {
	private static var levelNames = [Debug => "DEBUG", Info => "INFO", Warning => "WARNING", Error => "ERROR",];

	private static var asciiLevelColors = [
		Debug => '\033[32m',
		Info => '\033[34m',
		Warning => '\033[33m',
		Error => '\033[31m',
	];

	public static function log(message:String, level:LogLevel = Info, ?tag:String) {
		trace('${asciiLevelColors[level]}${Date.now().toString()} [${levelNames[level]}] [${tag ?? 'default'}] $message\033[0m');
	}

	public static function debug(message:String, ?tag:String) {
		log(message, Debug, tag);
	}

	public static function info(message:String, ?tag:String) {
		log(message, Info, tag);
	}

	public static function warning(message:String, ?tag:String) {
		log(message, Warning, tag);
	}

	public static function error(message:String, ?tag:String) {
		log(message, Error, tag);
	}
}
