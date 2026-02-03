import GameCanvas from '@/components/GameCanvas';
import { context } from '@devvit/web/client';

export default function App() {
    const board = context.postData?.board as number[][] | undefined;

    return <GameCanvas />;
}
