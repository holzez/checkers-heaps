package kinds;

import entities.Piece;

class KingKind extends PieceKind {
	public function new() {
		super();
	}

	public function getTile(isWhite:Bool):h2d.Tile {
		final whitePieceTile = hxd.Res.load('sprites/white-king.png').toTile();
		final blackPieceTile = hxd.Res.load('sprites/black-king.png').toTile();
		return isWhite ? whitePieceTile : blackPieceTile;
	}

	public function getPossibleMoves(piece:Piece):Array<Move> {
		final moves:Array<Move> = [];

		final xDeltas = [-1, 1];
		final yDeltas = [-1, 1];

		for (xDelta in xDeltas) {
			for (yDelta in yDeltas) {
				var nextCell:Cell = piece.cell.clone();
				var capture:Null<Piece> = null;
				var stopIteration = false;

				do {
					nextCell = new Cell(nextCell.x + xDelta, nextCell.y + yDelta);

					if (!nextCell.isValid()) {
						break;
					}

					final conflictPiece = piece.board.getPieceAt(nextCell);

					if (conflictPiece == null) {
						moves.push({
							piece: piece,
							from: piece.cell.clone(),
							to: nextCell.clone(),
							capture: capture,
						});
					} else {
						final isOpponent = piece.isOpponent(conflictPiece);
						if (!isOpponent || capture != null) {
							stopIteration = true;
						} else {
							capture = conflictPiece;
						}
					}
				} while (!stopIteration);
			}
		}

		return moves;
	}

	public function getRequiredMoves(piece:Piece):Array<Move> {
		final moves:Array<Move> = [];

		var availableMoves = getPossibleMoves(piece);
		for (move in availableMoves) {
			if (move.capture != null) {
				moves.push(move);
			}
		}

		return moves;
	}

	public function getAvailableMoves(piece:Piece):Array<Move> {
		var possibleMoves = getPossibleMoves(piece);
		var requiredMoves = getRequiredMoves(piece);

		return requiredMoves.length > 0 ? requiredMoves : possibleMoves;
	}

	public function canPromote(piece:Piece):Null<PieceKind> {
		return null;
	}
}
