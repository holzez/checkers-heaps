import hxd.Window;

class Game extends utils.AppChildProcess {
	public static var instance:Game;

	public var board:Board;

	public var gameplayLayer:h2d.Layers;

	public var pieceLayer:h2d.Layers;

	public var pieceSelectedLayer:h2d.Layers;

	public var gameFlow:GameFlow;

	private var bgBitmap:h2d.Bitmap;

	public function new() {
		super();
		instance = this;

		createRootInLayers(App.instance.root, Const.DP_BG);

		gameplayLayer = new h2d.Layers();
		pieceLayer = new h2d.Layers();
		pieceSelectedLayer = new h2d.Layers();

		var bgTile = h2d.Tile.fromColor(0x7ebf7b, 1, 1);
		bgBitmap = new h2d.Bitmap(bgTile);
		bgBitmap.width = app.scene.width;
		bgBitmap.height = app.scene.height;
		app.scene.add(bgBitmap, Const.DP_BG);

		root.add(gameplayLayer, Const.DP_BG);
		root.add(pieceLayer, Const.DP_MAIN);
		root.add(pieceSelectedLayer, Const.DP_FRONT);

		createBoard();
		createGameFlow();

		final win = Window.getInstance();
		Logger.debug('scene width: ${app.scene.width}, scene height: ${app.scene.height}');
		Logger.debug('window width: ${win.width}, window height: ${win.height}');
	}

	override function onResize() {
		super.onResize();

		final win = Window.getInstance();
		Logger.debug('scene width: ${app.scene.width}, scene height: ${app.scene.height}');
		Logger.debug('window width: ${win.width}, window height: ${win.height}');
	}

	public static function exists() {
		return instance != null && !instance.destroyed;
	}

	override function onDispose() {
		super.onDispose();

		board.destroy();
		gameFlow.destroy();

		for (entity in Entity.all) {
			entity.destroy();
		}

		garbageCollectEntities();

		if (instance == this) {
			instance = null;
		}
	}

	override function preUpdate() {
		super.preUpdate();

		for (entity in Entity.all) {
			if (!entity.destroyed) {
				entity.preUpdate();
			}
		}
	}

	override function postUpdate() {
		super.postUpdate();

		for (entity in Entity.all) {
			if (!entity.destroyed) {
				entity.postUpdate();
			}
		}

		for (entity in Entity.all) {
			if (!entity.destroyed) {
				entity.finalUpdate();
			}
		}

		garbageCollectEntities();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		for (entity in Entity.all) {
			if (!entity.destroyed) {
				entity.fixedUpdate();
			}
		}
	}

	override function update() {
		super.update();

		for (entity in Entity.all) {
			if (!entity.destroyed) {
				entity.frameUpdate();
			}
		}
	}

	public function garbageCollectEntities() {
		if (Entity.garbage == null || Entity.garbage.allocated == 0) {
			return;
		}

		for (entity in Entity.garbage) {
			entity.dispose();
		}

		Entity.garbage.empty();
	}

	private function createBoard() {
		if (board != null) {
			board.destroy();
		}

		board = new Board();
	}

	private function createGameFlow() {
		if (gameFlow != null) {
			gameFlow.destroy();
		}

		gameFlow = new GameFlow();
	}
}
