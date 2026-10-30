export interface SoundModel {
  id: string;
  name: string;
  category: 'weather' | 'nature' | 'ambience';
  audioPath: string;
  iconName: string;
}

export interface SoundBookmarkItem {
  soundId: string;
  volume: number; // 0 - 100
}

export interface SoundBookmark {
  id: string;
  name: string;
  icon: string;
  sounds: SoundBookmarkItem[];
  globalVolume: number;
  isMuted: boolean;
  createdAt: string;
  updatedAt: string;
  isLastUsed?: boolean;
}

export interface BookmarkCollection {
  bookmarks: SoundBookmark[];
}

export const SOUNDS: SoundModel[] = [
  // Weather
  {
    id: 'light_rain',
    name: 'Light Rain',
    category: 'weather',
    audioPath: '/sounds/light-rain.mp3',
    iconName: 'CloudDrizzle',
  },
  {
    id: 'heavy_rain',
    name: 'Heavy Rain',
    category: 'weather',
    audioPath: '/sounds/rain.mp3',
    iconName: 'CloudRain',
  },
  {
    id: 'thunder',
    name: 'Thunder',
    category: 'weather',
    audioPath: '/sounds/thunder.mp3',
    iconName: 'CloudLightning',
  },
  {
    id: 'wind',
    name: 'Wind',
    category: 'weather',
    audioPath: '/sounds/wind.mp3',
    iconName: 'Wind',
  },
  {
    id: 'forest',
    name: 'Forest',
    category: 'weather',
    audioPath: '/sounds/forest.mp3',
    iconName: 'Trees',
  },

  // Nature
  {
    id: 'leaves',
    name: 'Leaves',
    category: 'nature',
    audioPath: '/sounds/leaves.m4a',
    iconName: 'Leaf',
  },
  {
    id: 'waves',
    name: 'Waves',
    category: 'nature',
    audioPath: '/sounds/waves.mp3',
    iconName: 'Waves',
  },
  {
    id: 'stream',
    name: 'Stream',
    category: 'nature',
    audioPath: '/sounds/flowing-water.mp3',
    iconName: 'Droplets',
  },
  {
    id: 'water_drops',
    name: 'Water Drops',
    category: 'nature',
    audioPath: '/sounds/water.mp3',
    iconName: 'Droplet',
  },

  // Ambience
  {
    id: 'fire',
    name: 'Fire',
    category: 'ambience',
    audioPath: '/sounds/fire.mp3',
    iconName: 'Flame',
  },
  {
    id: 'night',
    name: 'Night',
    category: 'ambience',
    audioPath: '/sounds/night-frog.mp3',
    iconName: 'Moon',
  },
  {
    id: 'cafe',
    name: 'Cafe',
    category: 'ambience',
    audioPath: '/sounds/coffee-shop.mp3',
    iconName: 'Coffee',
  },
  {
    id: 'train',
    name: 'Train',
    category: 'ambience',
    audioPath: '/sounds/train.mp3',
    iconName: 'Train',
  },
];
