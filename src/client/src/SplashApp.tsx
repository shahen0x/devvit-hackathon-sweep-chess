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
                <button className="start-button" onClick={handleStartClick}>
                    Make Your Moves
                </button>
            </div>

            <footer className="footer">
                footer
            </footer>
        </div>
    );
};

export default SplashApp;
