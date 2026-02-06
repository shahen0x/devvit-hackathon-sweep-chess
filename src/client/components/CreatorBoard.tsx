import { memo, useState, useCallback } from 'react';

interface CreatorBoardProps {
	board: number[][];
	onSquareClick: (x: number, y: number) => void;
	isMaxPawns: boolean;
}

// Memoized square component for better performance
const Square = memo(
	({
		hasPawn,
		isLight,
		isMaxPawns,
		onPointerDown,
		onPointerEnter,
	}: {
		hasPawn: boolean;
		isLight: boolean;
		isMaxPawns: boolean;
		onPointerDown: () => void;
		onPointerEnter: () => void;
	}) => {
		const showDot = !hasPawn && !isMaxPawns;

		return (
			<button
				onPointerDown={onPointerDown}
				onPointerEnter={onPointerEnter}
				className={`aspect-square relative flex items-center justify-center cursor-pointer ${
					isLight ? 'bg-[#EDD6BB]' : 'bg-[#D9BE9E]'
				}`}
				style={{ touchAction: 'none' }}
			>
				{hasPawn ? (
					<img
						src="/chess-pieces/pawn.svg"
						alt="pawn"
						className="w-[70%] h-[70%] pointer-events-none select-none"
						draggable={false}
					/>
				) : (
					showDot && (
						<div className="w-3 h-3 rounded-full bg-white/50 pointer-events-none" />
					)
				)}
			</button>
		);
	}
);

Square.displayName = 'Square';

function CreatorBoard({ board, onSquareClick, isMaxPawns }: CreatorBoardProps) {
	const [isDragging, setIsDragging] = useState(false);
	const [dragMode, setDragMode] = useState<'place' | 'remove' | null>(null);

	const handlePointerDown = useCallback(
		(x: number, y: number) => {
			setIsDragging(true);
			const hasPawn = board[x]?.[y] === 1;
			// Set drag mode based on what we're clicking
			setDragMode(hasPawn ? 'remove' : 'place');
			onSquareClick(x, y);
		},
		[board, onSquareClick]
	);

	const handlePointerEnter = useCallback(
		(x: number, y: number) => {
			if (!isDragging || !dragMode) return;

			const hasPawn = board[x]?.[y] === 1;

			// Only apply action if it matches the drag mode
			if (dragMode === 'place' && !hasPawn) {
				onSquareClick(x, y);
			} else if (dragMode === 'remove' && hasPawn) {
				onSquareClick(x, y);
			}
		},
		[isDragging, dragMode, board, onSquareClick]
	);

	const handlePointerUp = useCallback(() => {
		setIsDragging(false);
		setDragMode(null);
	}, []);

	return (
		<div
			className="w-full aspect-square grid grid-cols-8 grid-rows-8 border border-[#D9BE9E]"
			style={{ touchAction: 'none' }}
			onPointerUp={handlePointerUp}
			onPointerLeave={handlePointerUp}
		>
			{Array.from({ length: 8 }).map((_, rankIndex) => {
				// Render from rank 8 (top) to rank 1 (bottom)
				const y = 7 - rankIndex;

				return Array.from({ length: 8 }).map((_, fileIndex) => {
					const x = fileIndex;
					const isLight = (x + y) % 2 === 0;
					const hasPawn = board[x]?.[y] === 1;

					return (
						<Square
							key={`${x}-${y}`}
							hasPawn={hasPawn}
							isLight={isLight}
							isMaxPawns={isMaxPawns}
							onPointerDown={() => handlePointerDown(x, y)}
							onPointerEnter={() => handlePointerEnter(x, y)}
						/>
					);
				});
			})}
		</div>
	);
}

export default memo(CreatorBoard);
