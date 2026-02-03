import { useRef, useEffect, useState, useCallback } from 'react';
import { InitResponse } from '@shared/types/api';
import { context } from '@devvit/web/client';

declare global {
    interface Window {
        Module: any;
        GM_tick?: (time: number) => void;
        onGameSetWindowSize?: (width: number, height: number) => void;
        manifestFiles?: () => string;
        manifestFilesMD5?: () => string[];
        log_next_game_state?: () => void;
        wallpaper_update_config?: (config: string) => void;
        wallpaper_reset_config?: () => void;
        setAddAsyncMethod?: (method: any) => void;
        setJSExceptionHandler?: (handler: any) => void;
        hasJSExceptionHandler?: () => boolean;
        doJSExceptionHandler?: (exceptionJSON: string) => void;
        setWadLoadCallback?: (callback: any) => void;
        onFirstFrameRendered?: () => void;
        triggerAd?: (adId: string, ...callbacks: any[]) => void;
        triggerPayment?: (itemId: string, callback: any) => void;
        toggleElement?: (id: string) => void;
        set_acceptable_rollback?: (frames: number) => void;
        report_stats?: (statsData: any) => void;
        g_pAddAsyncMethod?: any;
        g_pJSExceptionHandler?: any;
        g_pWadLoadCallback?: any;
        // Custom function to send board data to GameMaker
        sendBoardDataToGM?: (boardData: number[][]) => void;
    }
}

type RunnerManifest = {
    manifestFiles: string[];
    manifestFilesMD5: string[];
    mainJS?: string;
    unx?: string;
    index?: string;
    runner?: { version?: string; yyc?: boolean };
};

const GameCanvas = () => {
    const canvasRef = useRef<HTMLCanvasElement>(null);
    const loadingRef = useRef<HTMLDivElement>(null);
    const statusRef = useRef<HTMLDivElement>(null);
    const progressRef = useRef<HTMLProgressElement>(null);
    const spinnerRef = useRef<HTMLDivElement>(null);

    const [isLoading, setIsLoading] = useState(true);
    const [statusText, setStatusText] = useState('Loading Game...');
    const [progressValue, setProgressValue] = useState(0);
    const [progressMax, setProgressMax] = useState(100);
    const [progressHidden, setProgressHidden] = useState(true);
    const [canvasActive, setCanvasActive] = useState(false);

    const startingDimensions = useRef<{
        width?: number;
        height?: number;
        aspect?: number;
    }>({});

    // Get board data from context
    const boardData = (context.postData?.board as number[][] | undefined) || [];

    const ensureAspectRatio = useCallback(() => {
        const canvas = canvasRef.current;
        const { width, height, aspect } = startingDimensions.current;

        if (!canvas || !height || !width || !aspect) {
            return;
        }

        setCanvasActive(true);
        canvas.style.height = "100%";
        canvas.style.width = "100%";
    }, []);

    const setupGameMakerGlobals = useCallback(() => {
        // Function to send board data to GameMaker
        window.sendBoardDataToGM = (boardData: number[][]) => {
            console.log('Sending board data to GameMaker:', boardData);
            
            // Convert 2D array to JSON string
            const boardJSON = JSON.stringify(boardData);
            
            // If GameMaker's async method is available, call it
            if (window.g_pAddAsyncMethod && window.g_pAddAsyncMethod !== -1) {
                try {
                    // Call GameMaker async method with board data
                    window.g_pAddAsyncMethod('board_data_received', boardJSON);
                    console.log('Board data sent to GameMaker successfully');
                } catch (e) {
                    console.error('Error calling GameMaker async method:', e);
                }
            } else {
                console.warn('GameMaker async method not ready yet');
            }
        };

        // GameMaker async method support
        window.g_pAddAsyncMethod = -1;
        window.setAddAsyncMethod = (asyncMethod: any) => {
            window.g_pAddAsyncMethod = asyncMethod;
            console.log("setAddAsyncMethod called with:", asyncMethod);
            
            // Send board data immediately after async method is registered
            if (boardData.length > 0) {
                setTimeout(() => {
                    if (window.sendBoardDataToGM) {
                        window.sendBoardDataToGM(boardData);
                    }
                }, 100);
            }
        };

        // Exception handling
        window.g_pJSExceptionHandler = undefined;
        window.setJSExceptionHandler = (exceptionHandler: any) => {
            if (typeof exceptionHandler === "function") {
                window.g_pJSExceptionHandler = exceptionHandler;
            }
        };

        window.hasJSExceptionHandler = () => {
            return window.g_pJSExceptionHandler !== undefined && typeof window.g_pJSExceptionHandler === "function";
        };

        window.doJSExceptionHandler = (exceptionJSON: string) => {
            if (typeof window.g_pJSExceptionHandler === "function") {
                const exception = JSON.parse(exceptionJSON);
                window.g_pJSExceptionHandler(exception);
            }
        };

        // WAD/Resource loading
        window.g_pWadLoadCallback = undefined;
        window.setWadLoadCallback = (wadLoadCallback: any) => {
            window.g_pWadLoadCallback = wadLoadCallback;
        };

        window.onFirstFrameRendered = () => {
            console.log("First frame rendered!");
        };

        // Ad system stubs
        window.triggerAd = (adId: string, ...callbacks: any[]) => {
            console.log("triggerAd called with adId:", adId);
            if (callbacks.length > 0 && typeof callbacks[0] === 'function') {
                setTimeout(() => callbacks[0](), 100);
            }
        };

        window.triggerPayment = (itemId: string, callback: any) => {
            console.log("triggerPayment called with itemId:", itemId);
            if (typeof callback === 'function') {
                setTimeout(() => callback({ id: itemId }), 1000);
            }
        };

        // UI utility functions
        window.toggleElement = (id: string) => {
            const elem = document.getElementById(id);
            if (elem) {
                elem.style.display = elem.style.display === 'block' ? 'none' : 'block';
            }
        };

        // Multiplayer/networking stubs
        const acceptableRollbackFramesRef = { value: 0 };
        window.set_acceptable_rollback = (frames: number) => {
            acceptableRollbackFramesRef.value = frames;
            console.log("Set acceptable rollback frames:", frames);
        };

        window.report_stats = (statsData: any) => {
            console.log("Game stats reported:", statsData);
        };

        window.log_next_game_state = () => {
            console.log("Game state logging requested");
        };

        window.wallpaper_update_config = (config: string) => {
            console.log("Wallpaper config update:", config);
        };

        window.wallpaper_reset_config = () => {
            console.log("Wallpaper config reset");
        };

        // Mock accelerometer API to prevent permissions policy violations
        if (!('DeviceMotionEvent' in window)) {
            (window as any).DeviceMotionEvent = class MockDeviceMotionEvent extends Event {
                constructor(type: string, eventInitDict?: any) {
                    super(type, eventInitDict);
                }
            };
        }

        if (!('DeviceOrientationEvent' in window)) {
            (window as any).DeviceOrientationEvent = class MockDeviceOrientationEvent extends Event {
                constructor(type: string, eventInitDict?: any) {
                    super(type, eventInitDict);
                }
            };
        }
    }, []);

    const loadRunnerManifest = useCallback(async (): Promise<void> => {
        try {
            const res = await fetch("/runner.json", {
                credentials: "include",
                cache: "no-cache"
            });
            if (!res.ok) throw new Error(`runner.json HTTP ${res.status}`);
            const manifest = (await res.json()) as RunnerManifest;

            if (!Array.isArray(manifest.manifestFiles) || !Array.isArray(manifest.manifestFilesMD5)) {
                throw new Error("runner.json missing arrays");
            }
            if (manifest.manifestFiles.length !== manifest.manifestFilesMD5.length) {
                console.warn("[runner.json] manifestFiles and manifestFilesMD5 length mismatch");
            }

            window.manifestFiles = () => manifest.manifestFiles.join(";");
            window.manifestFilesMD5 = () => manifest.manifestFilesMD5.slice();

        } catch (e) {
            console.warn("Falling back to hardcoded manifest (runner.json not available):", e);

            window.manifestFiles = () =>
                [
                    "runner.data",
                    "runner.js",
                    "runner.wasm",
                    "audio-worklet.js",
                    "game.unx"
                ].join(";");

            window.manifestFilesMD5 = () =>
                [
                    "585214623b669175a702fed30de7d21d",
                    "8669aa66d44cfb4f13a098cd6b0296e1",
                    "d29ac123833b56dcfbe188f10e5ecb85",
                    "e8f1e8db8cf996f8715a6f2164c2e44e",
                    "00a26996df3ce310bb5836ef7f4b0e3c"
                ];
        }
    }, []);

    const fetchInitialData = useCallback(async () => {
        try {
            const response = await fetch("/api/init");
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = (await response.json()) as InitResponse;
            if (data.type === "init") {
                console.log(`Game initialized for user: ${data.username}, post: ${data.postId}`);
            } else {
                console.error("Invalid response type from /api/init", data);
            }
        } catch (error) {
            console.error("Error fetching initial data:", error);
        }
    }, []);

    const setupModule = useCallback(() => {
        const canvas = canvasRef.current;
        if (!canvas) return;

        window.Module = {
            preRun: [],
            postRun: [],
            print: (text: string) => {
                console.log(text);
                if (text === "Entering main loop.") {
                    ensureAspectRatio();
                }
            },
            printErr: (text: string) => {
                console.error(text);
            },
            canvas: canvas,
            setStatus: (text: string) => {
                if (!window.Module.setStatus.last) {
                    window.Module.setStatus.last = { time: Date.now(), text: "" };
                }
                if (text === window.Module.setStatus.last.text) return;

                const m = text.match(/([^(]+)\((\d+(?:\.\d+)?)\/(\d+)\)/);
                const now = Date.now();
                if (m && now - window.Module.setStatus.last.time < 30) return;

                window.Module.setStatus.last.time = now;
                window.Module.setStatus.last.text = text;

                if (m) {
                    setProgressValue(parseInt(m[2]!, 10) * 100);
                    setProgressMax(parseInt(m[3]!, 10) * 100);
                    setProgressHidden(false);
                } else {
                    setProgressValue(0);
                    setProgressMax(100);
                    setProgressHidden(true);

                    if (!text) {
                        setIsLoading(false);
                        setCanvasActive(true);
                    }
                }
                setStatusText(text);
            },
            totalDependencies: 0,
            monitorRunDependencies: (left: number) => {
                window.Module.totalDependencies = Math.max(window.Module.totalDependencies, left);
                window.Module.setStatus(
                    left
                        ? `Preparing... (${window.Module.totalDependencies - left}/${window.Module.totalDependencies})`
                        : "All downloads complete."
                );
            },
        };

        window.Module.setStatus("Downloading...");

        window.onerror = () => {
            window.Module.setStatus("Exception thrown, see JavaScript console");
            window.Module.setStatus = (text: string) => {
                if (text) window.Module.printErr(`[post-exception status] ${text}`);
            };
        };

        if (typeof window === "object") {
            window.Module.arguments = window.location.search.substr(1).trim().split('&');
            if (!window.Module.arguments[0]) {
                window.Module.arguments = [];
            }
        }
    }, [ensureAspectRatio]);

    const loadGame = useCallback(async () => {
        try {
            await fetchInitialData();
            await loadRunnerManifest();
            setupGameMakerGlobals();

            const script = document.createElement('script');
            script.src = '/runner.js';
            script.async = true;
            script.type = 'text/javascript';

            script.onload = () => {
                console.log('Game script loaded successfully');
            };

            script.onerror = (error) => {
                console.error('Failed to load game script:', error);
                setStatusText('Failed to load game');
            };

            document.head.appendChild(script);
        } catch (error) {
            console.error('Error loading game:', error);
            setStatusText('Error loading game');
        }
    }, [fetchInitialData, loadRunnerManifest, setupGameMakerGlobals]);

    useEffect(() => {
        // Setup window size callback
        window.onGameSetWindowSize = (width: number, height: number) => {
            console.log(`Window size set to width: ${width}, height: ${height}`);
            startingDimensions.current = {
                width,
                height,
                aspect: width / height
            };
        };

        // Setup resize observer
        const resizeObserver = new ResizeObserver(() => {
            window.requestAnimationFrame(() => ensureAspectRatio());
            setTimeout(() => window.requestAnimationFrame(() => ensureAspectRatio()), 100);
        });
        resizeObserver.observe(document.body);

        // Mobile scrolling disabled
        if (/Android|iPhone|iPod/i.test(navigator.userAgent)) {
            document.body.classList.add("scrollingDisabled");
        }

        // Initialize game
        setupModule();
        loadGame();

        return () => {
            resizeObserver.disconnect();
        };
    }, [ensureAspectRatio, setupModule, loadGame, boardData]);

    const handleCanvasClick = () => {
        canvasRef.current?.focus();
    };

    return (
        <>
            <canvas
                ref={canvasRef}
                className={`
                    border-0 bg-black relative my-auto
                `}
                id="canvas"
                onContextMenu={(e) => e.preventDefault()}
                onClick={handleCanvasClick}
                tabIndex={-1}
                style={{ display: isLoading ? 'none' : 'block' }}
            />
            <div
                ref={loadingRef}
                className="absolute inset-0 flex flex-col justify-center items-center pointer-events-none"
                id="loading"
                style={{ display: isLoading ? 'flex' : 'none' }}
            >
                <div
                    ref={spinnerRef}
                    className="h-[30px] w-[30px] animate-[rotation_0.8s_linear_infinite] border-[5px] border-[#bdff00] border-t-[#719900] rounded-full m-2.5 p-2.5"
                    id="spinner"
                />
                <div
                    ref={statusRef}
                    className="inline-block align-top font-bold text-white m-2.5 p-2.5"
                    id="status"
                >
                    {statusText}
                </div>
                <progress
                    ref={progressRef}
                    value={progressValue}
                    max={progressMax}
                    id="progress"
                    hidden={progressHidden}
                    className="w-[250px] h-2.5 appearance-none p-1.25 m-2.5
                        [&::-webkit-progress-bar]:bg-[#8492a6] [&::-webkit-progress-bar]:h-2.5 [&::-webkit-progress-bar]:rounded-2xl
                        [&::-webkit-progress-value]:bg-gradient-to-r [&::-webkit-progress-value]:from-[#719900] [&::-webkit-progress-value]:to-[#bdff00] [&::-webkit-progress-value]:h-2.5 [&::-webkit-progress-value]:rounded-2xl"
                />
            </div>
        </>
    );
};

export default GameCanvas;
