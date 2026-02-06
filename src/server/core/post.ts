import { context, reddit } from '@devvit/web/server';
import { generateDailyBoard } from '../utils/board-generator';

export const createPost = async () => {
	const { subredditName } = context;

	if (!subredditName) {
		throw new Error('subredditName is required');
	}

	return await reddit.submitCustomPost({
		subredditName: subredditName,
		title: 'SweepChess Challenge #1',
		entry: 'default',
		postData: {
			gameId: '1',
			board: generateDailyBoard(),
		},
	});
};

export const createCreatorPost = async () => {
	const { subredditName } = context;

	if (!subredditName) {
		throw new Error('subredditName is required');
	}

	return await reddit.submitCustomPost({
		subredditName: subredditName,
		title: 'Create Your Own Chess Puzzle',
		entry: 'creator',
		postData: {
			type: 'creator',
			// Add any initial creator data here
		},
	});
};
