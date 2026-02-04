import React, { useEffect, useMemo } from 'react';
import ReactDOM from 'react-dom/client';
import '@/global.css';
import { context, requestExpandedMode } from '@devvit/web/client';
import { Button } from '@/components/ui/button';
import { Chessboard } from 'react-chessboard';

function Splash() {
    const username = context.username ?? 'Player';
    console.log(context.postData);

    const handleStartGame = (e: React.MouseEvent<HTMLButtonElement>) => {
        requestExpandedMode(e.nativeEvent, 'game');
    };

    useEffect(() => {
        async function fetchData() {
            try {
                const response = await fetch("/api/board-data");
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                const data = (await response.json());
                if (data.status === "success") {
                    console.log('Board data received:', data);
                    console.log('Board:', data.board);
                    console.log('Game ID:', data.gameId);
                    console.log('Display Name', data.userDisplayName)
                    console.log('Avatar', data.avatar)
                } else {
                    console.error("Invalid response from /api/board-data", data);
                }
            } catch (error) {
                console.error("Error fetching board data:", error);
            }
        }

        fetchData();
    }, []);

    // Custom piece components
    const customPieces = useMemo(() => ({
        bP: () => (
            <img
                src="/images/piece-pawn.svg"
                alt="pawn"
                className='w-full h-full p-0.5'
            />
        ),
    }), []);

    // Convert board array to chess position object
    const boardPosition = useMemo(() => {
        const board = context.postData?.board as number[][] | undefined;
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
    }, [context.postData]);

    async function handleSubmitScore() {
        try {
            const response = await fetch("/api/submit-score", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    totalMoves: 10,
                    cellsTravelled: 20
                })
            });
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = (await response.json());
            console.log("👌👌", data)
        } catch (error) {
            console.error("Error fetching board data:", error);
        }
    }

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
                <div style={{ width: '250px' }}>
                    <Chessboard options={{
                        position: boardPosition,
                        allowDragging: false,
                        boardStyle: {
                            border: '1px solid #BFA280'
                        },
                        lightSquareStyle: { backgroundColor: '#EDD6BB' },
                        darkSquareStyle: { backgroundColor: '#D9BE9E' },
                        pieces: customPieces,
                        showNotation: false
                    }}
                    />
                </div>

                <Button
                    className='mt-6'
                    onClick={handleSubmitScore}
                >
                    Test
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
        <Splash />
    </React.StrictMode>
);
