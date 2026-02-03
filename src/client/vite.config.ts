import { defineConfig, Plugin } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import path from "path";
import fs from "fs";

// Custom plugin to copy public files with error handling for locked files
function copyPublicWithRetry(): Plugin {
  return {
    name: "copy-public-with-retry",
    writeBundle: {
      sequential: true,
      async handler() {
        const publicDir = path.resolve(__dirname, "public");
        const outDir = path.resolve(__dirname, "../../dist/client");

        if (!fs.existsSync(publicDir)) return;

        const copyRecursive = async (src: string, dest: string) => {
          const stat = fs.statSync(src);
          if (stat.isDirectory()) {
            if (!fs.existsSync(dest)) {
              fs.mkdirSync(dest, { recursive: true });
            }
            for (const file of fs.readdirSync(src)) {
              await copyRecursive(path.join(src, file), path.join(dest, file));
            }
          } else {
            try {
              // Skip if destination exists and is the same size (likely locked but unchanged)
              if (fs.existsSync(dest)) {
                const srcStat = fs.statSync(src);
                const destStat = fs.statSync(dest);
                if (srcStat.size === destStat.size && srcStat.mtime <= destStat.mtime) {
                  return; // Skip - file is unchanged
                }
              }
              fs.copyFileSync(src, dest);
            } catch (err: any) {
              if (err.code === "EBUSY" || err.code === "EPERM") {
                console.warn(`[vite] Skipping locked file: ${path.basename(src)}`);
              } else {
                throw err;
              }
            }
          }
        };

        await copyRecursive(publicDir, outDir);
      },
    },
  };
}

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss(), copyPublicWithRetry()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
      "@shared": path.resolve(__dirname, "../shared"),
    },
  },
  build: {
    outDir: "../../dist/client",
    copyPublicDir: false, // Disable default public copy - our plugin handles it
    rollupOptions: {
      input: {
        splash: "splash.html",
        game: "index.html",
      },
      output: {
        entryFileNames: "[name].js",
        chunkFileNames: "[name].js",
        assetFileNames: "[name][extname]",
        sourcemapFileNames: "[name].js.map",
      },
    },
  },
});
