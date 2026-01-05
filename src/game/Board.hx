import Types.ScreenPosition;
import entities.Piece;
import dn.struct.FixedArray;
import h2d.TileGroup;
import h2d.SpriteBatch;

class Board extends utils.GameChildProcess {
	public var pieces(default, null):FixedArray<Piece> = new FixedArray<Piece>(128);

	public var cellSize:Int;

	private var blackTile:h2d.Tile;

	private var invalidated = true;

	private var activeCell:Null<Cell>;

	private var activeTile:h2d.Tile;

	private var selectedCell:Null<Cell>;

	private var selectedTile:h2d.Tile;

	private var availableTile:h2d.Tile;

	private var availableCells:Array<Cell> = [];

	public function new() {
		super();

		createRootInLayers(game.gameplayLayer, Const.DP_BG);

		blackTile = hxd.Res.load('sprites/black-cell.png').toTile();
		selectedTile = hxd.Res.load('sprites/select-target.png').toTile();
		activeTile = hxd.Res.load('sprites/active-cell.png').toTile();
		availableTile = hxd.Res.load('sprites/available-target.png').toTile();

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

	public function getCellWithBounds(mx:Float, my:Float, boundPercent:Float = 0.1):Null<Cell> {
		final x = Std.int(mx / cellSize);
		final y = Std.int(my / cellSize);

		final startX = x * cellSize + cellSize * boundPercent;
		final startY = y * cellSize + cellSize * boundPercent;
		final endX = (x + 1) * cellSize - cellSize * boundPercent;
		final endY = (y + 1) * cellSize - cellSize * boundPercent;

		if (mx < startX || mx > endX || my < startY || my > endY) {
			return null;
		}

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

	public function setActiveCell(cell:Null<Cell>) {
		if (cell == null) {
			if (activeCell != null) {
				activeCell = null;
				invalidate();
			}
		} else {
			if (activeCell != cell) {
				activeCell = cell.clone();
				invalidate();
			}
		}
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

		blackTile.scaleToSize(cellSize, cellSize);
		selectedTile.scaleToSize(cellSize, cellSize);
		activeTile.scaleToSize(cellSize, cellSize);
		availableTile.scaleToSize(cellSize, cellSize);
	}

	private function render() {
		root.removeChildren();

		var group = new TileGroup();

		for (y in 0...8) {
			for (x in 0...8) {
				final cell = new Cell(x, y);

				if (!cell.isWhite() || (activeCell != null && activeCell == cell)) {
					var tile = activeCell != null && activeCell == cell ? activeTile : blackTile;
					renderCell(group, cell, tile);
				}
			}
		}

		if (selectedCell != null && !(activeCell != null && activeCell == selectedCell)) {
			renderCell(group, selectedCell, selectedTile);
		}

		for (cell in availableCells) {
			if (selectedCell != null && selectedCell == cell) {
				continue;
			}

			renderCell(group, cell, availableTile);
		}

		root.add(group);
	}

	private function renderCell(group:TileGroup, cell:Cell, tile:h2d.Tile) {
		group.add(cell.x * cellSize, cell.y * cellSize, tile);
	}
}
