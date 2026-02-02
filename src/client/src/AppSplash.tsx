import React from 'react';
import { Button } from '@/components/ui/button';
import { requestExpandedMode, context } from '@devvit/web/client';
import '@/index.css';

export default function AppSplash() {
    const username = context.username ?? 'Player';

    const handleStartClick = (e: React.MouseEvent<HTMLButtonElement>) => {
        requestExpandedMode(e.nativeEvent, 'game');
    };

    return (
        <div className="flex relative flex-col justify-between items-center h-screen m-0 gap-4 bg-[#F0EAD8]">
            {/* Header */}
            <header className="mt-4 px-4">
                <div className="mb-1.5 text-base font-semibold text-center text-black">
                    Hey {username}!
                </div>
                <h1 className="text-2xl font-bold text-center uppercase leading-7 tracking-tight text-black">
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
                    // size="lg"
                    // className="bg-gradient-to-r from-violet-600 to-purple-600 hover:from-violet-700 hover:to-purple-700 active:from-violet-800 active:to-purple-800 text-white font-semibold px-6 py-6 rounded-xl text-lg cursor-pointer transition-all duration-200 shadow-lg hover:shadow-xl hover:scale-105"
                    onClick={handleStartClick}
                >
                    Make Your Move
                </Button>
            </div>

            {/* Footer */}
            <footer className="w-full px-4 pb-4 text-black">
                footer
            </footer>
        </div>
    );
}
