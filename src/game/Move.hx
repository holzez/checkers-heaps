import entities.Piece;

typedef Move = {
	piece:Piece,
	from:Cell,
	to:Cell,
	?capture:Piece,
}
