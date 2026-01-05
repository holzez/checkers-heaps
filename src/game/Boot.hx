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

		var adjustedTmod = hxd.Timer.tmod;

		#if hl
		try {
		#end
			dn.Process.updateAll(adjustedTmod);
		#if hl
		} catch (err) {
			App.onCrash(err);
		}
		#end
	}
}
