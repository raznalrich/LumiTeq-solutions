# 🚀 Quick Start Guide - LumiTeQ Solutions

Get your database-driven portfolio up and running in 5 minutes!

## ✅ Step 1: Set Up Supabase (2 minutes)

1. **Go to Supabase SQL Editor**
   - Visit: https://supabase.com/dashboard/project/neriwbcpducpkwmpfieb/sql
   
2. **Run the setup script**
   - Open `setup-database.sql`
   - Copy ALL the content
   - Paste into SQL Editor
   - Click "Run" or press Ctrl+Enter
   - Wait for "Success" message

3. **Create storage bucket**
   - Go to Storage tab in Supabase
   - Click "New bucket"
   - Name: `project-images`
   - Check "Public bucket"
   - Click "Create bucket"

✅ Database setup complete!

## ✅ Step 2: Test Your Site (1 minute)

1. **Open the main page**
   - Double-click `lumiteq-solutions.html`
   - Should load with sample projects

2. **Open admin panel**
   - Double-click `admin.html`
   - You should see the admin interface

3. **Test contact form**
   - Scroll to contact section on main page
   - Fill and submit form
   - Check admin panel > Contacts tab

## ✅ Step 3: Add Your First Custom Project (2 minutes)

1. **Open admin panel** (`admin.html`)

2. **Fill in project details:**
   - Name: "My Awesome Project"
   - Emoji: 🚀
   - Description: "Brief description of the project"
   - Theme: Select a color theme
   - Technologies: Type each tech and press Enter
     - Example: "React" [Enter] "Node.js" [Enter] "MongoDB" [Enter]
   - Image: Upload a screenshot (optional)
   - Order: 0 (shows first)

3. **Click "Add Project"**

4. **Refresh homepage** to see your new project!

## ✅ Step 4: Deploy Online (Optional)

### Option A: cPanel Hosting
1. Upload all files via File Manager or FTP
2. Access via your domain
3. Done! ✨

### Option B: Netlify (Free)
1. Create account at netlify.com
2. Drag & drop your folder
3. Get free URL
4. Done! ✨

### Option C: Vercel (Free)
1. Create account at vercel.com
2. Import your folder
3. Get free URL
4. Done! ✨

## 🔐 Protect Admin Panel (Recommended)

Add this at the start of `<script>` section in `admin.html`:

```javascript
const ADMIN_PASSWORD = 'ChangeThisPassword123';
const saved = sessionStorage.getItem('adminAuth');
if (saved !== ADMIN_PASSWORD) {
  const pw = prompt('Enter admin password:');
  if (pw !== ADMIN_PASSWORD) {
    alert('Incorrect password!');
    window.location.href = 'lumiteq-solutions.html';
  } else {
    sessionStorage.setItem('adminAuth', pw);
  }
}
```

## 🎨 Customize Your Site

### Change Colors
Edit CSS variables in `lumiteq-solutions.html`:
```css
--color-primary: #00d4ff;  /* Your brand color */
```

### Update Contact Info
Find the contact section in `lumiteq-solutions.html` and update:
- Location
- Email
- Phone/availability

### Remove Sample Projects
In Supabase SQL Editor:
```sql
DELETE FROM projects;
```

## 📊 View Your Data

**In Supabase Dashboard:**
- Projects: Table Editor > projects
- Contacts: Table Editor > contacts
- Images: Storage > project-images

## ❓ Troubleshooting

### "Projects not loading"
- Open browser console (F12)
- Check for errors
- Verify database setup completed
- Refresh page

### "Cannot upload images"
- Check storage bucket exists
- Verify bucket is public
- Check file size < 50MB

### "Contact form error"
- Check contacts table exists
- Verify RLS policies
- Check console for errors

## 🎉 You're Done!

Your site is now:
- ✅ Loading projects from database
- ✅ Saving contact submissions
- ✅ Ready for new projects via admin panel
- ✅ Ready to deploy online

## 📚 Need More Help?

- **Full Guide**: See `README.md`
- **Database Details**: See `SUPABASE_SETUP.md`
- **SQL Reference**: See `setup-database.sql`

---

**Next Steps:**
1. Add your real projects via admin panel
2. Update contact information
3. Customize colors to match your brand
4. Deploy to your domain

Happy building! 🚀
