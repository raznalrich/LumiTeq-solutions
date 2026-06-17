# 🔧 Troubleshooting Guide - Fix API Key Issues

## 🚨 Problem Identified

Your projects aren't loading and contact form is getting null values because **the API key format is incorrect**.

## ✅ Quick Fix (5 minutes)

### Step 1: Get Your Real API Key

1. **Open this link** (or copy to browser):
   ```
   https://supabase.com/dashboard/project/neriwbcpducpkwmpfieb/settings/api
   ```

2. **Look for the "anon public" key**
   - It's under "Project API keys"
   - Should be a long string starting with `eyJ...`
   - It looks like: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ...` (much longer)
   - **DO NOT** use the `service_role` key!

3. **Copy the entire key** (click the copy button)

### Step 2: Test Your Connection

1. **Open** `test-connection.html` in your browser
2. **Paste** your API key into the text area
3. **Click** "Test Connection"
4. **Wait** for success message ✅

### Step 3: Update Your Files

Once the test is successful, update these 2 files:

#### File 1: `supabase-config.js`

Find this line (around line 6):
```javascript
const SUPABASE_ANON_KEY = 'YOUR_ACTUAL_ANON_KEY_HERE';
```

Replace with your real key:
```javascript
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...YOUR_ACTUAL_KEY';
```

#### File 2: `admin.html`

Find this line (around line 508):
```javascript
const SUPABASE_KEY = 'YOUR_ACTUAL_ANON_KEY_HERE';
```

Replace with your real key:
```javascript
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...YOUR_ACTUAL_KEY';
```

### Step 4: Test Everything

1. **Refresh** your browser (or close and reopen the HTML files)
2. **Open** `lumiteq-solutions.html`
3. **Check** browser console (press F12):
   - Should see: `✅ Projects loaded: X projects found`
   - Should NOT see any red ❌ errors
4. **Try** submitting the contact form
5. **Check** console for: `✅ Contact form submitted successfully!`

---

## 🔍 What Was Wrong?

The API key provided earlier (`sb_publishable_KBA_wxO0WbN81Mganl-u0w_MDJpI8Uu`) is not a valid Supabase anon key format. 

**Valid Supabase keys:**
- Start with `eyJ`
- Are JWT tokens (3 parts separated by dots)
- Are much longer (150-200+ characters)

**Example of correct format:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InByb2plY3QiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYzMjE0MDAwMCwiZXhwIjoxOTQ3NzE2MDAwfQ.SIGNATURE_PART_HERE
```

---

## 📊 Debug Checklist

If projects still don't load after updating the key:

### Check 1: Browser Console
Press F12 and look for errors:
- ❌ `Invalid API key` → Update supabase-config.js
- ❌ `relation "public.projects" does not exist` → Run setup-database.sql
- ❌ `401 Unauthorized` → Wrong API key
- ❌ `CORS error` → Check URL is correct

### Check 2: Database Tables
Go to Supabase Dashboard > Table Editor:
- ✅ `projects` table should exist
- ✅ `contacts` table should exist
- If missing → Run `setup-database.sql` in SQL Editor

### Check 3: RLS Policies
Go to Supabase Dashboard > Authentication > Policies:
- ✅ Projects table should have "Allow public read access" policy
- ✅ Contacts table should have "Allow public insert" policy
- If missing → Run `setup-database.sql` in SQL Editor

### Check 4: Storage Bucket
Go to Supabase Dashboard > Storage:
- ✅ `project-images` bucket should exist
- ✅ Should be marked as "Public"
- If missing → Create it manually

---

## 🧪 Test Individual Components

### Test 1: Projects Loading
Open browser console (F12) on `lumiteq-solutions.html` and run:
```javascript
fetchProjects().then(data => console.log('Projects:', data));
```
Should see array of projects.

### Test 2: Contact Form
Fill and submit form, check console for:
```
📧 Submitting contact form... {name: "...", email: "..."}
✅ Contact form submitted successfully!
```

### Test 3: Supabase Connection
In browser console:
```javascript
console.log('Supabase client:', _supabase);
```
Should see object, not undefined.

---

## 🆘 Still Having Issues?

### Common Mistakes:

1. **Wrong Key Used**
   - ❌ Using `service_role` key (dangerous!)
   - ✅ Use `anon public` key

2. **Partial Key Copied**
   - ❌ Only copied part of the key
   - ✅ Copy entire key (use copy button in Supabase)

3. **Extra Spaces**
   - ❌ Space before or after key
   - ✅ Trim spaces: `'eyJ...'` not `' eyJ... '`

4. **Wrong File Edited**
   - ❌ Edited backup copy
   - ✅ Edit the actual files in your project folder

5. **Cache Issue**
   - ❌ Browser using old cached version
   - ✅ Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

---

## 📞 Need More Help?

1. **Check Supabase Status**: https://status.supabase.com/
2. **Check Browser Console**: Press F12, look at Console and Network tabs
3. **Try Incognito Mode**: Rule out browser extensions/cache
4. **Test with Different Browser**: Chrome, Firefox, Edge

---

## ✨ After Fixing

Once everything works:

1. ✅ Projects will load on homepage
2. ✅ All projects visible on all-works.html
3. ✅ Contact form submissions saved to database
4. ✅ Admin panel can add/delete projects
5. ✅ Admin panel shows contact submissions

**Remember:** Keep your API keys secure and never commit them to public repositories!

---

## 🎉 Success Indicators

You'll know it's working when you see in console:
```
✅ Projects loaded: 8 projects found
✅ Contact form submitted successfully!
```

And on the page:
- Projects display in grid
- Contact form shows "Message Sent!" after submission
- Admin panel loads project list
