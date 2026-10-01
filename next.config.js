/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  experimental: {
    serverActions: true
  },
  async rewrites() {
    return [
      {
        source: '/auth/v1/:path*',
        destination: 'http://gateway:80/auth/v1/:path*'
      },
      {
        source: '/rest/v1/:path*',
        destination: 'http://gateway:80/rest/v1/:path*'
      }
    ]
  },
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**.githubusercontent.com'
      }
    ]
  }
}
