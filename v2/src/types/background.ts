export type BackgroundType = 'gradient' | 'image' | 'video';

export interface BackgroundItem {
  id: string;
  name: string;
  type: BackgroundType;
  category: 'gradient' | 'rain' | 'nature' | 'cozy' | 'night';
  value: string; // URL for image/video or gradient string / ID
  thumbnail: string; // preview image URL
  description?: string;
}

export const BACKGROUND_PRESETS: BackgroundItem[] = [
  // 1. Dynamic Gradients
  {
    id: 'gradient-ambient-flow',
    name: 'Dynamic Ambient Glow',
    type: 'gradient',
    category: 'gradient',
    value: 'dynamic',
    thumbnail: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=300&q=80&auto=format&fit=crop',
    description: 'Chuyển đổi mượt mà giữa các dải màu thư giãn'
  },

  // 2. Chill Videos
  {
    id: 'video-rain-window',
    name: 'Mưa đêm bên cửa sổ',
    type: 'video',
    category: 'rain',
    value: '/videos/rain-window.mp4',
    thumbnail: 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=300&q=80&auto=format&fit=crop',
    description: 'Từng giọt mưa đọng trên ô kính đêm êm đềm'
  },
  {
    id: 'video-fireplace',
    name: 'Lò sưởi ấm cúng',
    type: 'video',
    category: 'cozy',
    value: '/videos/fireplace.mp4',
    thumbnail: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=300&q=80&auto=format&fit=crop',
    description: 'Ánh lửa bập bùng xua tan mọi mệt mỏi'
  },
  {
    id: 'video-ocean-waves',
    name: 'Sóng biển hoàng hôn',
    type: 'video',
    category: 'nature',
    value: '/videos/ocean-waves.mp4',
    thumbnail: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=300&q=80&auto=format&fit=crop',
    description: 'Sóng vỗ bờ cát nhẹ nhàng lúc hoàng hôn'
  },

  // 3. Relaxing Photos
  {
    id: 'photo-night-rain',
    name: 'Đêm mưa thành phố',
    type: 'image',
    category: 'rain',
    value: 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?q=85&w=1920&auto=format&fit=crop',
    thumbnail: 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=300&q=80&auto=format&fit=crop',
    description: 'Mưa rơi tí tách qua lăng kính ánh đèn đêm'
  },
  {
    id: 'photo-starry-night',
    name: 'Bầu trời đầy sao',
    type: 'image',
    category: 'night',
    value: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=85&w=1920&auto=format&fit=crop',
    thumbnail: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=300&q=80&auto=format&fit=crop',
    description: 'Dải ngân hà tĩnh lặng phía trên đỉnh núi tuyết'
  },
  {
    id: 'photo-misty-forest',
    name: 'Rừng thông mờ sương',
    type: 'image',
    category: 'nature',
    value: 'https://images.unsplash.com/photo-1448375240586-882707db888b?q=85&w=1920&auto=format&fit=crop',
    thumbnail: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=300&q=80&auto=format&fit=crop',
    description: 'Không gian tĩnh mịch của rừng thông sớm mai'
  },
  {
    id: 'photo-cozy-cafe',
    name: 'Góc quán Cafe ấm áp',
    type: 'image',
    category: 'cozy',
    value: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=85&w=1920&auto=format&fit=crop',
    thumbnail: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=300&q=80&auto=format&fit=crop',
    description: 'Hương cà phê ấm nồng giữa tiết trời se lạnh'
  },
  {
    id: 'photo-beach-sunset',
    name: 'Bờ biển chiều tà',
    type: 'image',
    category: 'nature',
    value: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=85&w=1920&auto=format&fit=crop',
    thumbnail: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=300&q=80&auto=format&fit=crop',
    description: 'Ánh chiều tà êm dịu hòa cùng sóng vỗ'
  },
  {
    id: 'photo-tokyo-night',
    name: 'Tokyo mưa đêm Neon',
    type: 'image',
    category: 'night',
    value: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?q=85&w=1920&auto=format&fit=crop',
    thumbnail: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=300&q=80&auto=format&fit=crop',
    description: 'Ánh đèn neon lung linh phản chiếu trên mặt phố ướt'
  },
  {
    id: 'photo-campfire',
    name: 'Lửa trại đêm đông',
    type: 'image',
    category: 'cozy',
    value: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=85&w=1920&auto=format&fit=crop',
    thumbnail: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=300&q=80&auto=format&fit=crop',
    description: 'Đốm lửa sưởi ấm tâm hồn trong đêm lạnh'
  }
];
