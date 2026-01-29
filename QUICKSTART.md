# EPC/EPCM Crawler - Quick Start Guide

## ✅ System Ready

The crawler is fully implemented and tested. It successfully discovered **73 relevant project articles** from **11 industrial news sources** without AI analysis.

## 📊 Test Results

- **Sources Crawled**: 11 base URLs
- **Pages Discovered**: 151 total pages
- **Articles Found**: 73 passed keyword filtering
- **Output File**: `output/results_20260126_215643.json`

## 🚀 Running the Crawler

```powershell
# Navigate to project
cd c:\Users\admin\Documents\project_Crawler

# Run the crawler
python main.py
```

## 📁 Output Structure

Results are saved to`output/results_<timestamp>.json`:

```json
{
  "source_url": "https://example.com/article",
  "title": "Project Announcement",
  "segment": "Chemicals",
  "published_date": "2026-01-26",
  "source_name": "World Fertilizer",
  "text_preview": "First 500 chars of article...",
  "extracted_at": "2026-01-26T21:56:43"
}
```

## 🔄 Incremental Crawling

The system automatically tracks crawled URLs in `output/previous_results.json`. Subsequent runs will only discover NEW articles.

## 🎯 Key Features Working

✅ Seed-based crawling (no AI URL generation)  
✅ Active link discovery with scoring  
✅ Keyword-based filtering (EPCM terms)  
✅ Duplicate prevention  
✅ Incremental updates  
✅ Structured JSON output  

## 📝 Discovered Project Types

- Fertilizer plants (urea, ammonia, nitrogen)
- Sulfur processing facilities
- LNG export terminals
- EPCI contracts
- Infrastructure projects
- EPC/EPCM contractor awards

## ⚙️ Configuration

Edit `config.py` to customize:
- EPCM keywords
- Project keywords
- Target companies
- Scoring rules

## 📌 Note

## 🔄 Manual Supabase Migrations (NEW)

**Workflow:** Testing VPS → Generate SQL → Production VPS

### Initial Setup (One-Time)

```bash
# SSH into Testing VPS
ssh -i ~/.ssh/github_deploy_key root@72.61.226.144

# Run setup script (installs Supabase CLI)
cd /root
git clone https://github.com/adminthelinkai/page_crawler.git
cd page_crawler
./scripts/manual_migration/setup_manual_migration.sh

# Update database passwords
nano ~/supabase-migrations/.env
```

### Regular Workflow

1. **Make schema changes** in Testing Supabase
2. **Generate migration** (on Testing VPS):
   ```bash
   cd ~/supabase-migrations
   source .env
   export DATABASE_URL=$TESTING_DB_URL
   supabase db diff -f my_feature --schema public,auth,storage
   ```
3. **Review** generated SQL in `supabase/migrations/`
4. **Apply to Production** (on Testing VPS):
   ```bash
   export DATABASE_URL=$PRODUCTION_DB_URL
   supabase db push
   ```

📖 **Full guide:** [docs/MIGRATION_GUIDE.md](docs/MIGRATION_GUIDE.md)

---

## 🗂️ Legacy CI/CD Files

The automated CI/CD pipeline (`.github/workflows/supabase-migration.yml`) is deprecated due to connectivity issues. Use manual migrations instead.

AI analysis was removed due to API rate limits. The crawler now outputs all keyword-gated articles directly for manual or downstream review.

<!-- CI/CD Trigger: Verification Run 2026-01-28 Retry 8 - Debug SSH -->
