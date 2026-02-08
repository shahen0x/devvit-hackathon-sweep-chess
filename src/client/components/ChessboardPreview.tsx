import { useMemo, useState, useEffect, useCallback } from 'react';
import Chessboard from './Chessboard';
import { context } from '@devvit/web/client';

export default function ChessboardPreview() {
	const board = context.postData?.board as number[][] | undefined;
	// Only show loading if board data is not immediately available
	const [showLoading, setShowLoading] = useState(!board);
	const [fadeOut, setFadeOut] = useState(false);

	// Hide loading when board data becomes available
	useEffect(() => {
		if (board && showLoading) {
			// Start fade out when data arrives
			setFadeOut(true);

			// Remove overlay after fade completes
			const hideTimer = setTimeout(() => {
				setShowLoading(false);
			}, 300); // Match the fade duration

			return () => clearTimeout(hideTimer);
		}
	}, [board, showLoading]);

	// Create empty board for loading state
	const displayBoard = useMemo(() => {
		if (board) {
			return board;
		}
		// Return empty 8x8 board while loading
		return Array(8)
			.fill(0)
			.map(() => Array(8).fill(0));
	}, [board]);

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

	return (
		<div className="relative">
			<Chessboard board={displayBoard} renderPiece={renderPiece} interactive={false} />

			{/* Loading overlay with animated dots */}
			{showLoading && (
				<div
					className={`absolute inset-0 pointer-events-none grid grid-cols-8 grid-rows-8 transition-opacity duration-300 ${
						fadeOut ? 'opacity-0' : 'opacity-100'
					}`}
				>
					{Array.from({ length: 64 }).map((_, index) => {
						const row = Math.floor(index / 8);
						const col = index % 8;
						const delay = (row + col) * 0.03; // Faster diagonal wave

						return (
							<div key={index} className="flex items-center justify-center">
								<div
									className="w-2 h-2 bg-black/30 rounded-full animate-pulse"
									style={{
										animationDelay: `${delay}s`,
										animationDuration: '1s',
									}}
								/>
							</div>
						);
					})}
				</div>
			)}
		</div>
	);
}
