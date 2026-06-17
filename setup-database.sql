-- ====================================================================
-- LumiTeQ Solutions - Supabase Database Setup
-- Run this entire script in your Supabase SQL Editor
-- ====================================================================

-- ====================================================================
-- 1. CREATE PROJECTS TABLE
-- ====================================================================

CREATE TABLE IF NOT EXISTS public.projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    emoji TEXT NOT NULL,
    description TEXT NOT NULL,
    theme TEXT NOT NULL DEFAULT 'retail',
    tags JSONB NOT NULL DEFAULT '[]'::jsonb,
    image_url TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for ordering
CREATE INDEX IF NOT EXISTS idx_projects_display_order 
ON public.projects(display_order);

-- Create index for created_at
CREATE INDEX IF NOT EXISTS idx_projects_created_at 
ON public.projects(created_at DESC);

COMMENT ON TABLE public.projects IS 'Stores portfolio projects';
COMMENT ON COLUMN public.projects.theme IS 'Color theme: retail, ecom, report, pos, inventory, crm, analytics, mobile';
COMMENT ON COLUMN public.projects.tags IS 'Array of technology tags as JSON';
COMMENT ON COLUMN public.projects.display_order IS 'Lower numbers appear first';

-- ====================================================================
-- 2. CREATE CONTACTS TABLE
-- ====================================================================

CREATE TABLE IF NOT EXISTS public.contacts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    company TEXT,
    message TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for sorting by date
CREATE INDEX IF NOT EXISTS idx_contacts_created_at 
ON public.contacts(created_at DESC);

-- Create index for email (useful for searching)
CREATE INDEX IF NOT EXISTS idx_contacts_email 
ON public.contacts(email);

COMMENT ON TABLE public.contacts IS 'Stores contact form submissions';

-- ====================================================================
-- 3. ENABLE ROW LEVEL SECURITY (RLS)
-- ====================================================================

-- Enable RLS on projects table
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

-- Enable RLS on contacts table
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;

-- ====================================================================
-- 4. CREATE RLS POLICIES FOR PROJECTS
-- ====================================================================

-- Allow public to read all projects
CREATE POLICY "Allow public read access"
ON public.projects
FOR SELECT
TO public
USING (true);

-- Allow authenticated users to insert projects
CREATE POLICY "Allow authenticated insert"
ON public.projects
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Allow authenticated users to update projects
CREATE POLICY "Allow authenticated update"
ON public.projects
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Allow authenticated users to delete projects
CREATE POLICY "Allow authenticated delete"
ON public.projects
FOR DELETE
TO authenticated
USING (true);

-- ====================================================================
-- 5. CREATE RLS POLICIES FOR CONTACTS
-- ====================================================================

-- Allow anyone to submit contact form (public insert)
CREATE POLICY "Allow public insert"
ON public.contacts
FOR INSERT
TO public
WITH CHECK (true);

-- Allow authenticated users to read contacts (admin only)
CREATE POLICY "Allow authenticated read"
ON public.contacts
FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to delete contacts (admin cleanup)
CREATE POLICY "Allow authenticated delete"
ON public.contacts
FOR DELETE
TO authenticated
USING (true);

-- ====================================================================
-- 6. CREATE TRIGGER FOR AUTO-UPDATING updated_at
-- ====================================================================

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for projects table
DROP TRIGGER IF EXISTS update_projects_updated_at ON public.projects;
CREATE TRIGGER update_projects_updated_at 
    BEFORE UPDATE ON public.projects
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ====================================================================
-- 7. INSERT SAMPLE DATA (OPTIONAL - Comment out if not needed)
-- ====================================================================

INSERT INTO public.projects (name, emoji, description, theme, tags, display_order) 
VALUES
    (
        'WorldSmart Retail Management Platform',
        '🏪',
        'A comprehensive multi-store retail management system handling inventory, billing, customer loyalty, purchase orders, and advanced sales reporting across distributed retail chains.',
        'retail',
        '["C# / .NET", "SQL Server", "Angular", "POS"]'::jsonb,
        0
    ),
    (
        'AUR E-Commerce Platform',
        '🛒',
        'Full-featured online storefront with product customization (neon/lighting), cart management, order tracking, and CPanel deployment pipeline.',
        'ecom',
        '["Angular", "Firebase", "E-Commerce"]'::jsonb,
        1
    ),
    (
        'Enterprise Reporting Suite',
        '📊',
        'Multi-format report generation system covering sales analytics, inventory summaries, financial statements, and custom KPI dashboards with CSV/PDF export.',
        'report',
        '["Stimulsoft", "SQL Server", "C#"]'::jsonb,
        2
    ),
    (
        'POS Terminal Interface',
        '💳',
        'High-performance point-of-sale terminal with barcode scanning, split-payment processing, real-time stock deduction, and offline-first architecture for retail environments.',
        'pos',
        '["Angular", "C#", "REST API"]'::jsonb,
        3
    ),
    (
        'Warehouse Inventory System',
        '📦',
        'Real-time stock tracking, warehouse management, purchase order workflows, and replenishment alerts — keeping operations running without blind spots.',
        'inventory',
        '["C#", "SQL Server", "WPF"]'::jsonb,
        4
    ),
    (
        'Customer Loyalty & CRM',
        '⭐',
        'Points-based loyalty system with tiered rewards, customer profile management, targeted promotions, and integrated communication workflows for retail chains.',
        'crm',
        '["C#", "Angular", "Redis"]'::jsonb,
        5
    ),
    (
        'Business Intelligence Dashboard',
        '📈',
        'Real-time analytics platform aggregating sales trends, inventory metrics, customer behavior, and financial performance with customizable KPI widgets and drill-down reports.',
        'analytics',
        '["Power BI", "SQL", "Python"]'::jsonb,
        6
    ),
    (
        'Mobile Sales Force Application',
        '📱',
        'Field sales app enabling offline order capture, inventory lookup, customer management, and route optimization with real-time sync to central ERP systems.',
        'mobile',
        '["Flutter", "REST API", "SQLite"]'::jsonb,
        7
    )
ON CONFLICT DO NOTHING;

-- ====================================================================
-- 8. VERIFICATION QUERIES (Check if everything worked)
-- ====================================================================

-- Count projects
SELECT COUNT(*) as total_projects FROM public.projects;

-- View all projects
SELECT id, name, theme, display_order, created_at 
FROM public.projects 
ORDER BY display_order;

-- Check RLS policies for projects
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'projects';

-- Check RLS policies for contacts
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'contacts';

-- ====================================================================
-- SETUP COMPLETE! 
-- ====================================================================
-- Next steps:
-- 1. Create storage bucket 'project-images' in Supabase Storage
-- 2. Make it public
-- 3. Run storage policies (see next section)
-- ====================================================================

-- ====================================================================
-- 9. STORAGE BUCKET POLICIES (Run after creating 'project-images' bucket)
-- ====================================================================

-- Note: Create the 'project-images' bucket in Supabase Storage first
-- Then run these policies:

-- Allow public to read/view images
CREATE POLICY "Public Access to Images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'project-images');

-- Allow authenticated users to upload images
CREATE POLICY "Authenticated Upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'project-images');

-- Allow authenticated users to update images
CREATE POLICY "Authenticated Update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'project-images')
WITH CHECK (bucket_id = 'project-images');

-- Allow authenticated users to delete images
CREATE POLICY "Authenticated Delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'project-images');

-- ====================================================================
-- 10. USEFUL QUERIES FOR ADMIN
-- ====================================================================

-- Delete all sample data (if you want to start fresh)
-- DELETE FROM public.projects;
-- DELETE FROM public.contacts;

-- View recent contacts
-- SELECT * FROM public.contacts ORDER BY created_at DESC LIMIT 10;

-- Count contacts by day
-- SELECT DATE(created_at) as date, COUNT(*) as submissions
-- FROM public.contacts
-- GROUP BY DATE(created_at)
-- ORDER BY date DESC;

-- Find duplicate contacts by email
-- SELECT email, COUNT(*) as count
-- FROM public.contacts
-- GROUP BY email
-- HAVING COUNT(*) > 1;

-- ====================================================================
-- ALL DONE! 🎉
-- Your database is now ready for LumiTeQ Solutions
-- ====================================================================
