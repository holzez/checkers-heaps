package utils;

import dn.struct.FixedArray;

class AppChildProcess extends dn.Process {
	public static var all:FixedArray<AppChildProcess> = new FixedArray(256);

	public var app(get, never):App;

	inline function get_app()
		return App.instance;

	public function new() {
		super(App.instance);
		all.push(this);
	}

	override function onDispose() {
		super.onDispose();
		all.remove(this);
	}
}
