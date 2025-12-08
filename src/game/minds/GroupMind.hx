package minds;

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

	private var onMoveCallback:Void->Void;

	public function new() {}

	public function setGroup(group:Group, onMoveCallback:Void->Void) {
		this.group = group;
		this.onMoveCallback = onMoveCallback;
	}

	public function onMoveStart() {}

	public function update(group:Group) {}

	private function moveDone() {
		onMoveCallback();
	}
}
