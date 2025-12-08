package kinds;

import entities.Piece;

abstract class PieceKind {
	public function new() {}

	public abstract function getAvailableCells(piece:Piece):Array<Cell>;
}
