class Boot extends hxd.App {
	public static var instance:Boot;

	static function main() {
		instance = new Boot();
	}

	override function init() {
		super.init();
		new App(s2d);
	}

	override function update(dt:Float) {
		super.update(dt);

		#if hl
		try {
		#end
			dn.Process.updateAll(dt);
		#if hl
		} catch (err) {
			App.onCrash(err);
		}
		#end
	}
}
