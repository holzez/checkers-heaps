package entities;

import h2d.Tile;
import hxd.Math;
import kinds.PieceKind;
import dn.heaps.slib.HSprite;

class MoveTimer {
	public var frames:Int = 0;

	public var currentFrame = 0;

	public var active = false;

	public function new() {
		this.active = false;
	}

	public function update():Bool {
		if (!active) {
			return false;
		}

		currentFrame++;

		if (currentFrame >= frames) {
			active = false;
			return false;
		}

		return true;
	}

	public function progress():Float {
		if (frames == 0 || !active) {
			return 1;
		}

		return currentFrame / frames;
	}

	public function reset(frames:Int) {
		this.frames = frames;
		this.currentFrame = 0;
		this.active = true;
	}

	public function stop() {
		this.active = false;
		this.currentFrame = 0;
	}
}

class Piece extends Entity {
	public var cell:Cell;
	public var offsetX = 0.0;
	public var offsetY = 0.0;
	public var size:Int;

	public var moveTimer = new MoveTimer();
	public var moveTargetX = 0.0;
	public var moveTargetY = 0.0;
	public var moveFromX = 0.0;
	public var moveFromY = 0.0;

	public var dragging = false;
	public var dragWait = false;
	public var dragStartX = 0.0;
	public var dragStartY = 0.0;

	public var group(default, null):Group;
	public var kind(default, null):PieceKind;

	private var isForward = false;
	private var fwSpr:HSprite;
	private var bkSpr:HSprite;

	private var sprX:Float;
	private var sprY:Float;

	public function new(cell:Cell, group:Group, kind:PieceKind) {
		super();

		board.pieces.push(this);

		this.group = group;
		this.cell = cell.clone();
		size = Std.int(Const.BOARD_BASE_SIZE * Const.SCALE);

		bkSpr = new HSprite(game.pieceLayer);
		fwSpr = new HSprite(game.pieceSelectedLayer);
		game.gameplayLayer.add(bkSpr, Const.DP_MAIN);
		game.gameplayLayer.add(fwSpr, Const.DP_FRONT);

		changeKind(kind);

		isForward = false;
		var pos = board.getCellScreenPosition(cell);
		sprX = pos.x;
		sprY = pos.y;
	}

	public function changeKind(kind:PieceKind) {
		this.kind = kind;
		final tile = kind.getTile(group.isWhite);
		tile.scaleToSize(size, size);
		bkSpr.useCustomTile(tile);
		fwSpr.useCustomTile(tile);
	}

	public function moveTo(nextCell:Cell, animate:Bool = true) {
		cell = nextCell.clone();
		final pos = board.getCellScreenPosition(cell);

		if (animate && (pos.x != sprX || pos.y != sprY)) {
			moveTimer.reset(Std.int(Const.FIXED_UPDATE_FPS / 2));
			moveFromX = sprX;
			moveFromY = sprY;
			moveTargetX = pos.x;
			moveTargetY = pos.y;
		} else {
			moveTimer.stop();
			sprX = pos.x;
			sprY = pos.y;
		}
	}

	public inline function isOpponent(other:Piece):Bool {
		return group.uid != other.group.uid;
	}

	public inline function isAlly(other:Piece):Bool {
		return group.uid == other.group.uid;
	}

	public function startDrag(x:Float, y:Float) {
		if (!dragging) {
			moveTimer.stop();
			dragging = true;
			isForward = true;

			dragWait = true;
			dragStartX = x;
			dragStartY = y;
		}
	}

	public function drag(x:Float, y:Float) {
		final dragThreshold = 10;
		if (dragWait && (Math.abs(x - dragStartX) < dragThreshold || Math.abs(y - dragStartY) < dragThreshold)) {
			return;
		}

		dragWait = false;

		if (dragging) {
			sprX = x - size / 2;
			sprY = y - size / 2;
		}
	}

	public function stopDrag(?toCell:Cell) {
		if (dragging) {
			dragging = false;
			moveTo(toCell ?? cell, false);
			isForward = false;
		}
	}

	override function fixedUpdate() {
		super.fixedUpdate();
	}

	override function frameUpdate() {
		super.frameUpdate();

		if (moveTimer.active) {
			if (moveTimer.update()) {
				isForward = true;
				final progress = moveTimer.progress();
				sprX = dn.M.lerp(moveFromX, moveTargetX, progress);
				sprY = dn.M.lerp(moveFromY, moveTargetY, progress);
			} else {
				isForward = false;
				sprX = moveTargetX;
				sprY = moveTargetY;
			}
		}

		fwSpr.x = sprX;
		fwSpr.y = sprY;
		fwSpr.visible = isForward;

		bkSpr.x = sprX;
		bkSpr.y = sprY;
		bkSpr.visible = !isForward;
	}

	override function preUpdate() {
		super.preUpdate();
	}

	override function dispose() {
		super.dispose();
		board.pieces.remove(this);

		Logger.debug('Piece disposed: ${cell}');

		fwSpr.remove();
		bkSpr.remove();
		fwSpr = null;
		bkSpr = null;
	}
}
