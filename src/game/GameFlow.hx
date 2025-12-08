import minds.PlayerMind;
import entities.Group;

class GameFlow extends utils.GameChildProcess {
	private final groups:Array<Group> = [];

	var activeGroupIndex = 0;

	public function new() {
		super();

		final whitePieces:Array<Cell> = [
			new Cell(0, 5), new Cell(2, 5), new Cell(4, 5), new Cell(6, 5),
			new Cell(1, 6), new Cell(3, 6), new Cell(5, 6), new Cell(7, 6),
			new Cell(0, 7), new Cell(2, 7), new Cell(4, 7), new Cell(6, 7),
		];

		final blackPieces:Array<Cell> = [
			new Cell(1, 0), new Cell(3, 0), new Cell(5, 0), new Cell(7, 0),
			new Cell(0, 1), new Cell(2, 1), new Cell(4, 1), new Cell(6, 1),
			new Cell(1, 2), new Cell(3, 2), new Cell(5, 2), new Cell(7, 2),
		];

		final whitePieceTile = hxd.Res.load('sprites/white-piece.png').toTile();
		final blackPieceTile = hxd.Res.load('sprites/black-piece.png').toTile();

		groups.push(new Group(whitePieces, whitePieceTile, new PlayerMind(), -1, onGroupMoved.bind()));
		groups.push(new Group(blackPieces, blackPieceTile, new PlayerMind(), 1, onGroupMoved.bind()));

		groups[activeGroupIndex].setMyStep(true);
	}

	private function onGroupMoved() {
		groups[activeGroupIndex].setMyStep(false);
		activeGroupIndex = (activeGroupIndex + 1) % groups.length;
		groups[activeGroupIndex].setMyStep(true);
	}
}
