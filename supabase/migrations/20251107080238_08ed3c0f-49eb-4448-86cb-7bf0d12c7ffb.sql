-- Fix avatar storage policies to be owner-only
DROP POLICY IF EXISTS "Users can view all avatars" ON storage.objects;

CREATE POLICY "Users can view their own avatars"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Add admin delete policy for subscriptions
CREATE POLICY "Admins can delete subscriptions"
ON public.subscriptions FOR DELETE
USING (has_role(auth.uid(), 'admin'::app_role));