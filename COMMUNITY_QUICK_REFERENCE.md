# Community Feature - Quick Reference

## 🚀 What's New

A complete community feature has been added to Harmony School Portal, allowing users to share videos and photos with TikTok-like interactions.

## 📍 Where to Find It

### In the App
1. **Community Feed**: Sidebar → "Community" (Lightning Icon)
2. **My Profile**: Sidebar → User Section → "My Profile"
3. **Other Profiles**: Click any username in the community feed

## 🎬 How to Use

### Create a Post
1. Go to Community
2. Click "Post Video/Photo"
3. Choose video or image
4. Add title (required)
5. Add description (optional)
6. Choose privacy:
   - **Public**: Everyone in community sees it
   - **Private**: Only you see it
   - **Password Protected**: Private with password lock
7. Click "Post to Community"

### Browse Community
- View all public posts in the feed
- Like posts (heart icon)
- Add comments (chat icon)
- Share posts (share icon)
- Click username to view their public profile

### Manage Your Library
- Go to "My Profile"
- See all your posts (public + private)
- View your stats
- Delete posts anytime

## 📊 What You Can Track

**Per Post:**
- View count
- Like count
- Comment count
- Share count
- Privacy status
- Upload date

**On Your Profile:**
- Total posts
- Public vs private split
- Total views
- Total likes

## 🔒 Privacy Controls

### Public Posts
- Visible to all community members
- Can be liked and commented on
- Show up in community feed

### Private Posts
- Only you can see them
- Don't appear in community feed
- Optional password protection

### Password Protected
- Private posts can have a password
- Others can't view without password
- You can share password privately if desired

## 🖼️ Supported Media

### Videos
- Formats: MP4, WebM, MOV, AVI
- Max size: 100MB
- Shows as video player in feed

### Images
- Formats: JPG, PNG, GIF, WebP
- Max size: 10MB
- Shows as image in feed

## 👥 Profile Features

### Your Profile (`/profile`)
- See all posts (public and private)
- View personal statistics
- Delete posts
- Edit post privacy settings (via delete + repost)

### Other Profiles (`/community/:userId`)
- See their public posts
- View their public stats
- Like their posts
- Comment on their posts
- Cannot see private posts

## ⚡ Quick Actions

| Action | Button | Result |
|--------|--------|--------|
| Like Post | ❤️ Heart | Post highlights, count increases |
| Comment | 💬 Chat | Opens comment dialog |
| Share | 🔗 Share | Copies link to clipboard |
| Delete Post | 🗑️ Delete | Removes post (only your posts) |
| View Profile | Click Name | Goes to user's public profile |

## 🔄 Real-time Updates

- Like counts update instantly
- Comments appear immediately
- View counts increment in real-time
- New posts appear in feed automatically

## 🛠️ Technical Info

### Routes
- `/community` - Community feed
- `/community/:userId` - User public profile
- `/profile` - Your personal library

### Database Tables
- `community_posts` - All posts
- `community_comments` - Comments
- `community_likes` - Likes
- `community_shares` - Shares

### Storage
- `community-media` bucket in Supabase
- Auto-organized by user ID
- Secure access via RLS policies

## ⚠️ Important Notes

1. **Privacy**: Private posts are truly private - other users cannot see them
2. **Deletion**: Deleted posts cannot be recovered
3. **Comments**: Comments on public posts are visible to all
4. **Password**: Password-protected posts use base64 encoding (not production-grade)
5. **Sharing**: Share feature just copies URL, doesn't create accounts

## 🐛 Troubleshooting

### Posts Not Showing
- Refresh the page
- Check post is marked as public
- Verify you're logged in

### Upload Fails
- Check file size (100MB videos, 10MB images)
- Verify file format is supported
- Check internet connection

### Can't See Someone's Posts
- They may not have any public posts
- Check you're viewing their public profile page
- Private posts won't show to others

### Comments Not Working
- Post must be public to receive comments
- You must be logged in
- Check internet connection

## 📱 Mobile Support

- Fully responsive design
- Works on all devices
- Touch-friendly buttons
- Optimized for vertical viewing

## 🔐 Security

- All content protected by RLS policies
- Users can only delete their own content
- Private posts invisible to others
- Password-protected posts encrypted

## 📊 Statistics

All stats are auto-calculated:
- View count: increases when post is viewed
- Like count: shows total likes
- Comment count: shows total comments
- Share count: tracks shares

## 💡 Pro Tips

1. Use descriptive titles for better discoverability
2. Add detailed descriptions to help context
3. Mix public and private posts
4. Use password protection for sensitive content
5. Share your profile with interested users
6. Engage with community by commenting

## 🎯 Next Steps

After setup:
1. Create your first post
2. Browse the community
3. Like and comment on others' posts
4. Visit other users' profiles
5. Manage your personal library

---

**Need Help?** 
- See full docs: `COMMUNITY_FEATURE.md`
- Setup guide: `COMMUNITY_SETUP.md`
- Implementation details: `COMMUNITY_IMPLEMENTATION_SUMMARY.md`
