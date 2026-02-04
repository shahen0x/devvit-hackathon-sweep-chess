import { useMemo } from 'react';
import { Chessboard } from 'react-chessboard';
import { context } from '@devvit/web/client';

export default function ChessboardPreview() {
	const board = context.postData?.board as number[][] | undefined;

	// Custom piece components
	const customPieces = useMemo(
		() => ({
			bP: () => (
				<img src="/chess-pieces/pawn.svg" alt="pawn" className="w-full h-full p-0.5" />
			),
		}),
		[]
	);

	// Convert board array to chess position object
	const boardPosition = useMemo(() => {
		if (!board) return {};

		const position: Record<string, { pieceType: string }> = {};
		const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

		// Place pawns based on board data
		// board[x][y] where board[x] is the column array, y is the row index
		// board[0] = column 'a', board[1] = column 'b', etc.
		// board[x][0] = rank 1, board[x][7] = rank 8
		for (let x = 0; x < 8; x++) {
			const file = files[x];
			for (let y = 0; y < 8; y++) {
				if (board[x]?.[y] === 1) {
					const rank = y + 1; // y=0 -> rank 1, y=7 -> rank 8
					position[`${file}${rank}`] = { pieceType: 'bP' }; // Black pawn
				}
			}
		}

		return position;
	}, [board]);

	return (
		<div style={{ width: '250px' }}>
			<Chessboard
				options={{
					position: boardPosition,
					allowDragging: false,
					boardStyle: {
						border: '1px solid #BFA280',
					},
					lightSquareStyle: { backgroundColor: '#EDD6BB' },
					darkSquareStyle: { backgroundColor: '#D9BE9E' },
					pieces: customPieces,
					showNotation: false,
				}}
			/>
		</div>
	);
}
