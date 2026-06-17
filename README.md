# LumiTeQ Solutions - Project Management System

A modern, database-driven portfolio website with an admin panel for managing projects and viewing contact submissions.

## ⚠️ IMPORTANT: First-Time Setup

**Before anything else, you need to get your correct Supabase API key!**

The API key format must be a JWT token starting with `eyJ...`. If projects aren't loading or contact form isn't working:

1. 🚨 **Open [test-connection.html](test-connection.html)** in your browser
2. Follow the steps to get your real API key from Supabase
3. Update both `supabase-config.js` and `admin.html` with the correct key
4. See [QUICK-FIX.txt](QUICK-FIX.txt) for step-by-step instructions

**Common Issue:** If you see `YOUR_ACTUAL_ANON_KEY_HERE` in the config files, you need to replace it with your real key!

---

## 🌟 Features

### Public Website
- ✨ Modern, responsive design with dark/light theme
- 📱 Mobile-friendly navigation
- 🎨 Dynamic project loading from database
- 📧 Contact form with database storage
- 🔄 Smooth animations and transitions
- ⚡ Fast loading with optimized assets

### Admin Panel
- 🔧 Add/manage projects through web interface
- 🖼️ Image upload for project thumbnails
- 🏷️ Tag management system
- 📊 View all contact form submissions
- 🎯 Drag-and-drop file uploads
- 🗑️ Delete projects with confirmation

## 📁 Project Structure

```
lumiteq-solutions/
├── lumiteq-solutions.html    # Main homepage
├── all-works.html             # All projects page
├── admin.html                 # Admin panel (protected)
├── supabase-config.js         # Supabase configuration
├── SUPABASE_SETUP.md          # Database setup guide
└── README.md                  # This file
```

## 🚀 Quick Start

### 1. Set Up Supabase Database

Follow the instructions in [SUPABASE_SETUP.md](SUPABASE_SETUP.md) to:
- Create required database tables
- Set up storage bucket for images
- Configure security policies

### 2. Update Configuration

The Supabase credentials are already configured in `supabase-config.js`:
- Project URL: `https://neriwbcpducpkwmpfieb.supabase.co`
- Anon Key: Already included

### 3. Deploy Your Site

#### Option A: Local Development
1. Open `lumiteq-solutions.html` in a modern browser
2. Navigate to `admin.html` to add projects

#### Option B: Deploy to Web Host
1. Upload all files to your web hosting (cPanel, Netlify, Vercel, etc.)
2. Ensure all files are in the same directory
3. Access via your domain

### 4. Add Your First Project

1. Open `admin.html` in your browser
2. Fill in the project details:
   - **Project Name**: Enter the project title
   - **Emoji Icon**: Add an emoji (🏪, 🛒, 📊, etc.)
   - **Description**: Detailed project description
   - **Theme Color**: Select a color scheme
   - **Technologies**: Press Enter after each tag
   - **Image**: Upload a project screenshot (optional)
3. Click "Add Project"
4. Check the homepage to see your project!

## 🎨 Available Theme Colors

- **retail** - Cyan/Purple gradient
- **ecom** - Green/Cyan gradient
- **report** - Orange/Red gradient
- **pos** - Purple/Cyan gradient
- **inventory** - Purple/Sky gradient
- **crm** - Pink/Orange gradient
- **analytics** - Blue/Green gradient
- **mobile** - Teal/Indigo gradient

## 📊 Database Schema

### Projects Table
```
id              UUID (Primary Key)
name            TEXT
emoji           TEXT
description     TEXT
theme           TEXT
tags            JSONB
image_url       TEXT
display_order   INTEGER
created_at      TIMESTAMPTZ
updated_at      TIMESTAMPTZ
```

### Contacts Table
```
id          UUID (Primary Key)
name        TEXT
email       TEXT
phone       TEXT (optional)
company     TEXT (optional)
message     TEXT
created_at  TIMESTAMPTZ
```

## 🔐 Security Recommendations

### Protect Admin Panel

**Option 1: Simple Password (Quick)**
Add this at the start of admin.html `<script>`:
```javascript
const ADMIN_PASSWORD = 'YourSecurePassword123';
const saved = sessionStorage.getItem('adminAuth');
if (saved !== ADMIN_PASSWORD) {
  const pw = prompt('Admin Password:');
  if (pw !== ADMIN_PASSWORD) {
    window.location.href = 'lumiteq-solutions.html';
  } else {
    sessionStorage.setItem('adminAuth', pw);
  }
}
```

**Option 2: .htaccess (Recommended for cPanel)**
Create `.htaccess` file:
```apache
<Files "admin.html">
    AuthType Basic
    AuthName "Admin Area"
    AuthUserFile /path/to/.htpasswd
    Require valid-user
</Files>
```

**Option 3: Supabase Auth (Most Secure)**
Implement Supabase Authentication with email/password login.

## 🛠️ Customization

### Update Contact Information
Edit `lumiteq-solutions.html` contact section:
- Location
- Email address
- Phone number

### Modify Color Scheme
Edit CSS variables in the `<style>` section:
```css
:root {
  --color-primary: #00d4ff;  /* Main accent color */
  --color-accent2: #7c3aed;  /* Secondary accent */
  /* ... more variables */
}
```

### Add New Theme Colors
In `supabase-config.js`, add to `getProjectThemeGradient()`:
```javascript
yourtheme: 'linear-gradient(135deg, ...)'
```

## 📱 Browser Support

- ✅ Chrome/Edge (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Mobile browsers

## 🐛 Troubleshooting

### Projects not loading?
1. Open browser console (F12)
2. Check for JavaScript errors
3. Verify Supabase credentials in `supabase-config.js`
4. Ensure database tables are created

### Admin panel not working?
1. Check Supabase SQL policies
2. Verify storage bucket exists
3. Check browser console for errors

### Images not uploading?
1. Verify `project-images` bucket exists
2. Check storage policies in Supabase
3. Ensure file size < 50MB

### Contact form fails?
1. Check contacts table exists
2. Verify RLS policies allow public insert
3. Check browser console for errors

## 🔄 Updates & Maintenance

### Add New Features
- Edit HTML files directly
- Update `supabase-config.js` for new database operations
- Modify CSS in `<style>` sections

### Backup Database
Use Supabase Dashboard > Database > Backups

### Export Data
```sql
-- Export projects
SELECT * FROM projects ORDER BY display_order;

-- Export contacts
SELECT * FROM contacts ORDER BY created_at DESC;
```

## 📈 Performance Tips

1. **Optimize Images**: Compress project images before upload
2. **CDN**: Use Cloudflare or similar for faster loading
3. **Caching**: Enable browser caching on your host
4. **Minify**: Consider minifying CSS for production

## 🎓 Learning Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Modern CSS](https://web.dev/learn/css/)
- [JavaScript Async/Await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)

## 📞 Support

For issues related to:
- **Supabase**: Check [Supabase Docs](https://supabase.com/docs)
- **HTML/CSS**: Review browser console and validate markup
- **JavaScript**: Check browser console for errors

## 🚀 Deployment Platforms

This site works on:
- ✅ cPanel hosting
- ✅ Netlify
- ✅ Vercel
- ✅ GitHub Pages
- ✅ Any static hosting

Just upload all files and you're done!

## 📝 License

This is a custom website for LumiTeQ Solutions. Modify as needed for your use case.

---

Built with ❤️ using HTML, CSS, JavaScript, and Supabase
