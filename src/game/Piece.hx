import dn.struct.FixedArray;
import dn.heaps.slib.HSprite;

class Piece {
	public static var all:FixedArray<Piece> = new FixedArray(256);

	public var app(get, never):App;

	inline function get_app()
		return App.instance;

	public var game(get, never):Game;

	inline function get_game()
		return Game.instance;

	public var board(get, never):Board;

	inline function get_board()
		return game.board;

	public var uid:Int;
	public var cellX = 0;
	public var cellY = 0;
	public var offsetX = 0.0;
	public var offsetY = 0.0;
	public var size:Int;
	public var spr:HSprite;

	public function new(cellX:Int, cellY:Int) {
		uid = Const.makeUniqueId();
		all.push(this);
		this.cellX = cellX;
		this.cellY = cellY;
		size = Std.int(Const.BOARD_BASE_SIZE * Const.SCALE);
		var tile = h2d.Tile.fromColor(0x5c5957, size, size);
		spr = HSprite.fromTile(tile);
		spr.setPosition(cellX * board.cellSize, cellY * board.cellSize);
		game.gameplayLayer.add(spr, Const.DP_MAIN);
	}
}
