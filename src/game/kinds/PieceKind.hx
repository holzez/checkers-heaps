package kinds;

import entities.Piece;

abstract class PieceKind {
	public function new() {}

	public abstract function getTile(isWhite:Bool):h2d.Tile;

	public abstract function getPossibleMoves(piece:Piece):Array<Move>;

	public abstract function getAvailableMoves(piece:Piece):Array<Move>;

	public abstract function getRequiredMoves(piece:Piece):Array<Move>;

	public abstract function canPromote(piece:Piece):Null<PieceKind>;
}
