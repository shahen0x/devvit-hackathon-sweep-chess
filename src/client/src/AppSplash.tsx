import React, { useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { requestExpandedMode, context, showToast } from '@devvit/web/client';
import '@/index.css';

export default function AppSplash() {
    const username = context.username ?? 'Player';
    console.log(context.postData)
    showToast('Hello from Devvit Web!');

    const handleStartClick = (e: React.MouseEvent<HTMLButtonElement>) => {
        requestExpandedMode(e.nativeEvent, 'game');
    };

    useEffect(() => {
        async function fetchData() {
            try {
                const response = await fetch("/api/init");
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                const data = (await response.json());
                if (data.type === "init") {
                    console.log(data);
                } else {
                    console.error("Invalid response type from /api/init", data);
                }
            } catch (error) {
                console.error("Error fetching initial data:", error);
            }
        }

        fetchData();
    }, []);

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
                <img
                    src="/images/board.png"
                    className="max-w-[200px] w-auto h-auto"
                    alt="Chess board"
                />
                <Button
                    className='mt-6'
                    // size="lg"
                    // className="bg-gradient-to-r from-violet-600 to-purple-600 hover:from-violet-700 hover:to-purple-700 active:from-violet-800 active:to-purple-800 text-white font-semibold px-6 py-6 rounded-xl text-lg cursor-pointer transition-all duration-200 shadow-lg hover:shadow-xl hover:scale-105"
                    onClick={handleStartClick}
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
