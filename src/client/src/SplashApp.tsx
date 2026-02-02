import React from 'react';
import { requestExpandedMode, context } from '@devvit/web/client';
import '../styles/splash.css';

const SplashApp: React.FC = () => {
    const username = context.username ?? 'Player';

    const handleStartClick = (e: React.MouseEvent<HTMLButtonElement>) => {
        requestExpandedMode(e.nativeEvent, 'game');
    };

    return (
        <div className="app">
            <header className="header">
                <div className="greetUser">Hey {username}!</div>
                <h1 className="title">Can you beat this in fewer moves?</h1>
            </header>

            <div className="content">
                <img src="/images/board.png" className="board" alt="Chess board" />
                <button
                    className="bg-gradient-to-r from-violet-600 to-purple-600 hover:from-violet-700 hover:to-purple-700 active:from-violet-800 active:to-purple-800 text-white font-semibold px-6 py-3 rounded-xl text-lg cursor-pointer transition-all duration-200 shadow-lg hover:shadow-xl hover:scale-105"
                    onClick={handleStartClick}
                >
                    Make Your Move
                </button>
            </div>

            <footer className="footer">
                footer
            </footer>
        </div>
    );
};

export default SplashApp;
