import { useQuery } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';

interface LeaderboardProps {
	onBack: () => void;
}

// API function
const fetchLeaderboard = async () => {
	const response = await fetch('/api/leaderboard');
	if (!response.ok) {
		throw new Error(`HTTP error! status: ${response.status}`);
	}
	return response.json();
};

export default function Leaderboard({ onBack }: LeaderboardProps) {
	const { data, isLoading, error } = useQuery({
		queryKey: ['leaderboard'],
		queryFn: fetchLeaderboard,
	});

	return (
		<div className="relative h-screen bg-background pt-6 flex flex-col items-center gap-4 px-4">
			{/* Header */}
			<header className="space-y-2 text-center">
				<h1 className="text-2xl font-bold font-title leading-7">Leaderboard</h1>
				<p className="text-sm text-muted-foreground">Top players by fewest moves</p>
			</header>

			{/* Content */}
			<div className="w-full max-w-md flex-1 overflow-auto">
				{isLoading ? (
					<div className="text-center text-muted-foreground">Loading leaderboard...</div>
				) : error ? (
					<div className="text-center text-destructive">Error loading leaderboard</div>
				) : !data || data.length === 0 ? (
					<div className="text-center text-muted-foreground">
						No scores yet. Be the first!
					</div>
				) : (
					<div className="space-y-2">
						{data.map((entry: any) => (
							<div
								key={entry.userId}
								className="flex items-center justify-between p-4 bg-card rounded-lg border"
							>
								<div className="flex items-center gap-3">
									<span className="text-lg font-bold text-primary">
										#{entry.rank}
									</span>
									<div>
										<p className="font-semibold">
											{entry.username || 'Anonymous'}
										</p>
										<p className="text-sm text-muted-foreground">
											{entry.totalMoves} moves
										</p>
									</div>
								</div>
								<div className="text-right">
									<p className="text-sm text-muted-foreground">
										{entry.cellsTravelled} cells
									</p>
									<p className="text-xs text-muted-foreground">
										Score: {entry.score?.toFixed(2)}
									</p>
								</div>
							</div>
						))}
					</div>
				)}
			</div>

			{/* Footer */}
			<footer className="w-full py-4 border-t">
				<Button variant="outline" className="w-full" onClick={onBack}>
					Back to Game
				</Button>
			</footer>
		</div>
	);
}
