package minds;

import entities.Piece;
import Types.GameAction;
import dn.heaps.input.ControllerAccess;
import entities.Group;

class PlayerMind extends GroupMind {
	final controllerAccess:ControllerAccess<GameAction>;

	var selectedPiece:Null<Piece>;

	var availableMoves:Array<Move> = [];

	public function new() {
		super();

		controllerAccess = app.controller.createAccess();
	}

	public function preUpdate(group:Group) {
		if (controllerAccess.isPressed(GameAction.Select)) {
			final mouseX = app.globalMouseX;
			final mouseY = app.globalMouseY;
			final cell = board.getCellAt(mouseX, mouseY);

			if (cell == null) {
				return;
			}

			final piece = board.getPieceAt(cell);

			if (selectedPiece == null) {
				if (piece != null && piece.group.uid == group.uid) {
					selectPiece(piece);
					piece.startDrag(mouseX, mouseY);
				}
			} else if (piece != null && piece.group.uid == group.uid) {
				selectPiece(piece);
				piece.startDrag(mouseX, mouseY);
			} else {
				var availableMove = getAvailableMove(cell);
				if (availableMove != null) {
					selectMove(availableMove);
				} else {
					deselectPiece();
				}
			}
		} else if (selectedPiece != null) {
			if (controllerAccess.isKeyboardDown(hxd.Key.MOUSE_LEFT) && selectedPiece.dragging) {
				selectedPiece.drag(app.globalMouseX, app.globalMouseY);
				var cell = board.getCellWithBounds(app.globalMouseX, app.globalMouseY);
				board.selectCell(cell);
				return;
			} else if (selectedPiece.dragging) {
				var cell = board.getCellWithBounds(app.globalMouseX, app.globalMouseY);

				var availableMove = cell != null ? getAvailableMove(cell) : null;
				selectedPiece.stopDrag(availableMove?.to);

				if (availableMove != null) {
					selectMove(availableMove);
				}

				board.selectCell(null);
			}
		}
	}

	public function selectPiece(piece:Piece) {
		selectedPiece = piece;
		board.setActiveCell(piece.cell);
		board.selectCell(piece.cell);

		if (isAllowedPiece(piece)) {
			availableMoves = piece.kind.getAvailableMoves(selectedPiece);
		} else {
			availableMoves = [];
		}

		board.setAvailableCells(availableMoves.map(move -> return move.to));
	}

	public function deselectPiece() {
		selectedPiece?.stopDrag();
		selectedPiece = null;
		availableMoves = [];
		board.setActiveCell(null);
		board.selectCell(null);
		board.setAvailableCells([]);
	}

	private function getAvailableMove(cell:Cell):Null<Move> {
		for (availableMove in availableMoves) {
			if (availableMove.to == cell) {
				return availableMove;
			}
		}

		return null;
	}
}
