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

AI analysis was removed due to API rate limits. The crawler now outputs all keyword-gated articles directly for manual or downstream review.

<!-- CI/CD Trigger: Verification Run 2026-01-28 Retry 3 -->
