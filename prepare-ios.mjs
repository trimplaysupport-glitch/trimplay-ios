import { cp, mkdir, mkdtemp, rm } from 'node:fs/promises';
import { existsSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { resolve, join } from 'node:path';

// Only explicit iOS packaging stages dist; regular hosted builds stay unchanged.
const root = resolve(import.meta.dirname, '..');
const dist = join(root, 'dist');
const staging = await mkdtemp(join(tmpdir(), 'trimplay-ios-'));
try {
  const client = join(dist, 'client');
  if (existsSync(client)) await cp(client, staging, { recursive: true });
  await cp(join(root, 'native/index.html'), join(staging, 'index.html'));
  // A Capacitor webDir must contain browser assets, never server code/secrets.
  await rm(dist, { recursive: true, force: true });
  await mkdir(dist, { recursive: true });
  await cp(staging, dist, { recursive: true });
} finally {
  await rm(staging, { recursive: true, force: true });
}