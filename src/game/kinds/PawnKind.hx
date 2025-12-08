package kinds;

import entities.Piece;

class PawnKind extends PieceKind {
	public function new() {
		super();
	}

	public function getAvailableCells(piece:Piece):Array<Cell> {
		final cells:Array<Cell> = [];

		final xDeltas = [-1, 1];
		final yDeltas = [-1, 1];

		for (xDelta in xDeltas) {
			for (yDelta in yDeltas) {
				final nextCell = new Cell(piece.cell.x + xDelta, piece.cell.y + yDelta);

				if (!nextCell.isValid()) {
					continue;
				}

				final conflictPiece = piece.board.getPieceAt(nextCell);

				if (conflictPiece != null && conflictPiece.group.uid != piece.group.uid) {
					final nextCell2 = new Cell(nextCell.x + xDelta, nextCell.y + yDelta);

					if (nextCell2.isValid() && piece.board.getPieceAt(nextCell2) == null) {
						cells.push(nextCell2);
					}
				} else if (conflictPiece == null && yDelta == piece.group.yDirection) {
					cells.push(nextCell);
				}
			}
		}

		return cells;
	}
}
