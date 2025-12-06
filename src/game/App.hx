import hxd.res.DefaultFont;
import ui.Console;

class App extends dn.Process {
	public static var instance:App;

	public var scene(default, null):h2d.Scene;

	public var globalMouseX(get, null):Float;

	inline function get_globalMouseX()
		return scene.mouseX;

	public var globalMouseY(get, null):Float;

	inline function get_globalMouseY()
		return scene.mouseY;

	public function new(s:h2d.Scene) {
		super();
		instance = this;

		scene = s;
		createRoot(scene);

		new Console(DefaultFont.get(), scene);

		initEngine();

		startGame();
	}

	#if hl
	public static function onCrash(err:Dynamic) {
		#if debug
		Logger.error('${Std.string(err)}\n${haxe.CallStack.toString(haxe.CallStack.exceptionStack())}');
		hxd.System.exit();
		#else
		var title = "Fatal error";
		var msg = Std.string(err);
		var flags:haxe.EnumFlags<hl.UI.DialogFlags> = new haxe.EnumFlags();
		flags.set(IsError);

		var log = [Std.string(err)];
		try {
			log.push("BUILD: " + Const.BUILD_INFO);
			log.push("EXCEPTION:");
			log.push(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));

			log.push("CALL:");
			log.push(haxe.CallStack.toString(haxe.CallStack.callStack()));

			sys.io.File.saveContent("crash.log", log.join("\n"));
			hl.UI.dialog(title, msg, flags);
		} catch (_) {
			sys.io.File.saveContent("crash2.log", log.join("\n"));
			hl.UI.dialog(title, msg, flags);
		}

		hxd.System.exit();
		#end
	}
	#end

	public function startGame() {
		if (Game.exists()) {
			Game.instance.destroy();
			dn.Process.updateAll(1);
			createGameInstance();
			hxd.Timer.skip();
		} else {
			delayer.nextFrame(() -> {
				createGameInstance();
				hxd.Timer.skip();
			});
		}
	}

	private function initEngine() {
		engine.backgroundColor = 0xff << 24 | 0x111133;

		#if (hl && !debug)
		engine.fullScreen = true;
		#end

		#if (hl && debug)
		hxd.Res.initLocal();
		hxd.res.Resource.LIVE_UPDATE = true;
		#else
		hxd.Res.initEmbed();
		#end

		hxd.snd.Manager.get();
		hxd.Timer.skip();

		hxd.Timer.smoothFactor = 0.4;
		hxd.Timer.wantedFPS = Const.FPS;
		dn.Process.FIXED_UPDATE_FPS = Const.FIXED_UPDATE_RATE;
	}

	private function createGameInstance() {
		return new Game();
	}
}
