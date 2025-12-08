package entities;

import kinds.PieceKind;
import dn.heaps.slib.HSprite;

class Piece extends Entity {
	public var cell:Cell;
	public var nextCell:Null<Cell>;
	public var prevCell:Null<Cell>;
	public var offsetX = 0.0;
	public var offsetY = 0.0;
	public var size:Int;
	public var spr:HSprite;

	public var group(default, null):Group;
	public var kind(default, null):PieceKind;

	public function new(cell:Cell, tile:h2d.Tile, group:Group, kind:PieceKind) {
		super();

		board.pieces.push(this);

		this.group = group;
		this.kind = kind;
		this.cell = cell.clone();
		size = Std.int(Const.BOARD_BASE_SIZE * Const.SCALE);
		tile.scaleToSize(size, size);
		spr = HSprite.fromTile(tile);
		spr.setPosition(cell.x * board.cellSize, cell.y * board.cellSize);
		game.gameplayLayer.add(spr, Const.DP_MAIN);
	}

	public function moveTo(cell:Cell) {
		nextCell = cell.clone();
		prevCell = this.cell.clone();
	}

	override function frameUpdate() {
		super.frameUpdate();

		if (nextCell != null) {
			var curPos = board.getCellScreenPosition(cell);
			var nextPos = board.getCellScreenPosition(nextCell);

			final distanceX = nextPos.x - (curPos.x + offsetX);
			final distanceY = nextPos.y - (curPos.y + offsetY);
			final dirX = distanceX < 0 ? -1 : 1;
			final dirY = distanceY < 0 ? -1 : 1;
			final speed = Math.max(Math.min(1000, Math.max(Math.abs(distanceX), Math.abs(distanceY))), 100);

			final nextOffsetX = offsetX + dirX * tmod * speed;
			final nextOffsetY = offsetY + dirY * tmod * speed;

			final deltaCellX = Std.int(nextOffsetX / board.cellSize);
			final deltaCellY = Std.int(nextOffsetY / board.cellSize);

			final afterCellX = deltaCellX + cell.x;
			final afterCellY = deltaCellY + cell.y;
			offsetX = nextOffsetX - deltaCellX * board.cellSize;
			offsetY = nextOffsetY - deltaCellY * board.cellSize;

			Logger.debug('nextOffsetX: ${nextOffsetX}, nextOffsetY: ${nextOffsetY}, deltaCellX: ${deltaCellX}, deltaCellY: ${deltaCellY}, afterCellX: ${afterCellX}, afterCellY: ${afterCellY}, offsetX: ${offsetX}, offsetY: ${offsetY}');

			cell = new Cell(afterCellX, afterCellY);

			final epsilon = 1;

			if (cell == nextCell && Math.abs(offsetX) < epsilon && Math.abs(offsetY) < epsilon) {
				offsetX = 0.0;
				offsetY = 0.0;
				this.cell = nextCell;
				nextCell = null;
				return;
			}

			final afterScreenPos = board.getCellScreenPosition(cell);
			spr.setPosition(afterScreenPos.x + offsetX, afterScreenPos.y + offsetY);
		}
	}

	override function preUpdate() {
		super.preUpdate();
	}

	override function dispose() {
		board.pieces.remove(this);
		super.dispose();
	}
}
