// Concept components for previewing
export const LogoConcept1 = () => (
  /* Concept 1: Minimalist Soundwave Ripple */
  <div className="flex items-center gap-3">
    <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-cyan-500 via-sky-400 to-indigo-500 p-0.5 shadow-lg shadow-sky-500/20">
      <div className="w-full h-full bg-slate-950/80 backdrop-blur-sm rounded-[14px] flex items-center justify-center gap-0.5">
        <span className="w-1 h-3 bg-cyan-400 rounded-full animate-pulse" />
        <span className="w-1 h-5 bg-sky-300 rounded-full animate-pulse delay-75" />
        <span className="w-1 h-6 bg-white rounded-full animate-pulse delay-150" />
        <span className="w-1 h-4 bg-indigo-300 rounded-full animate-pulse delay-100" />
        <span className="w-1 h-2 bg-indigo-400 rounded-full animate-pulse delay-200" />
      </div>
    </div>
    <div className="flex flex-col">
      <span className="text-lg font-bold tracking-tight bg-gradient-to-r from-white via-white to-sky-200 bg-clip-text text-transparent">
        Ambient<span className="text-sky-400 font-light ml-1">Flow</span>
      </span>
      <span className="text-[9px] uppercase tracking-widest text-white/40 -mt-1 font-medium">Soundscapes</span>
    </div>
  </div>
);

export const LogoConcept2 = () => (
  /* Concept 2: Flowing Infinity Aura */
  <div className="flex items-center gap-3">
    <div className="relative w-10 h-10 flex items-center justify-center">
      <div className="absolute inset-0 rounded-2xl bg-gradient-to-br from-indigo-500/40 via-purple-500/30 to-pink-500/40 blur-sm" />
      <div className="relative w-9 h-9 rounded-xl bg-slate-900 border border-white/20 flex items-center justify-center shadow-inner">
        <svg viewBox="0 0 24 24" fill="none" className="w-5 h-5 text-purple-300" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm0 18a8 8 0 1 1 8-8 8 8 0 0 1-8 8z" opacity="0.3"/>
          <path d="M2 12c2.5-4 5.5-4 8 0s5.5 4 8 0" stroke="url(#flowGrad)" strokeWidth="2.5" />
          <defs>
            <linearGradient id="flowGrad" x1="2" y1="12" x2="18" y2="12" gradientUnits="userSpaceOnUse">
              <stop stopColor="#38bdf8" />
              <stop offset="0.5" stopColor="#a855f7" />
              <stop offset="1" stopColor="#ec4899" />
            </linearGradient>
          </defs>
        </svg>
      </div>
    </div>
    <div className="flex flex-col">
      <span className="text-lg font-extrabold tracking-tight text-white flex items-center">
        Ambient<span className="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent ml-1">Flow</span>
      </span>
      <span className="text-[9px] uppercase tracking-widest text-purple-300/50 -mt-1 font-medium">Focus & Calm</span>
    </div>
  </div>
);

export const LogoConcept3 = () => (
  /* Concept 3: Zen Breath / Nature Pebble */
  <div className="flex items-center gap-3">
    <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-emerald-500/30 via-teal-400/20 to-sky-400/30 border border-teal-400/40 flex items-center justify-center shadow-lg shadow-teal-500/10">
      <svg viewBox="0 0 24 24" fill="none" className="w-5 h-5 text-teal-300" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 3c-4.97 0-9 4.03-9 9 0 3.86 2.45 7.15 5.88 8.38" />
        <path d="M12 3c4.97 0 9 4.03 9 9 0 3.86-2.45 7.15-5.88 8.38" />
        <circle cx="12" cy="12" r="3" fill="currentColor" fillOpacity="0.4" />
      </svg>
    </div>
    <div className="flex flex-col">
      <span className="text-lg font-medium tracking-wide text-white">
        ambient<span className="text-teal-400 font-semibold">flow</span>
      </span>
      <span className="text-[9px] uppercase tracking-widest text-teal-300/50 -mt-1 font-light">Breathe & Listen</span>
    </div>
  </div>
);

export const LogoConcept4 = () => (
  /* Concept 4: Modern Typographic Monogram */
  <div className="flex items-center gap-3">
    <div className="w-10 h-10 rounded-2xl bg-white/10 border border-white/20 flex items-center justify-center text-white font-black text-xl tracking-tighter backdrop-blur-md shadow-lg">
      <span className="bg-gradient-to-br from-white via-sky-200 to-blue-400 bg-clip-text text-transparent">AF</span>
    </div>
    <div className="flex flex-col">
      <span className="text-lg font-black tracking-widest uppercase bg-gradient-to-r from-white to-white/70 bg-clip-text text-transparent">
        AMBIENT<span className="text-sky-400">FLOW</span>
      </span>
      <span className="text-[9px] uppercase tracking-widest text-white/40 -mt-1 font-medium">Sonic Sanctuary</span>
    </div>
  </div>
);
