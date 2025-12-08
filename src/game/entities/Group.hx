package entities;

import kinds.PawnKind;
import minds.GroupMind;
import dn.struct.FixedArray;

class Group extends Entity {
	public var pieces:FixedArray<Piece> = new FixedArray<Piece>(12);

	public final yDirection:Int;

	var myStep = false;

	final mind:GroupMind;

	public function new(cells:Array<Cell>, tile:h2d.Tile, mind:GroupMind, yDirection:Int, onMove:Void->Void) {
		super();

		this.yDirection = yDirection;

		this.mind = mind;
		this.mind.setGroup(this, onMove);

		for (cell in cells) {
			pieces.push(new Piece(cell, tile, this, new PawnKind()));
		}
	}

	public function setMyStep(myStep:Bool) {
		if (this.myStep == myStep) {
			return;
		}

		this.myStep = myStep;

		if (myStep) {
			mind.onMoveStart();
		}
	}

	override function frameUpdate() {
		super.frameUpdate();

		if (myStep) {
			mind.update(this);
		}
	}
}
