import { WebPlugin } from '@capacitor/core';

import type { VideoRecorderPlugin } from './definitions';

export class VideoRecorderWeb extends WebPlugin implements VideoRecorderPlugin {
  async recordVideo(): Promise<{ videoUri: string; videoUrl?: string }> {
    console.log('recordVideo is not implemented for the web');
    throw new Error('Video recording is not supported on the web.');
  }
}
