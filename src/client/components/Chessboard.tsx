import { memo } from 'react';

interface ChessboardProps {
	/** 8x8 board array where board[x][y] represents the piece at column x, row y */
	board: number[][];
	/** Callback when a square is clicked, receives (x, y) coordinates */
	onSquareClick?: (x: number, y: number) => void;
	/** Optional render function for custom piece rendering */
	renderPiece?: (pieceValue: number, x: number, y: number) => React.ReactNode;
	/** Optional render function for empty squares */
	renderEmptySquare?: (x: number, y: number, isLight: boolean) => React.ReactNode;
	/** Optional className for the board container */
	className?: string;
	/** Whether squares are clickable */
	interactive?: boolean;
}

// Memoized square component for better performance
const Square = memo(
	({
		x,
		y,
		pieceValue,
		isLight,
		onClick,
		renderPiece,
		renderEmptySquare,
		interactive = true,
	}: {
		x: number;
		y: number;
		pieceValue: number;
		isLight: boolean;
		onClick?: () => void;
		renderPiece?: (pieceValue: number, x: number, y: number) => React.ReactNode;
		renderEmptySquare?: (x: number, y: number, isLight: boolean) => React.ReactNode;
		interactive: boolean;
	}) => {
		const baseClasses = `aspect-square relative flex items-center justify-center ${
			isLight ? 'bg-[#EDD6BB]' : 'bg-[#D9BE9E]'
		}`;

		const interactiveClasses = interactive ? 'cursor-pointer group' : '';

		const content =
			pieceValue !== 0 ? renderPiece?.(pieceValue, x, y) : renderEmptySquare?.(x, y, isLight);

		if (onClick && interactive) {
			return (
				<button
					onClick={onClick}
					className={`${baseClasses} ${interactiveClasses}`}
					style={{ touchAction: 'none' }}
				>
					{content}
				</button>
			);
		}

		return (
			<div className={baseClasses} style={{ touchAction: 'none' }}>
				{content}
			</div>
		);
	}
);

Square.displayName = 'Square';

function Chessboard({
	board,
	onSquareClick,
	renderPiece,
	renderEmptySquare,
	className = '',
	interactive = true,
}: ChessboardProps) {
	return (
		<div
			className={`w-full aspect-square grid grid-cols-8 grid-rows-8 border border-[#D9BE9E] ${className}`}
			style={{ touchAction: 'none' }}
		>
			{Array.from({ length: 8 }).map((_, rankIndex) => {
				// Render from rank 8 (top) to rank 1 (bottom)
				const y = 7 - rankIndex;

				return Array.from({ length: 8 }).map((_, fileIndex) => {
					const x = fileIndex;
					const isLight = (x + y) % 2 === 0;
					const pieceValue = board[x]?.[y] ?? 0;

					const squareProps: any = {
						key: `${x}-${y}`,
						x,
						y,
						pieceValue,
						isLight,
						interactive: interactive && !!onSquareClick,
					};

					if (onSquareClick) {
						squareProps.onClick = () => onSquareClick(x, y);
					}
					if (renderPiece) {
						squareProps.renderPiece = renderPiece;
					}
					if (renderEmptySquare) {
						squareProps.renderEmptySquare = renderEmptySquare;
					}

					return <Square {...squareProps} />;
				});
			})}
		</div>
	);
}

export default memo(Chessboard);
