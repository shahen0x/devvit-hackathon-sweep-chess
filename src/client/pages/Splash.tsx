import { useQuery } from '@tanstack/react-query';
import { context, requestExpandedMode } from '@devvit/web/client';
import { Button } from '@/components/ui/button';
import ChessboardPreview from '@/components/ChessboardPreview';
import DevBox from '@/components/DevBox';
import { ArrowUp, ChessQueen, MoveRight } from 'lucide-react';

interface SplashProps {
	onShowLeaderboard: () => void;
}

export default function Splash({ onShowLeaderboard }: SplashProps) {
	const username = context.username ?? 'Player';

	const handleStartGame = (e: React.MouseEvent<HTMLButtonElement>) => {
		requestExpandedMode(e.nativeEvent, 'game');
	};

	return (
		<div className="relative h-screen bg-background pt-6 flex flex-col justify-between items-center gap-4">
			{/* Header */}
			<header className="px-4 space-y-2 text-center">
				<div className="text-xs font-bold font-title text-primary">Hey {username}!</div>
				<h1 className="text-xl font-bold font-title leading-7">
					Can you beat this in fewer moves?
				</h1>
			</header>

			{/* Content */}
			<div className="flex flex-col items-center gap-2 px-4">
				<ChessboardPreview />

				<div className="mt-1 mb-2 flex gap-1 opacity-40 animate-pulse">
					<ArrowUp size={16} />
					<ArrowUp size={16} />
				</div>

				<div className="flex gap-1">
					<img
						src="/chess-pieces/rook.svg"
						width={48}
						height={48}
						className="size-5 animate-[bounce-forward_2s_ease-in-out_infinite]"
					/>
					<img
						src="/chess-pieces/queen.svg"
						width={48}
						height={48}
						className="size-5 animate-[bounce-forward_2s_ease-in-out_0.2s_infinite]"
					/>
					<img
						src="/chess-pieces/knight.svg"
						width={48}
						height={48}
						className="size-5 animate-[bounce-forward_2s_ease-in-out_0.4s_infinite]"
					/>
					<img
						src="/chess-pieces/bishop.svg"
						width={48}
						height={48}
						className="size-5 animate-[bounce-forward_2s_ease-in-out_0.6s_infinite]"
					/>
				</div>

				<Button onClick={handleStartGame} className="mt-1">
					Make Your Move <MoveRight />
				</Button>
			</div>

			{/* Footer */}
			<footer className="w-full px-4 py-2 border-t flex justify-between items-center">
				<p className="text-sm text-muted-foreground">Top: 10 moves</p>
				<Button onClick={onShowLeaderboard} variant="outline" size={'sm'}>
					Leaderboard
				</Button>
			</footer>

			{/* Dev Tools */}
			<DevBox />
		</div>
	);
}
