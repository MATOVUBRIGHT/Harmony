# Community Feature Documentation

## Overview

The Community feature is a TikTok-like social platform integrated into the Harmony School Portal, allowing users to share videos and photos, interact with content through likes and comments, and manage their personal library with privacy controls.

## Features

### 1. Community Feed (`/community`)
- **Public Feed**: Browse all public posts from community members
- **Post Cards**: TikTok-style card layout with video/image thumbnails
- **Interactions**:
  - Like posts (with heart animation)
  - Comment on posts (public comments on public posts)
  - Share posts (copy share link to clipboard)
  - View counts and timestamps
- **Upload**: Create new posts with videos or photos
- **User Profiles**: Click on usernames to view public profiles

### 2. Post Privacy & Security

#### Public Posts
- Visible to all authenticated users in the community feed
- Can receive comments and likes from any user
- View count is tracked

#### Private Posts
- Only visible to the post owner
- Cannot be viewed by other users
- Optional password protection for additional security

#### Password-Protected Posts
- Private posts can be further secured with a password
- Owner sets password during upload
- Others cannot access without the correct password
- Password is hashed for security (base64 encoding, upgrade to bcrypt recommended)

### 3. User Profile (`/profile`)
- **Personal Library**: View all personal posts (public and private)
- **Statistics**:
  - Total posts count
  - Public vs private posts breakdown
  - Total views across all posts
- **Post Management**: Delete personal posts
- **Profile Information**: Display user name and avatar

### 4. Public User Profile (`/community/:userId`)
- **View Public Posts**: See all public posts from a specific user
- **User Statistics**: Public view counts, likes, and engagement metrics
- **Interaction**: Like and comment on public posts from user's profile
- **Navigation**: Accessible by clicking on a username in the community feed

### 5. Media Upload

#### Supported Formats
- **Videos**: mp4, webm, mov, avi
- **Images**: jpg, jpeg, png, gif, webp

#### Size Limits
- Videos: up to 100MB
- Images: up to 10MB

#### Upload Options
- **Title** (required): Name your post
- **Description** (optional): Add details about your post
- **Privacy Settings**:
  - Public/Private toggle
  - Password protection (for private posts only)

### 6. Comments & Engagement

#### Comment Features
- Comment on any public post
- View all comments on a post
- Delete your own comments
- Real-time comment count
- User information displayed with each comment

#### Likes & Views
- Like/unlike posts instantly
- Like count displayed on post cards
- View count tracks total impressions
- Share count for tracking shares

## Database Schema

### Tables

#### `community_posts`
```sql
- id (UUID, Primary Key)
- user_id (UUID, Foreign Key → auth.users)
- title (TEXT)
- description (TEXT, nullable)
- media_url (TEXT) - Supabase Storage URL
- media_type (TEXT) - 'video' or 'image'
- is_public (BOOLEAN) - Default: false
- password_protected (BOOLEAN) - Default: false
- access_password (TEXT, nullable) - Hashed password
- view_count (INTEGER) - Default: 0
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

#### `community_comments`
```sql
- id (UUID, Primary Key)
- post_id (UUID, Foreign Key → community_posts)
- user_id (UUID, Foreign Key → auth.users)
- content (TEXT)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

#### `community_likes`
```sql
- id (UUID, Primary Key)
- post_id (UUID, Foreign Key → community_posts)
- user_id (UUID, Foreign Key → auth.users)
- created_at (TIMESTAMP)
- Unique constraint: (post_id, user_id)
```

#### `community_shares`
```sql
- id (UUID, Primary Key)
- post_id (UUID, Foreign Key → community_posts)
- user_id (UUID, Foreign Key → auth.users)
- created_at (TIMESTAMP)
```

## File Structure

```
src/
├── pages/
│   ├── Community.tsx          # Main community feed
│   ├── UserProfile.tsx        # User's private library
│   └── PublicProfile.tsx      # Public user profile
├── hooks/
│   └── useCommunityPosts.ts   # Community posts management hook
└── integrations/
    └── supabase/
        ├── types.ts           # Updated with community tables
        └── client.ts          # Supabase client
```

## Migration File

Database migrations are in:
```
supabase/migrations/20251212_community_feature.sql
```

This includes:
- Table creation
- Row Level Security (RLS) policies
- Index creation for performance optimization

## Row Level Security (RLS) Policies

### community_posts
- **SELECT**: Users can view public posts and their own posts
- **INSERT**: Users can only insert their own posts
- **UPDATE**: Users can only update their own posts
- **DELETE**: Users can only delete their own posts

### community_comments
- **SELECT**: Users can view comments on public posts or posts they own
- **INSERT**: Users can comment on public posts or posts they own
- **DELETE**: Users can only delete their own comments

### community_likes & community_shares
- **SELECT**: Public access to view all likes and shares
- **INSERT**: Users can only like/share from their own account
- **DELETE**: Users can only delete their own likes/shares

## API Integration

### Key Endpoints (via Supabase Realtime)

1. **Fetch Posts**
   - Get public posts and user's private posts
   - Fetch user profile data
   - Get post interactions (likes, comments)

2. **Create Post**
   - Upload media to Supabase Storage
   - Insert post record with metadata
   - Handle privacy and password settings

3. **Manage Comments**
   - Load comments for a post
   - Add new comments
   - Delete user's comments

4. **Manage Likes**
   - Toggle like on a post
   - Fetch like count

5. **Share Post**
   - Generate shareable link
   - Track shares

## Navigation Integration

### Sidebar
- New "Community" menu item with lightning bolt icon
- Links to `/community` route

### User Menu
- "My Profile" link in sidebar user section
- Links to `/profile` route

## Usage Guide

### For Users

#### Posting Content
1. Go to Community page
2. Click "Post Video/Photo" button
3. Select media file (video or image)
4. Add title (required) and description
5. Choose privacy settings:
   - **Public**: Visible to all in community feed
   - **Private**: Only visible to you
   - **Password Protected**: Add password for additional security
6. Click "Post to Community"

#### Browsing Community
1. Go to Community page
2. View public posts in feed
3. Click on usernames to see their public profile
4. Like, comment, and share posts

#### Managing Your Library
1. Go to "My Profile" from sidebar
2. View all your posts (public and private)
3. See statistics (views, engagement)
4. Delete posts as needed

#### Viewing User Profiles
1. Click on any username in the community feed
2. View their public posts and statistics
3. Like and comment on public posts

## Security Considerations

### Current Implementation
- Basic base64 password encoding for protected videos
- RLS policies prevent unauthorized access
- User can only manage their own content

### Recommended Improvements
- **Password Hashing**: Upgrade to bcrypt for password-protected posts
- **Rate Limiting**: Implement rate limiting on uploads and comments
- **Content Moderation**: Add content filtering and flagging system
- **Image Processing**: Compress and optimize uploaded images
- **Video Transcoding**: Transcode videos to multiple qualities

## Performance Optimizations

### Database Indexes
- `idx_community_posts_user_id`: Fast user post lookup
- `idx_community_posts_is_public`: Fast public post filtering
- `idx_community_posts_created_at`: Fast chronological sorting
- `idx_community_comments_post_id`: Fast comment lookup
- `idx_community_likes_post_id`: Fast like count calculation
- `idx_community_shares_post_id`: Fast share tracking

### Caching
- Implement query caching for public posts
- Cache user profiles
- Cache post statistics

### Pagination
- Implement infinite scroll or pagination for feed
- Load posts in batches (50-100 per request)
- Lazy load comments

## Future Enhancements

1. **Video Streaming**
   - Multi-quality video delivery
   - Adaptive bitrate streaming
   - Video thumbnails/previews

2. **Notifications**
   - Comment notifications
   - Like notifications
   - Follow system

3. **Advanced Interactions**
   - Repost/share functionality
   - Bookmark favorites
   - Follow users
   - Mentions and tags

4. **Search & Discovery**
   - Full-text search on titles and descriptions
   - Hashtag support
   - Trending posts
   - Recommendations

5. **Moderation**
   - Report inappropriate content
   - User blocking
   - Content moderation queue
   - Admin review tools

6. **Analytics**
   - Detailed view analytics
   - Engagement metrics
   - Trending insights

## Troubleshooting

### Posts Not Showing
- Check RLS policies are enabled
- Verify user has correct permissions
- Check post `is_public` flag for private posts

### Password Protected Posts Not Working
- Verify password is set during creation
- Check password encoding matches on verification
- Ensure `access_password` field is populated

### Comments Not Loading
- Verify post exists
- Check user has permission to view post
- Check comment RLS policies

### Upload Failures
- Check file size limits
- Verify file format is supported
- Ensure Supabase Storage bucket exists
- Check storage permissions

## Support

For issues or questions about the Community feature, contact the development team or check the project documentation.
