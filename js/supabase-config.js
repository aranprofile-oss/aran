const SUPABASE_URL = 'https://bsxqtqdvhsgpwqfypgso.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJzeHF0cWR2aHNncHdxZnlwZ3NvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA5NTAyODIsImV4cCI6MjA5NjUyNjI4Mn0.78rQPXLKNnI1-AeFjD_LHd-__an0DHSul6jOZWPciY4';

function initSupabase() {
  return supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}
