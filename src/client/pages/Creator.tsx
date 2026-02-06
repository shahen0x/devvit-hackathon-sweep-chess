import { Button } from '@/components/ui/button';
import { Grid3x3, Palette, Save } from 'lucide-react';

export default function Creator() {
	return (
		<div className="relative h-screen bg-background pt-6 flex flex-col gap-4 px-4">
			{/* Header */}
			<header className="space-y-1 text-center">
				<h1 className="text-xl font-bold font-title leading-6">Level Creator</h1>
				<p className="text-xs text-muted-foreground">Design your own chess puzzle</p>
			</header>

			{/* Content */}
			<div className="flex-1 flex flex-col items-center gap-4">
				{/* Placeholder for board editor */}
				<div className="w-full max-w-md aspect-square bg-secondary rounded-lg border-2 border-dashed border-muted-foreground/30 flex items-center justify-center">
					<div className="text-center space-y-2 text-muted-foreground">
						<Grid3x3 size={48} className="mx-auto opacity-50" />
						<p className="text-sm">Board Editor</p>
						<p className="text-xs">Drag and drop pieces here</p>
					</div>
				</div>

				{/* Placeholder for piece palette */}
				<div className="w-full max-w-md p-4 bg-secondary rounded-lg border">
					<div className="flex items-center gap-2 mb-3">
						<Palette size={16} />
						<h3 className="font-semibold text-sm">Piece Palette</h3>
					</div>
					<div className="flex gap-2 justify-center">
						<div className="w-12 h-12 bg-background rounded border flex items-center justify-center text-xs">
							Pawn
						</div>
						<div className="w-12 h-12 bg-background rounded border flex items-center justify-center text-xs">
							Rook
						</div>
						<div className="w-12 h-12 bg-background rounded border flex items-center justify-center text-xs">
							Knight
						</div>
						<div className="w-12 h-12 bg-background rounded border flex items-center justify-center text-xs">
							Bishop
						</div>
						<div className="w-12 h-12 bg-background rounded border flex items-center justify-center text-xs">
							Queen
						</div>
					</div>
				</div>

				{/* Save button */}
				<Button className="w-full max-w-md">
					<Save /> Save Level
				</Button>
			</div>
		</div>
	);
}
