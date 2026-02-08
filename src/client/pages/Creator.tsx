import { useState, useMemo, useCallback, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { useMutation } from '@tanstack/react-query';
import Chessboard from '@/components/Chessboard';
import { navigateTo } from '@devvit/web/client';

const BOARD_SIZE = 8;
const MAX_PAWNS = 24;

export default function Creator() {
	// Board state: 8x8 array where 0 = empty, 1 = pawn
	// board[x][y] where x is column (0-7), y is row (0=bottom, 7=top)
	const [board, setBoard] = useState<number[][]>(
		Array(BOARD_SIZE)
			.fill(0)
			.map(() => Array(BOARD_SIZE).fill(0))
	);

	// Preload pawn image for instant rendering
	useEffect(() => {
		const img = new Image();
		img.src = '/chess-pieces/pawn.svg';
	}, []);

	// Count placed pawns
	const pawnCount = useMemo(() => {
		return board.flat().filter((cell) => cell === 1).length;
	}, [board]);

	// Handle square click to toggle pawn
	const handleSquareClick = useCallback((x: number, y: number) => {
		setBoard((prevBoard) => {
			const currentValue = prevBoard[x]?.[y];
			if (currentValue === undefined) return prevBoard;

			// If removing a pawn, always allow
			if (currentValue === 1) {
				const newBoard = prevBoard.map((row) => [...row]);
				newBoard[x]![y] = 0;
				return newBoard;
			}

			// If placing a pawn, check count
			if (currentValue === 0) {
				// Quick count: only count if we're placing
				let count = 0;
				for (let i = 0; i < 8 && count < MAX_PAWNS; i++) {
					for (let j = 0; j < 8 && count < MAX_PAWNS; j++) {
						if (prevBoard[i]?.[j] === 1) count++;
					}
				}

				if (count >= MAX_PAWNS) return prevBoard; // At max, don't place

				const newBoard = prevBoard.map((row) => [...row]);
				newBoard[x]![y] = 1;
				return newBoard;
			}

			return prevBoard;
		});
	}, []);

	// Clear all pawns
	const handleClear = () => {
		setBoard(
			Array(BOARD_SIZE)
				.fill(0)
				.map(() => Array(BOARD_SIZE).fill(0))
		);
	};

	// Submit board mutation
	const submitBoardMutation = useMutation({
		mutationFn: async (boardData: number[][]) => {
			const response = await fetch('/api/create-puzzle', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ board: boardData }),
			});

			if (!response.ok) {
				const error = await response.json();
				throw new Error(error.message || 'Failed to create level');
			}

			return response.json();
		},
		onSuccess: (data) => {
			console.log('Level created successfully:', data);
			// Navigate to the newly created post using devvit navigation
			if (data.postUrl) {
				navigateTo({ url: data.postUrl });
			} else if (data.postId) {
				// Fallback: construct the URL
				const cleanPostId = data.postId.replace(/^t3_/, '');
				navigateTo({ url: `https://reddit.com/comments/${cleanPostId}` });
			}
		},
		onError: (error: Error) => {
			console.error('Failed to create puzzle:', error);
			alert(`Failed to create puzzle: ${error.message}`);
		},
	});

	const handleSubmit = () => {
		if (pawnCount !== MAX_PAWNS) {
			alert(`Please place exactly ${MAX_PAWNS} pawns. Currently placed: ${pawnCount}`);
			return;
		}

		submitBoardMutation.mutate(board);
	};

	// Render pawn piece
	const renderPiece = useCallback((pieceValue: number) => {
		if (pieceValue === 1) {
			return (
				<img
					src="/chess-pieces/pawn.svg"
					alt="pawn"
					className="w-[70%] h-[70%] pointer-events-none select-none"
					draggable={false}
				/>
			);
		}
		return null;
	}, []);

	// Render empty square with placement dot
	const renderEmptySquare = useCallback(() => {
		if (pawnCount < MAX_PAWNS) {
			return (
				<div className="w-3 h-3 rounded-full bg-white/50 group-hover:bg-black/60 transition-colors duration-100 pointer-events-none" />
			);
		}
		return null;
	}, [pawnCount]);

	return (
		<div className="relative h-screen bg-background pt-6 flex flex-col gap-4 px-4 pb-4">
			{/* Chessboard */}
			<div className="flex-1 flex flex-col gap-6 items-center">
				<h1 className="font-title text-center text-xl font-bold">
					Place Pawns on the board
				</h1>

				<div className="w-full max-w-88 relative">
					<Chessboard
						board={board}
						onSquareClick={handleSquareClick}
						renderPiece={renderPiece}
						renderEmptySquare={renderEmptySquare}
						interactive={true}
					/>
					{/* Overlay to prevent interaction while submitting */}
					{submitBoardMutation.isPending && (
						<div className="absolute inset-0 bg-black/20 flex items-center justify-center">
							<div className="bg-background px-4 py-2 rounded-lg shadow-lg">
								<p className="text-sm font-medium">Creating Level...</p>
							</div>
						</div>
					)}
				</div>
			</div>

			{/* Footer */}
			<footer className="flex justify-between">
				{/* Pawn Counter */}
				<div className="text-center">
					<div className="inline-flex items-center gap-1 px-2 py-2 bg-secondary rounded-md">
						<img src="/chess-pieces/pawn.svg" alt="pawn" className="w-5 h-5" />
						<span className="text-sm font-bold">
							{pawnCount} / {MAX_PAWNS}
						</span>
					</div>
				</div>

				{/* Action Buttons */}
				<div className="flex gap-2">
					<Button
						onClick={handleClear}
						variant="outline"
						className="flex-1"
						disabled={pawnCount === 0 || submitBoardMutation.isPending}
					>
						Clear
					</Button>
					<Button
						onClick={handleSubmit}
						className="flex-1"
						disabled={pawnCount !== MAX_PAWNS || submitBoardMutation.isPending}
					>
						{submitBoardMutation.isPending ? 'Creating Level...' : <>Create Level</>}
					</Button>
				</div>
			</footer>
		</div>
	);
}
