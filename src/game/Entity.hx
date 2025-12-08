import dn.struct.FixedArray;

class Entity {
	public static var all:FixedArray<Entity> = new FixedArray<Entity>(256);
	public static var garbage:FixedArray<Entity> = new FixedArray<Entity>(all.maxSize);

	inline function get_app()
		return App.instance;

	public var game(get, never):Game;

	inline function get_game()
		return Game.instance;

	public var board(get, never):Board;

	inline function get_board()
		return game.board;

	public var tmod(get, never):Float;

	inline function get_tmod()
		return game.tmod;

	public var uid(default, null):Int;
	public var destroyed(default, null) = false;

	public function new() {
		uid = Const.makeUniqueId();
		all.push(this);
	}

	public final function destroy() {
		if (!destroyed) {
			destroyed = true;
			garbage.push(this);
		}
	}

	public function dispose() {
		all.remove(this);
	}

	public function preUpdate() {}

	public function postUpdate() {}

	public function finalUpdate() {}

	public function fixedUpdate() {}

	public function frameUpdate() {}
}
