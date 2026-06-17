// Supabase Configuration
const SUPABASE_URL = 'https://neriwbcpducpkwmpfieb.supabase.co';
// ⚠️ IMPORTANT: Replace this with your ACTUAL anon/public API key from Supabase Dashboard
// Go to: Settings > API > Copy the "anon public" key (starts with eyJ...)
// This current key is INCORRECT and needs to be replaced!
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5lcml3YmNwZHVjcGt3bXBmaWViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE3MDcwOTgsImV4cCI6MjA5NzI4MzA5OH0.D9udViUr-Zk5NOcMqkvWqbHCfXA-agWYOHsCDIIrDyk';

// Check if API key needs to be updated
if (SUPABASE_ANON_KEY === 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5lcml3YmNwZHVjcGt3bXBmaWViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE3MDcwOTgsImV4cCI6MjA5NzI4MzA5OH0.D9udViUr-Zk5NOcMqkvWqbHCfXA-agWYOHsCDIIrDyk' || !SUPABASE_ANON_KEY.startsWith('eyJ')) {
  console.error('❌ SUPABASE ERROR: Invalid API key!');
  console.error('👉 Open test-connection.html to get your correct API key');
  console.error('📋 Then update SUPABASE_ANON_KEY in supabase-config.js');
}

// Initialize Supabase client
const _supabase = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Helper function to fetch all projects
async function fetchProjects() {
  try {
    console.log('🔄 Fetching projects from Supabase...');
    const { data, error } = await _supabase
      .from('projects')
      .select('*')
      .order('display_order', { ascending: true });
    
    if (error) {
      console.error('❌ Error fetching projects:', error);
      throw error;
    }
    console.log('✅ Projects loaded:', data.length, 'projects found');
    return data || [];
  } catch (error) {
    console.error('❌ Error fetching projects:', error);
    return [];
  }
}

// Helper function to submit contact form
async function submitContactForm(formData) {
  try {
    console.log('📧 Submitting contact form...', formData);
    const { data, error } = await _supabase
      .from('contacts')
      .insert([formData])
      .select();
    
    if (error) {
      console.error('❌ Error submitting contact form:', error);
      throw error;
    }
    console.log('✅ Contact form submitted successfully!', data);
    return { success: true, data };
  } catch (error) {
    console.error('❌ Error submitting contact form:', error);
    return { success: false, error: error.message };
  }
}

// Helper function to get theme gradient
function getProjectThemeGradient(theme) {
  const gradients = {
    retail: 'linear-gradient(135deg, color-mix(in oklch, var(--color-primary) 20%, var(--color-surface-offset)), color-mix(in oklch, var(--color-accent2) 15%, var(--color-surface-offset)))',
    ecom: 'linear-gradient(135deg, color-mix(in oklch, #22c55e 15%, var(--color-surface-offset)), color-mix(in oklch, var(--color-primary) 12%, var(--color-surface-offset)))',
    report: 'linear-gradient(135deg, color-mix(in oklch, #f59e0b 15%, var(--color-surface-offset)), color-mix(in oklch, #ef4444 10%, var(--color-surface-offset)))',
    pos: 'linear-gradient(135deg, color-mix(in oklch, var(--color-accent2) 18%, var(--color-surface-offset)), color-mix(in oklch, var(--color-primary) 10%, var(--color-surface-offset)))',
    inventory: 'linear-gradient(135deg, color-mix(in oklch, #8b5cf6 20%, var(--color-surface-offset)), color-mix(in oklch, #06b6d4 15%, var(--color-surface-offset)))',
    crm: 'linear-gradient(135deg, color-mix(in oklch, #ec4899 18%, var(--color-surface-offset)), color-mix(in oklch, #f97316 12%, var(--color-surface-offset)))',
    analytics: 'linear-gradient(135deg, color-mix(in oklch, #3b82f6 20%, var(--color-surface-offset)), color-mix(in oklch, #10b981 15%, var(--color-surface-offset)))',
    mobile: 'linear-gradient(135deg, color-mix(in oklch, #14b8a6 18%, var(--color-surface-offset)), color-mix(in oklch, #6366f1 15%, var(--color-surface-offset)))'
  };
  return gradients[theme] || gradients.retail;
}
