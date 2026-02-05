import { useQuery } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';
import { ArrowLeft, LoaderCircle } from 'lucide-react';

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
		<div className="relative h-screen bg-background pt-4 gap-4 px-4">
			{/* Header */}
			<header className="mb-6 flex items-center gap-6">
				<Button onClick={onBack} variant="outline" size={'icon'}>
					<ArrowLeft />
				</Button>
				<div className="space-y-1">
					<h1 className="h-6 text-xl font-bold font-title">Leaderboard</h1>
					<p className="text-xs text-muted-foreground">Top players by fewest moves</p>
				</div>
			</header>

			{/* Content */}
			<div className="h-[calc(100%-84px)] flex items-center justify-center">
				{isLoading ? (
					<LoaderCircle size={24} className="animate-spin" />
				) : error ? (
					<div className="text-center text-destructive">Error loading leaderboard</div>
				) : !data || data.length === 0 ? (
					<div className="text-center text-muted-foreground">
						No scores yet. Be the first!
					</div>
				) : (
					<div className="space-y-2 max-w-md">
						{data.map((entry: any) => (
							<div
								key={entry.userId}
								className="flex items-center justify-between p-4 bg-secondary rounded-lg border"
							>
								<div className="flex items-center gap-3">
									<span className="text-lg font-bold text-primary">
										#{entry.rank}
									</span>

									<figure className="w-10">
										{entry.snoovatar === 'none' ? (
											<img
												src="/misc/snoo.png"
												className="grayscale opacity-40"
											/>
										) : (
											<img src={entry.snoovatar} />
										)}
									</figure>

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
		</div>
	);
}
