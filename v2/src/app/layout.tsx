import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Floum - Focus & Calm Soundscapes',
  description: 'Create your perfect ambient soundscape for focus, sleep, and relaxation.',
  icons: {
    icon: '/favicon.svg',
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased bg-[#1E293B] text-white min-h-screen selection:bg-white/20">
        {children}
      </body>
    </html>
  );
}
