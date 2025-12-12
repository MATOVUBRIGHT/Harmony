-- Create storage bucket for school library (videos and images)
INSERT INTO storage.buckets (id, name, public)
VALUES ('school-library', 'school-library', true)
ON CONFLICT (id) DO NOTHING;

-- Allow authenticated users to upload media
CREATE POLICY "Authenticated users can upload media"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'school-library');

-- Allow authenticated users to delete their uploads
CREATE POLICY "Authenticated users can delete media"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'school-library');

-- Allow public read access for library content
CREATE POLICY "Public read access for school library"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'school-library');