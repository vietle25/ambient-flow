import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  basePath: "/v2",
  turbopack: {
    rules: {
      "*.css": {
        loaders: ["@tailwindcss/turbopack"],
        as: "*.css",
      },
    },
  },
  images: {
    unoptimized: true,
  },
};

export default nextConfig;
