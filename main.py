"""
Main entry point for Active Crawler
Scrapes articles from websites and filters by keywords from keywords.json
"""
import json
from datetime import datetime
from crawler import ActiveCrawler, load_keywords_from_json


def load_json(file_path: str) -> list:
    """Load JSON file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        return []


def main():
    print("\n" + "="*60)
    print("ACTIVE CRAWLER")
    print("="*60)
    
    # Load base URLs
    base_urls = load_json('data/base_urls.json')
    
    # Load keywords from keywords.json (all segment and subsegment keywords)
    all_keywords = load_keywords_from_json('data/keywords.json')
    
    print(f"\nLoaded {len(base_urls)} base URLs")
    print(f"Loaded {len(all_keywords)} keywords from keywords.json:")
    for i, kw in enumerate(all_keywords, 1):
        print(f"  {i}. {kw}")
    
    if not base_urls:
        print("ERROR: No base URLs found in data/base_urls.json")
        return
    
    if not all_keywords:
        print("WARNING: No keywords found in data/keywords.json")
        return
    
    # Initialize crawler (will auto-load keywords from keywords.json)
    crawler = ActiveCrawler()
    
    # Crawl all sources
    all_articles = []
    
    for source in base_urls:
        base_url = source.get('base_url')
        source_name = source.get('source_name', base_url)
        
        if not source.get('valid_status', True):
            print(f"\nSkipping {source_name} (valid_status=False)")
            continue
        
        # Crawl this source
        articles = crawler.crawl(base_url, source_name)
        
        # Add source metadata
        for article in articles:
            article['source_name'] = source_name
            article['base_url'] = base_url
            article['segment'] = source.get('subsegment_name', '')
            article['discovered_via'] = 'active_crawl'
            article['discovered_at'] = datetime.now().isoformat()
        
        all_articles.extend(articles)
    
    # Save results
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    output_file = f"output/discovered_urls_{timestamp}.json"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_articles, f, indent=2, ensure_ascii=False)
    
    print("\n" + "="*60)
    print("CRAWL COMPLETE")
    print("="*60)
    print(f"Total articles discovered: {len(all_articles)}")
    print(f"Output saved to: {output_file}")


if __name__ == "__main__":
    main()
