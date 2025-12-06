package ui;

class Console extends h2d.Console {
	public static var instance:Console;

	public function new(font:h2d.Font, parent:h2d.Object) {
		super(font, parent);
		instance = this;
	}
}
