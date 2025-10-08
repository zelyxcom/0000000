/** @type {import('next').NextConfig} */
const nextConfig = {
  outputFileTracingRoot: __dirname,
  allowedDevOrigins: [\"http://192.168.1.101:3000\"]
}
module.exports = nextConfig
