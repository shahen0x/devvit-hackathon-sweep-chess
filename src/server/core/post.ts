import { context, reddit, redis } from '@devvit/web/server';
import { generateDailyBoard, getDailyBoardSeed } from '../utils/board-generator';

export const createDailyChallengePost = async () => {
	const { subredditName } = context;

	if (!subredditName) {
		throw new Error('subredditName is required');
	}

	// Check if we already posted today
	const todaySeed = getDailyBoardSeed();
	const lastPostedSeed = await redis.get('daily-challenge:last-posted-date');

	if (lastPostedSeed === todaySeed.toString()) {
		throw new Error(
			'Daily challenge already posted for today. Please wait until tomorrow (UTC).'
		);
	}

	// Get and increment the challenge counter
	const challengeNumber = await redis.incrBy('challenge:counter', 1);

	// Create the post
	const post = await reddit.submitCustomPost({
		subredditName: subredditName,
		title: `Sweep Chess - Daily Challenge #${challengeNumber}`,
		entry: 'default',
		postData: {
			gameId: challengeNumber.toString(),
			board: generateDailyBoard(),
		},
	});

	// Store today's date to prevent duplicate posts
	await redis.set('daily-challenge:last-posted-date', todaySeed.toString());

	return post;
};

export const createLevelCreatorPost = async () => {
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
