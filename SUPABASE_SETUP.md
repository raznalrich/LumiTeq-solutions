# Supabase Database Setup Guide

This guide will help you set up the required database tables and storage buckets in your Supabase project.

## 📋 Prerequisites

- Supabase account and project created
- Project URL: `https://neriwbcpducpkwmpfieb.supabase.co`
- Access to Supabase SQL Editor

---

## 🗄️ Database Tables

### 1. Projects Table

Run this SQL in your Supabase SQL Editor:

```sql
-- Create projects table
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
CREATE INDEX IF NOT EXISTS idx_projects_display_order ON public.projects(display_order);

-- Enable Row Level Security (RLS)
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Allow public read access"
ON public.projects
FOR SELECT
TO public
USING (true);

-- Create policy to allow authenticated users to insert/update/delete
CREATE POLICY "Allow authenticated insert"
ON public.projects
FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Allow authenticated update"
ON public.projects
FOR UPDATE
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated delete"
ON public.projects
FOR DELETE
TO authenticated
USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON public.projects
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### 2. Contacts Table

```sql
-- Create contacts table
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
CREATE INDEX IF NOT EXISTS idx_contacts_created_at ON public.contacts(created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anyone to insert (for contact form submissions)
CREATE POLICY "Allow public insert"
ON public.contacts
FOR INSERT
TO public
WITH CHECK (true);

-- Create policy to allow authenticated users to read
CREATE POLICY "Allow authenticated read"
ON public.contacts
FOR SELECT
TO authenticated
USING (true);
```

---

## 📦 Storage Buckets

### Create project-images bucket

1. Go to **Storage** in your Supabase dashboard
2. Click **New bucket**
3. Enter bucket name: `project-images`
4. Select **Public bucket** (so images can be viewed publicly)
5. Click **Create bucket**

### Set Storage Policies

Run this SQL to allow public read and authenticated upload:

```sql
-- Allow public to read images
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'project-images');

-- Allow authenticated users to upload
CREATE POLICY "Authenticated Upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'project-images');

-- Allow authenticated users to update
CREATE POLICY "Authenticated Update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'project-images');

-- Allow authenticated users to delete
CREATE POLICY "Authenticated Delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'project-images');
```

---

## 🔐 Authentication Setup (Optional)

If you want to protect the admin page with authentication:

### Option 1: Simple Password Protection
Add this to the beginning of `admin.html`:

```javascript
// Simple password protection (add at start of <script>)
const ADMIN_PASSWORD = 'your_secure_password_here';
const savedPassword = sessionStorage.getItem('adminAuth');

if (savedPassword !== ADMIN_PASSWORD) {
  const password = prompt('Enter admin password:');
  if (password !== ADMIN_PASSWORD) {
    alert('Incorrect password!');
    window.location.href = 'lumiteq-solutions.html';
  } else {
    sessionStorage.setItem('adminAuth', password);
  }
}
```

### Option 2: Supabase Authentication
1. Enable Email authentication in Supabase Dashboard > Authentication > Providers
2. Create an admin user in Authentication > Users
3. Add login page logic to admin.html

---

## 📊 Sample Data (Optional)

Insert sample projects to test:

```sql
INSERT INTO public.projects (name, emoji, description, theme, tags, display_order) VALUES
('WorldSmart Retail Management Platform', '🏪', 'A comprehensive multi-store retail management system handling inventory, billing, customer loyalty, purchase orders, and advanced sales reporting across distributed retail chains.', 'retail', '["C# / .NET", "SQL Server", "Angular", "POS"]', 0),
('AUR E-Commerce Platform', '🛒', 'Full-featured online storefront with product customization (neon/lighting), cart management, order tracking, and CPanel deployment pipeline.', 'ecom', '["Angular", "Firebase", "E-Commerce"]', 1),
('Enterprise Reporting Suite', '📊', 'Multi-format report generation system covering sales analytics, inventory summaries, financial statements, and custom KPI dashboards with CSV/PDF export.', 'report', '["Stimulsoft", "SQL Server", "C#"]', 2),
('POS Terminal Interface', '💳', 'High-performance point-of-sale terminal with barcode scanning, split-payment processing, real-time stock deduction, and offline-first architecture for retail environments.', 'pos', '["Angular", "C#", "REST API"]', 3);
```

---

## 🚀 Testing the Setup

1. **Test Projects Loading:**
   - Open `lumiteq-solutions.html` in a browser
   - Check if projects are loading in the Projects section
   - Check browser console for any errors

2. **Test Admin Page:**
   - Open `admin.html`
   - Try adding a new project
   - Check if it appears in the Manage Projects tab

3. **Test Contact Form:**
   - Fill out the contact form on the homepage
   - Submit and check if it appears in the admin panel's Contacts tab

4. **Test All Works Page:**
   - Navigate to `all-works.html`
   - Verify all projects are displayed

---

## 🔧 Troubleshooting

### Projects not loading?
- Check browser console for errors
- Verify Supabase URL and API key in `supabase-config.js`
- Ensure RLS policies are set up correctly
- Check if tables exist in Supabase

### Images not uploading?
- Verify `project-images` bucket exists and is public
- Check storage policies are set up
- Ensure file size is under limit (default 50MB)

### Contact form not working?
- Check browser console for errors
- Verify contacts table exists
- Check RLS policies allow public insert

---

## 📝 Files Created

- ✅ `admin.html` - Admin panel for managing projects
- ✅ `supabase-config.js` - Supabase client configuration
- ✅ `lumiteq-solutions.html` - Updated with Supabase integration
- ✅ `all-works.html` - Updated to fetch from Supabase
- ✅ `SUPABASE_SETUP.md` - This guide

---

## 🎯 Next Steps

1. Run all SQL commands in Supabase SQL Editor
2. Create the storage bucket for images
3. Test the admin panel by adding projects
4. Verify projects appear on both pages
5. Test contact form submission
6. (Optional) Add authentication to admin panel

---

## 📞 Support

If you encounter any issues:
- Check Supabase logs in Dashboard > Logs
- Review browser console for JavaScript errors
- Verify all policies are correctly set up
- Ensure API keys are correct

Happy coding! 🚀
