package minds;

import entities.Piece;
import entities.Group;

abstract class GroupMind {
	public var group(default, null):Group;

	public var app(get, never):App;

	inline function get_app()
		return App.instance;

	public var game(get, never):Game;

	inline function get_game()
		return Game.instance;

	public var board(get, never):Board;

	inline function get_board()
		return game.board;

	private var onMoveSelectedCallback:Move->Void;

	private var requiredPieces:Array<Piece> = [];

	public function new() {}

	public function setGroup(group:Group, onMoveSelectedCallback:Move->Void) {
		this.group = group;
		this.onMoveSelectedCallback = onMoveSelectedCallback;
	}

	public function onMoveStart(group:Group) {
		requiredPieces = [];

		for (piece in group.pieces) {
			if (piece.destroyed) {
				continue;
			}

			var requiredMoves = piece.kind.getRequiredMoves(piece);
			if (requiredMoves.length > 0) {
				requiredPieces.push(piece);
			}
		}
	}

	public function onMoveEnd(group:Group) {
		requiredPieces = [];
		deselectPiece();
	}

	public function onMoveSequance(group:Group, piece:Piece) {
		requiredPieces = [piece];
		selectPiece(piece);
	}

	public abstract function selectPiece(piece:Piece):Void;

	public abstract function deselectPiece():Void;

	public abstract function preUpdate(group:Group):Void;

	private function selectMove(move:Move) {
		onMoveSelectedCallback(move);
	}

	private function isAllowedPiece(piece:Piece):Bool {
		if (requiredPieces.length == 0) {
			return true;
		}

		for (requiredPiece in requiredPieces) {
			if (requiredPiece.uid == piece.uid) {
				return true;
			}
		}
		return false;
	}
}
