import React, { useState } from 'react';
import ReactDOM from 'react-dom/client';
import '@/global.css';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import Splash from '@/pages/Splash';
import Leaderboard from '@/pages/Leaderboard';

const queryClient = new QueryClient();

function App() {
    const [showLeaderboard, setShowLeaderboard] = useState(false);

    return (
        <QueryClientProvider client={queryClient}>
            {showLeaderboard ? (
                <Leaderboard onBack={() => setShowLeaderboard(false)} />
            ) : (
                <Splash onShowLeaderboard={() => setShowLeaderboard(true)} />
            )}
        </QueryClientProvider>
    );
}

ReactDOM.createRoot(document.getElementById('root')!).render(
    <React.StrictMode>
        <App />
    </React.StrictMode>
);