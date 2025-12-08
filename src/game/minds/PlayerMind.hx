package minds;

import entities.Piece;
import Types.GameAction;
import dn.heaps.input.ControllerAccess;
import entities.Group;

class PlayerMind extends GroupMind {
	final controllerAccess:ControllerAccess<GameAction>;

	var selectedPiece:Null<Piece>;

	var availableCells:Array<Cell> = [];

	public function new() {
		super();

		controllerAccess = app.controller.createAccess();
	}

	override function update(group:Group) {
		super.update(group);

		if (controllerAccess.isPressed(GameAction.Select)) {
			if (selectedPiece == null) {
				processPieceSelection(group);
			} else {
				processCellSelection(group);
			}
		}
	}

	private function processPieceSelection(group:Group) {
		final cell = board.getCellAt(app.globalMouseX, app.globalMouseY);
		Logger.debug('Piece selection: ${cell}');
		selectPiece(group, cell);
	}

	private function processCellSelection(group:Group) {
		final cell = board.getCellAt(app.globalMouseX, app.globalMouseY);
		Logger.debug('Cell selection: ${cell}');

		for (availableCell in availableCells) {
			Logger.debug('Available cell: ${availableCell}');
			if (cell == availableCell) {
				Logger.debug('move cell: ${selectedPiece.cell} to ${cell}');
				selectedPiece.moveTo(cell);
				deselectPiece(group);
				moveDone();
				return;
			}
		}

		selectPiece(group, cell);
	}

	private function selectPiece(group:Group, cell:Cell) {
		final piece = board.getPieceAt(cell);

		if (piece != null && piece.group.uid == group.uid) {
			selectedPiece = piece;
			board.selectCell(cell);

			var _availableCells = piece.kind.getAvailableCells(selectedPiece);
			availableCells = _availableCells;
			board.setAvailableCells(_availableCells);
		} else {
			deselectPiece(group);
		}
	}

	private function deselectPiece(group:Group) {
		selectedPiece = null;
		availableCells = [];
		board.selectCell(null);
		board.setAvailableCells([]);
	}
}
