import Types.ScreenPosition;
import entities.Piece;
import dn.struct.FixedArray;
import h2d.TileGroup;
import h2d.SpriteBatch;

class Board extends utils.GameChildProcess {
	public var pieces(default, null):FixedArray<Piece> = new FixedArray<Piece>(128);

	public var cellSize:Int;

	private var invalidated = true;

	private var selectedCell:Null<Cell>;

	private var selectedTile:h2d.Tile;

	private var availableTile:h2d.Tile;

	private var availableCells:Array<Cell> = [];

	public function new() {
		super();

		createRootInLayers(game.gameplayLayer, Const.DP_BG);

		selectedTile = hxd.Res.load('sprites/selected-cell.png').toTile();
		availableTile = hxd.Res.load('sprites/available-cell.png').toTile();

		onResize();
	}

	public function getCellScreenPosition(cell:Cell):ScreenPosition {
		return {x: cell.x * cellSize, y: cell.y * cellSize};
	}

	public function getCellAt(mx:Float, my:Float):Null<Cell> {
		final x = Std.int(mx / cellSize);
		final y = Std.int(my / cellSize);

		if (x >= 0 && x < 8 && y >= 0 && y < 8) {
			return new Cell(x, y);
		}

		return null;
	}

	public function getPieceAt(cell:Cell):Null<Piece> {
		for (piece in pieces) {
			if (!piece.destroyed && piece.cell == cell) {
				return piece;
			}
		}
		return null;
	}

	public function selectCell(cell:Null<Cell>) {
		if (cell == null) {
			if (selectedCell != null) {
				selectedCell = null;
				invalidate();
			}
		} else {
			if (selectedCell != cell) {
				Logger.debug('Selected cell dont match: ${selectedCell} != ${cell}');
				selectedCell = cell.clone();
				invalidate();
			}
		}
	}

	public function setAvailableCells(cells:Array<Cell>) {
		availableCells = cells;
		invalidate();
	}

	public function invalidate() {
		invalidated = true;
	}

	override function update() {}

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
		selectedTile.scaleToSize(cellSize, cellSize);
		availableTile.scaleToSize(cellSize, cellSize);
	}

	private function render() {
		root.removeChildren();

		var group = new TileGroup();
		var whiteTile = h2d.Tile.fromColor(0xebecd0, cellSize, cellSize);
		var blackTile = h2d.Tile.fromColor(0x739552, cellSize, cellSize);

		for (y in 0...8) {
			for (x in 0...8) {
				final cell = new Cell(x, y);
				var tile = (cell.isWhite() ? whiteTile : blackTile);
				group.add(cell.x * cellSize, cell.y * cellSize, tile);
			}
		}

		if (selectedCell != null) {
			group.add(selectedCell.x * cellSize, selectedCell.y * cellSize, selectedTile);
		}

		for (cell in availableCells) {
			group.add(cell.x * cellSize, cell.y * cellSize, availableTile);
		}

		root.add(group);
	}
}
