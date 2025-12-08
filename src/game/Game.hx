class Game extends utils.AppChildProcess {
	public static var instance:Game;

	public var board:Board;

	public var gameplayLayer:h2d.Layers;

	public var gameFlow:GameFlow;

	public function new() {
		super();
		instance = this;

		createRootInLayers(App.instance.root, Const.DP_BG);

		gameplayLayer = new h2d.Layers();
		root.add(gameplayLayer, Const.DP_BG);

		createBoard();

		gameFlow = new GameFlow();

		final a = new Cell(0, 0);
		final b = new Cell(0, 0);
		final same = a == b;
		Logger.debug('same: ${same}, a: ${a}, b: ${b}');
	}

	public static function exists() {
		return instance != null && !instance.destroyed;
	}

	override function onDispose() {
		super.onDispose();

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
		if (Entity.garbage != null || Entity.garbage.allocated == 0) {
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
}
