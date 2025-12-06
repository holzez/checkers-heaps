import h2d.TileGroup;
import h2d.SpriteBatch;

class Board extends utils.GameChildProcess {
	public var cellSize:Int;

	private var invalidated = true;

	private var highlightedCell:Null<Int>;

	private var highlightedCellColor:Int = 0xf9c332;

	public function new() {
		super();

		createRootInLayers(game.gameplayLayer, Const.DP_BG);

		onResize();
	}

	public function getCellAt(mx:Float, my:Float):Null<Int> {
		final x = Std.int(mx / cellSize);
		final y = Std.int(my / cellSize);

		if (x >= 0 && x < 8 && y >= 0 && y < 8) {
			return x + y * 8;
		}

		return null;
	}

	public function highlightCell(cell:Null<Int>, ?color:Int) {
		if (cell == null) {
			if (highlightedCell != null) {
				highlightedCell = null;
				invalidate();
			}
		} else {
			if (highlightedCell != cell || (color != null && highlightedCellColor != color)) {
				highlightedCell = cell;
				highlightedCellColor = color ?? highlightedCellColor;
				invalidate();
			}
		}
	}

	public function invalidate() {
		invalidated = true;
	}

	override function update() {
		final mx = App.instance.globalMouseX;
		final my = App.instance.globalMouseY;
		highlightCell(getCellAt(mx, my));
	}

	override function postUpdate() {
		super.postUpdate();

		if (invalidated) {
			invalidated = false;
			render();
		}
	}

	override function onResize() {
		super.onResize();
		cellSize = Std.int(Const.BOARD_BASE_SIZE * Const.SCALE);
	}

	private function render() {
		root.removeChildren();

		var group = new TileGroup();
		var whiteTile = h2d.Tile.fromColor(0xebecd0, cellSize, cellSize);
		var blackTile = h2d.Tile.fromColor(0x739552, cellSize, cellSize);
		var highlightedTile = h2d.Tile.fromColor(highlightedCellColor, cellSize, cellSize);

		for (y in 0...8) {
			for (x in 0...8) {
				var tile = highlightedCell == x + y * 8 ? highlightedTile : ((x + y) % 2 == 0 ? whiteTile : blackTile);
				group.add(x * cellSize, y * cellSize, tile);
			}
		}

		root.add(group);
	}
}
