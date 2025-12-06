class Game extends utils.AppChildProcess {
	public static var instance:Game;

	public var board:Board;

	public var gameplayLayer:h2d.Layers;

	public function new() {
		super();
		instance = this;

		createRootInLayers(App.instance.root, Const.DP_BG);

		gameplayLayer = new h2d.Layers();
		root.add(gameplayLayer, Const.DP_BG);

		createBoard();

		new Piece(0, 0);
		new Piece(7, 5);
	}

	public static function exists() {
		return instance != null && !instance.destroyed;
	}

	override function onDispose() {
		super.onDispose();

		if (instance == this) {
			instance = null;
		}
	}

	private function createBoard() {
		if (board != null) {
			board.destroy();
		}

		board = new Board();
	}
}
