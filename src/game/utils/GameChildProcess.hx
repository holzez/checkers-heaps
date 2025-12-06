package utils;

class GameChildProcess extends dn.Process {
	public var app(get, never):App;

	inline function get_app()
		return App.instance;

	public var game(get, never):Game;

	inline function get_game()
		return Game.instance;

	public function new() {
		super(Game.instance);
	}
}
