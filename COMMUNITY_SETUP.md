# Community Feature - Setup Guide

## Quick Start

### 1. Database Setup

The community feature requires new tables to be created in your Supabase database.

**Migration File**: `supabase/migrations/20251212_community_feature.sql`

To apply the migration:

```bash
# Using Supabase CLI
supabase migration up

# Or manually run the SQL file in Supabase dashboard
# Navigate to SQL Editor > Run the migration file
```

This creates:
- `community_posts` - Stores user posts with media
- `community_comments` - Stores comments on posts
- `community_likes` - Stores like reactions
- `community_shares` - Tracks post shares

### 2. Storage Setup

Create a new Supabase Storage bucket for community media:

1. Go to Supabase Dashboard → Storage
2. Create a new bucket named `community-media`
3. Set the bucket to private (we'll handle auth via RLS)
4. Create a policy allowing authenticated users to:
   - Upload to `${uid}/*` (their user ID folder)
   - Read their own and public media

**RLS Policy for Storage**:
```sql
-- Allow users to upload to their own folder
CREATE POLICY "Users can upload to their folder" ON storage.objects
FOR INSERT
WITH CHECK (bucket_id = 'community-media' AND (storage.foldername(name))[1] = auth.uid()::text);

-- Allow users to read public content
CREATE POLICY "Anyone can read public content" ON storage.objects
FOR SELECT
USING (bucket_id = 'community-media');
```

### 3. Environment Variables

Ensure these environment variables are set in your `.env` file:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_PUBLISHABLE_KEY=your_supabase_publishable_key
```

### 4. Restart Development Server

After migrations are applied, restart your development server:

```bash
npm run dev
```

## File Structure

### New Files Created

```
src/pages/
├── Community.tsx                    # Main community feed (TikTok-like)
├── UserProfile.tsx                 # User's personal library
└── PublicProfile.tsx               # Public user profile view

src/hooks/
├── useCommunityPosts.ts            # Posts management
└── useCommunityInteractions.ts     # Interactions (likes, comments, shares)

supabase/migrations/
└── 20251212_community_feature.sql  # Database schema

COMMUNITY_FEATURE.md                # Full documentation
```

### Modified Files

```
src/App.tsx                         # Added routes for Community pages
src/components/Sidebar.tsx          # Added Community nav item and Profile link
src/integrations/supabase/types.ts  # Updated types with community tables
```

## Feature Access

### Navigation

1. **Community Feed**
   - Sidebar → "Community" (lightning bolt icon)
   - Route: `/community`

2. **User Profile**
   - Sidebar → User section → "My Profile"
   - Route: `/profile`

3. **Public User Profiles**
   - Click any username in community feed
   - Route: `/community/:userId`

## Testing the Feature

### Test Case 1: Create a Post

1. Go to Community page
2. Click "Post Video/Photo"
3. Upload a test video or image
4. Add title and description
5. Choose privacy settings (Public/Private)
6. Optionally add password protection
7. Click "Post to Community"
8. Verify post appears in feed

### Test Case 2: Browse and Interact

1. View public posts in feed
2. Like a post
3. Add a comment
4. Click "Share" to copy share link
5. Click username to view public profile

### Test Case 3: Manage Library

1. Go to "My Profile"
2. View all posts (public and private)
3. Check statistics
4. Delete a post

### Test Case 4: Password Protection

1. Create a private post with password
2. Try to access from different account (should fail)
3. Verify only owner can see password-protected content

## Troubleshooting

### Posts Not Showing
**Solution**: 
- Check migration was applied: `SELECT * FROM community_posts;`
- Verify RLS policies are enabled
- Check `is_public` flag is correct

### Upload Fails
**Solution**:
- Verify `community-media` storage bucket exists
- Check file size limits (100MB videos, 10MB images)
- Verify storage RLS policies are set correctly

### Comments Not Loading
**Solution**:
- Check `community_comments` table exists
- Verify post ID is valid
- Check user has permission to view post

### Buttons Not Responding
**Solution**:
- Check browser console for errors
- Verify Supabase connection is active
- Ensure user is authenticated

## Performance Optimization

For production deployment:

1. **Enable CDN** for storage bucket
2. **Optimize images** - add image compression
3. **Implement pagination** - load posts in batches
4. **Cache user profiles** - implement caching layer
5. **Use video thumbnails** - generate thumbnails for videos
6. **Upgrade password hashing** - from base64 to bcrypt

See `COMMUNITY_FEATURE.md` for detailed recommendations.

## Security Checklist

- [ ] Migrate database tables
- [ ] Set up storage bucket and policies
- [ ] Test RLS policies are working
- [ ] Verify users can only access their own content
- [ ] Test password protection works
- [ ] Enable rate limiting (recommended)
- [ ] Add content moderation (recommended)

## Support

For issues:
1. Check the troubleshooting section above
2. Review `COMMUNITY_FEATURE.md` for detailed docs
3. Check browser console for error messages
4. Verify Supabase connection and permissions

## Next Steps

After setup is complete:

1. Test all features thoroughly
2. Deploy to production environment
3. Monitor performance and storage usage
4. Gather user feedback
5. Implement additional features from roadmap

Recommended enhancements:
- Follow system
- Hashtag support
- Video streaming optimization
- Notifications system
- Advanced search and discovery
