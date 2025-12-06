import dn.MacroTools;
import hxd.System;

class Const {
	//
	private static var nextUniqueId = 0;

	public static inline function makeUniqueId()
		return nextUniqueId++;

	public static var BUILD_INFO(get, never):String;

	static inline function get_BUILD_INFO()
		return MacroTools.getBuildInfo();

	//
	public static var FPS(get, never):Int;

	static inline function get_FPS()
		return Std.int(System.getDefaultFrameRate());

	public static final FIXED_UPDATE_RATE = 30;

	//
	public static var SCALE(get, never):Float;

	static inline function get_SCALE()
		return dn.heaps.Scaler.bestFit_f(1280, 720);

	//
	public static var UI_SCALE(get, never):Float;

	static inline function get_UI_SCALE()
		return dn.heaps.Scaler.bestFit_f(1280, 720);

	// Depth priority
	static var _inc = 0;
	public static var DP_BG = _inc++;
	public static var DP_FX_BG = _inc++;
	public static var DP_MAIN = _inc++;
	public static var DP_FRONT = _inc++;
	public static var DP_FX_FRONT = _inc++;
	public static var DP_TOP = _inc++;
	public static var DP_UI = _inc++;

	// UI consts
	public static final BOARD_BASE_SIZE = 90;
}
