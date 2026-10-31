import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Ambient Flow - Perfect Ambient Soundscapes',
  description: 'Create your perfect ambient soundscape for focus, relaxation, and productivity.',
  icons: {
    icon: '/v2/favicon.svg',
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
