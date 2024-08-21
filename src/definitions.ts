export interface VideoRecorderPlugin {
  recordVideo(): Promise<{ videoUri?: string; videoUrl?: string }>;
}