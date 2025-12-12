-- Add media_bucket to community_posts to allow referencing media from different storage buckets
-- This enables sharing library media in Community without re-uploading.

BEGIN;

-- Add the column if it does not exist
ALTER TABLE public.community_posts
  ADD COLUMN IF NOT EXISTS media_bucket TEXT;

-- Set a sensible default for new rows created from Community uploads
ALTER TABLE public.community_posts
  ALTER COLUMN media_bucket SET DEFAULT 'community-media';

-- Backfill existing rows to the default bucket when NULL
UPDATE public.community_posts
  SET media_bucket = 'community-media'
  WHERE media_bucket IS NULL;

COMMIT;
