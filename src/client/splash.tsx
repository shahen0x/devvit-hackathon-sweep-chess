import React from 'react';
import ReactDOM from 'react-dom/client';
import '@/global.css';
import { context, requestExpandedMode } from '@devvit/web/client';
import { Button } from '@/components/ui/button';
import ChessboardPreview from '@/components/ChessboardPreview';
import { QueryClient, QueryClientProvider, useQuery, useMutation } from '@tanstack/react-query';

const queryClient = new QueryClient();

// API functions
const fetchBoardData = async () => {
    const response = await fetch("/api/board-data");
    if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    if (data.status === "success") {
        console.log('Board data received:', data);
        console.log('Board:', data.board);
        console.log('Game ID:', data.gameId);
        console.log('Display Name', data.userDisplayName);
        console.log('Avatar', data.avatar);
        return data;
    } else {
        throw new Error("Invalid response from /api/board-data");
    }
};

const submitScore = async (scoreData: { totalMoves: number; cellsTravelled: number }) => {
    const response = await fetch("/api/submit-score", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(scoreData)
    });
    if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response.json();
};

function Splash() {
    const username = context.username ?? 'Player';
    console.log(context.postData);

    const handleStartGame = (e: React.MouseEvent<HTMLButtonElement>) => {
        requestExpandedMode(e.nativeEvent, 'game');
    };

    // Fetch board data
    const { isLoading, error } = useQuery({
        queryKey: ['boardData'],
        queryFn: fetchBoardData
    });

    // Submit score mutation
    const submitScoreMutation = useMutation({
        mutationFn: submitScore,
        onSuccess: (data) => {
            console.log("👌👌", data);
        },
        onError: (error) => {
            console.error("Error submitting score:", error);
        }
    });

    const handleSubmitScore = () => {
        submitScoreMutation.mutate({
            totalMoves: 10,
            cellsTravelled: 20
        });
    };

    return (
        <div className="relative h-screen bg-background pt-6 flex flex-col justify-between items-center gap-4">
            {/* Header */}
            <header className="px-4 space-y-2 text-center">
                <div className="text-xs font-bold font-title text-primary">
                    Hey {username}!
                </div>
                <h1 className="text-2xl font-bold font-title leading-7">
                    Can you beat this in fewer moves?
                </h1>
            </header>

            {/* Content */}
            <div className="flex flex-col items-center gap-2 px-4">
                {isLoading ? (
                    <div className="text-muted-foreground">Loading board...</div>
                ) : error ? (
                    <div className="text-destructive">Error loading board data</div>
                ) : (
                    <ChessboardPreview />
                )}

                <Button
                    className='mt-6'
                    onClick={handleSubmitScore}
                    disabled={submitScoreMutation.isPending}
                >
                    {submitScoreMutation.isPending ? 'Submitting...' : 'Test'}
                </Button>
                <Button
                    className='mt-6'
                    onClick={handleStartGame}
                >
                    Make Your Move
                </Button>
            </div>

            {/* Footer */}
            <footer className="w-full px-4 py-2 border-t">
                <p className='text-sm text-muted-foreground'>Top: 10 moves</p>
            </footer>
        </div>
    );
}

ReactDOM.createRoot(document.getElementById('root')!).render(
    <React.StrictMode>
        <QueryClientProvider client={queryClient}>
            <Splash />
        </QueryClientProvider>
    </React.StrictMode>
);
