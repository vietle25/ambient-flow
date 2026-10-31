import React from 'react';

interface LogoProps {
  className?: string;
  size?: 'sm' | 'md' | 'lg';
}

export const AppLogo: React.FC<LogoProps> = ({ className = '', size = 'md' }) => {
  const iconSizes = {
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-12 h-12',
  };

  const textSizes = {
    sm: 'text-base',
    md: 'text-lg',
    lg: 'text-2xl',
  };

  const subtextSizes = {
    sm: 'text-[8px] tracking-[2.5px]',
    md: 'text-[9px] tracking-[3px]',
    lg: 'text-[11px] tracking-[4px]',
  };

  return (
    <div className={`flex items-center gap-3 select-none group cursor-pointer ${className}`}>
      {/* Icon: Flowing Infinity Wave */}
      <div className={`relative ${iconSizes[size]} flex items-center justify-center shrink-0`}>
        {/* Soft Radial Ambient Glow */}
        <div className="absolute inset-0 rounded-2xl bg-gradient-to-tr from-sky-500/25 via-purple-500/35 to-pink-500/30 blur-md group-hover:scale-110 transition-transform duration-300" />

        {/* Squircle Glass Container */}
        <div className="relative w-full h-full rounded-2xl bg-[#0F1424]/90 border border-purple-500/30 group-hover:border-purple-400/50 shadow-inner flex items-center justify-center transition-all duration-300">
          <svg
            viewBox="0 0 48 48"
            fill="none"
            className="w-[72%] h-[72%] overflow-visible"
            xmlns="http://www.w3.org/2000/svg"
          >
            <defs>
              <linearGradient id="infinityWaveGrad" x1="4" y1="24" x2="44" y2="24" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#38BDF8" />
                <stop offset="50%" stopColor="#C084FC" />
                <stop offset="100%" stopColor="#F472B6" />
              </linearGradient>
              <filter id="waveGlow" x="-20%" y="-20%" width="140%" height="140%">
                <feGaussianBlur stdDeviation="2" result="glow" />
                <feComposite in="SourceGraphic" in2="glow" operator="over" />
              </filter>
            </defs>

            {/* Orbit Ambient Ring */}
            <circle
              cx="24"
              cy="24"
              r="17"
              stroke="#A855F7"
              strokeWidth="1.2"
              strokeDasharray="3 4"
              className="opacity-40 group-hover:opacity-60 transition-opacity"
            />

            {/* Flowing Sine / Infinity Wave */}
            <path
              d="M 6 24 Q 15 11, 24 24 T 42 24"
              stroke="url(#infinityWaveGrad)"
              strokeWidth="3.6"
              strokeLinecap="round"
              fill="none"
              filter="url(#waveGlow)"
              className="group-hover:stroke-width-[4] transition-all duration-300"
            />

            {/* Radiant Center Harmonic Node */}
            <circle cx="24" cy="24" r="3.2" fill="#F472B6" className="animate-pulse" />
          </svg>
        </div>
      </div>

      {/* Typography */}
      <div className="flex flex-col leading-tight">
        <span className={`${textSizes[size]} font-extrabold tracking-tight text-white flex items-center`}>
          Ambient
          <span className="ml-1 bg-gradient-to-r from-purple-400 via-pink-400 to-rose-400 bg-clip-text text-transparent">
            Flow
          </span>
        </span>
        <span className={`${subtextSizes[size]} uppercase font-semibold text-purple-300/60 -mt-0.5`}>
          Focus &amp; Calm
        </span>
      </div>
    </div>
  );
};
