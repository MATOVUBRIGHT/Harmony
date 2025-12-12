-- Restrict public access to profiles data by replacing permissive SELECT policy
-- 1) Ensure RLS is enabled (safe if already enabled)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2) Drop overly permissive policy that exposed all profiles
DROP POLICY IF EXISTS "Users can view all profiles" ON public.profiles;

-- 3) Create owner-only SELECT policy
CREATE POLICY "Users can view own profile"
ON public.profiles
FOR SELECT
TO authenticated
USING (auth.uid() = id);