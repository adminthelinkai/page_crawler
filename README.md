# EPC/EPCM Project Crawler

An industrial intelligence crawler for discovering active EPC/EPCM/FEED project articles from industrial news sources.

## Features

- **Fully Automated**: Runs end-to-end without manual intervention
- **Incremental Crawling**: Never re-processes previously crawled URLs
- **Active Link Discovery**: Intelligently scores and prioritizes relevant links
- **Keyword Gating**: Fast filtering before AI analysis
- **AI-Assisted Extraction**: Uses Google Gemini for semantic understanding
- **Structured Output**: JSON ready for database insertion

## Setup

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Set API Key

Set your Google Gemini API key as an environment variable:

```bash
# Windows (PowerShell)
$env:GEMINI_API_KEY="your-api-key-here"

# Windows (CMD)
set GEMINI_API_KEY=your-api-key-here

# Linux/Mac
export GEMINI_API_KEY="your-api-key-here"
```

Get your API key from: https://makersuite.google.com/app/apikey

### 3. Configure Data

The crawler uses three JSON files in the `data/` directory:
- `base_urls.json` - Source websites to crawl
- `subsegments.json` - Industry subsegments
- `segments.json` - Industry segments

These are already populated with your provided data.

## Usage

Run the crawler:

```bash
python main.py
```

The crawler will:
1. Load previously crawled URLs from memory
2. Crawl active links from base URLs
3. Extract article content
4. Filter using EPCM keywords
5. Analyze with AI
6. Save results to `output/results_<timestamp>.json`

## Output Format

Each result follows this schema:

```json
{
  "source_url": "https://example.com/article",
  "title": "Project Announcement",
  "segment": "Chemicals",
  "project_name": "XYZ Refinery Expansion",
  "owner": "ABC Corporation",
  "epcm_contractor": "Engineering Inc",
  "project_stage": "awarded",
  "location": "Houston, USA",
  "confidence": 0.85,
  "extracted_at": "2026-01-23T14:00:00"
}
```

## Architecture

- `config.py` - Configuration and data loading
- `memory.py` - Duplicate prevention and memory management
- `crawler.py` - Active crawling with link scoring
- `extractor.py` - Content extraction and keyword gating
- `analyzer.py` - AI semantic analysis
- `main.py` - Main orchestration

## Memory System

The crawler maintains `output/previous_results.json` as its memory:
- All crawled URLs are tracked
- Subsequent runs only process NEW URLs
- Output is append-safe for database insertion

## Customization

Edit `config.py` to adjust:
- `KEYWORDS` - Project-related terms
- `TARGET_COMPANIES` - Known owners/contractors
- `EPCM_TERMS` - EPC/EPCM terminology
- `MIN_SCORE` - Link scoring threshold
- `CONFIDENCE_THRESHOLD` - AI acceptance threshold
