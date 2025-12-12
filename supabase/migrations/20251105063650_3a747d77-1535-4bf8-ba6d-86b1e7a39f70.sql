-- Make storage buckets private for better security
UPDATE storage.buckets 
SET public = false 
WHERE id IN ('student-photos', 'instructor-photos', 'avatars');