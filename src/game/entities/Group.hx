package entities;

import kinds.PawnKind;
import minds.GroupMind;
import dn.struct.FixedArray;

class Group extends Entity {
	public var pieces:FixedArray<Piece> = new FixedArray<Piece>(12);

	public final yDirection:Int;

	public var isWhite:Bool = false;

	var myMove = false;

	final mind:GroupMind;

	public function new(cells:Array<Cell>, isWhite:Bool, mind:GroupMind, yDirection:Int, onMoveSelected:Move->Void) {
		super();

		this.yDirection = yDirection;
		this.isWhite = isWhite;
		this.mind = mind;
		this.mind.setGroup(this, onMoveSelected);

		for (cell in cells) {
			pieces.push(new Piece(cell, this, new PawnKind()));
		}
	}

	public function startMove() {
		this.myMove = true;
		mind.onMoveStart(this);
	}

	public function stopMove() {
		this.myMove = false;
		mind.onMoveEnd(this);
	}

	public function moveSequence(piece:Piece) {
		mind.onMoveSequance(this, piece);
	}

	public override function preUpdate() {
		super.preUpdate();

		if (myMove) {
			mind.preUpdate(this);
		}
	}
}
