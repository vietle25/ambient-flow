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
    sm: 'text-lg',
    md: 'text-xl',
    lg: 'text-2xl',
  };

  const subtextSizes = {
    sm: 'text-[8px] tracking-[2.5px]',
    md: 'text-[9px] tracking-[3px]',
    lg: 'text-[11px] tracking-[4px]',
  };

  return (
    <div className={`flex items-center gap-3 select-none group cursor-pointer ${className}`}>
      {/* Icon: The Floum Wave / Fluid F */}
      <div className={`relative ${iconSizes[size]} flex items-center justify-center shrink-0`}>
        {/* Soft Radial Ambient Glow */}
        <div className="absolute inset-0 rounded-2xl bg-gradient-to-tr from-sky-500/25 via-indigo-500/35 to-pink-500/30 blur-md group-hover:scale-110 transition-transform duration-300" />

        {/* Squircle Glass Container */}
        <div className="relative w-full h-full rounded-2xl bg-[#0B0F19]/90 border border-indigo-500/30 group-hover:border-indigo-400/50 shadow-inner flex items-center justify-center transition-all duration-300">
          <svg
            viewBox="0 0 48 48"
            fill="none"
            className="w-[74%] h-[74%] overflow-visible"
            xmlns="http://www.w3.org/2000/svg"
          >
            <defs>
              <linearGradient id="floumGradient" x1="12" y1="14" x2="38" y2="36" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#38BDF8" />
                <stop offset="45%" stopColor="#818CF8" />
                <stop offset="80%" stopColor="#C084FC" />
                <stop offset="100%" stopColor="#F472B6" />
              </linearGradient>
              <filter id="floumGlow" x="-20%" y="-20%" width="140%" height="140%">
                <feGaussianBlur stdDeviation="2" result="glow" />
                <feComposite in="SourceGraphic" in2="glow" operator="over" />
              </filter>
            </defs>

            {/* Orbit Ambient Ring */}
            <circle
              cx="24"
              cy="24"
              r="17"
              stroke="#818CF8"
              strokeWidth="1.2"
              strokeDasharray="3 4"
              className="opacity-40 group-hover:opacity-65 transition-opacity"
            />

            {/* Fluid 'F' Flow Ribbon */}
            <path
              d="M 14 36 C 14 26, 17 14, 26 14 C 33 14, 37 18, 35 22 C 33 26, 23 25, 20 26 C 18 26.5, 17 28.5, 18 31 C 21 37, 34 35, 37 31"
              stroke="url(#floumGradient)"
              strokeWidth="3.6"
              strokeLinecap="round"
              strokeLinejoin="round"
              fill="none"
              filter="url(#floumGlow)"
              className="group-hover:stroke-width-[4] transition-all duration-300"
            />

            {/* Radiant harmonic nodes */}
            <circle cx="31" cy="22" r="2.2" fill="#38BDF8" />
            <circle cx="23" cy="26" r="2.8" fill="#F472B6" className="animate-pulse" />
          </svg>
        </div>
      </div>

      {/* Typography: floum */}
      <div className="flex flex-col leading-tight">
        <span className={`${textSizes[size]} font-extrabold tracking-tight text-white flex items-center`}>
          floum
          <span className="w-1.5 h-1.5 rounded-full bg-pink-500 ml-1 mt-1 animate-pulse" />
        </span>
        <span className={`${subtextSizes[size]} uppercase font-semibold text-indigo-300/60 -mt-0.5`}>
          Focus &amp; Calm
        </span>
      </div>
    </div>
  );
};
