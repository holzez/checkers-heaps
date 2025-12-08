typedef CellLiteral = {x:Int, y:Int};

abstract Cell(CellLiteral) {
	public var x(get, set):Int;
	public var y(get, set):Int;

	inline function get_x()
		return this.x;

	inline function get_y()
		return this.y;

	inline function set_x(value:Int)
		return this.x = value;

	inline function set_y(value:Int)
		return this.y = value;

	public inline function new(x:Int, y:Int) {
		this = {x: x, y: y};
	}

	public static inline function fromId(id:Int) {
		return new Cell(id % 8, Std.int(id / 8));
	}

	@:op(a == b)
	public inline function equals(other:Cell):Bool {
		return this.x == other.x && this.y == other.y;
	}

	public inline function isWhite() {
		return (x + y) % 2 == 0;
	}

	public inline function isBlack() {
		return !isWhite();
	}

	public inline function isValid() {
		return x >= 0 && x < 8 && y >= 0 && y < 8;
	}

	public inline function toId() {
		return x + y * 8;
	}

	public inline function clone() {
		return new Cell(x, y);
	}

	public inline function toString() {
		return 'Cell($x, $y)';
	}
}
