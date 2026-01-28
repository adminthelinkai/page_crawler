"""
Active Crawler - Scrapes articles from website sections and filters by keywords
"""
import re
import time
import json
import os
from urllib.parse import urljoin, urlparse, urlunparse
from typing import List, Dict, Set, Optional
from datetime import datetime
import requests
from bs4 import BeautifulSoup
import urllib3

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def load_keywords_from_json(file_path: str = 'data/keywords.json') -> List[str]:
    """
    Load all keywords from keywords.json file
    Extracts keywords from segment and all subsegments
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        all_keywords = []
        
        if isinstance(data, list):
            for segment in data:
                # Get segment keywords
                all_keywords.extend(segment.get('keywords', []))
                
                # Get subsegment keywords
                for subsegment in segment.get('subsegments', []):
                    all_keywords.extend(subsegment.get('keywords', []))
        
        # Remove duplicates while preserving order
        seen = set()
        unique_keywords = []
        for kw in all_keywords:
            if kw.lower() not in seen:
                seen.add(kw.lower())
                unique_keywords.append(kw)
        
        return unique_keywords
    except FileNotFoundError:
        print(f"Warning: {file_path} not found, using empty keywords list")
        return []
    except Exception as e:
        print(f"Error loading keywords: {e}")
        return []


class ActiveCrawler:
    """Active crawler that scrapes sections and filters by keywords"""
    
    def __init__(self, keywords: List[str] = None, keywords_file: str = 'data/keywords.json'):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.session.verify = False
        self.crawled_urls: Set[str] = set()
        
        # Load keywords from file if not provided
        if keywords:
            self.keywords = keywords
        else:
            self.keywords = load_keywords_from_json(keywords_file)
        
        self.keywords_lower = [kw.lower() for kw in self.keywords]
        
        # Default sections to crawl
        self.sections = [
            '/news',
            '/articles', 
            '/latest',
            '/projects',
            '/en/news',
            '/en/business',
            '/en/economy',
            '/industry-news',
            '/'
        ]

    
    def normalize_url(self, url: str) -> str:
        """Normalize URL by removing fragments and tracking params"""
        parsed = urlparse(url)
        parsed = parsed._replace(fragment='')
        
        if parsed.query:
            query_params = []
            for param in parsed.query.split('&'):
                if param and not any(track in param.lower() for track in 
                                   ['utm_', 'ref=', 'source=', 'campaign=']):
                    query_params.append(param)
            new_query = '&'.join(query_params)
            parsed = parsed._replace(query=new_query)
        
        return urlunparse(parsed)
    
    def fetch_page(self, url: str) -> Optional[str]:
        """Fetch a page and return HTML content"""
        try:
            response = self.session.get(url, timeout=15)
            if response.status_code == 200:
                return response.text
            return None
        except Exception as e:
            print(f"  Error fetching {url}: {str(e)[:50]}")
            return None
    
    def extract_articles(self, html: str, base_url: str, section: str, section_url: str) -> List[Dict]:
        """Extract articles from HTML and filter by keywords"""
        soup = BeautifulSoup(html, 'lxml')
        base_domain = urlparse(base_url).netloc
        
        articles = []
        
        for a_tag in soup.find_all('a', href=True):
            href = a_tag['href']
            full_url = urljoin(base_url, href)
            normalized_url = self.normalize_url(full_url)
            title = a_tag.get_text(strip=True)
            
            # Skip if title is too short
            if not title or len(title) < 15:
                continue
            
            # Skip external links
            if urlparse(normalized_url).netloc != base_domain:
                continue
            
            # Skip utility pages
            skip_patterns = ['/login', '/subscribe', '/contact', '/about', '/privacy', 
                           '/terms', '/cookie', '/search', '/tag/', '/category/', '/author/']
            if any(p in normalized_url.lower() for p in skip_patterns):
                continue
            
            # Skip already crawled
            if normalized_url in self.crawled_urls:
                continue
            
            # Match keywords
            text_to_check = (title.lower() + ' ' + normalized_url.lower())
            matched_keywords = [kw for kw in self.keywords_lower if kw in text_to_check]
            
            if matched_keywords:
                self.crawled_urls.add(normalized_url)
                articles.append({
                    'url': normalized_url,
                    'title': title[:100],
                    'discovered_in_section': section,
                    'section_url': section_url,
                    'matched_keywords': matched_keywords
                })
        
        return articles
    
    def crawl(self, base_url: str, source_name: str = None, keywords: List[str] = None) -> List[Dict]:
        """
        Crawl a website using active crawling method
        
        Args:
            base_url: The website URL to crawl (e.g., https://www.zawya.com)
            source_name: Name of the source (optional)
            keywords: List of keywords to filter articles (optional, uses instance keywords if not provided)
        
        Returns:
            List of article dictionaries with matched keywords
        """
        if keywords:
            self.keywords = keywords
            self.keywords_lower = [kw.lower() for kw in keywords]
        
        source_name = source_name or urlparse(base_url).netloc
        
        print(f"\n{'='*70}")
        print(f"ACTIVE CRAWLING: {source_name}")
        print(f"{'='*70}")
        print(f"Base URL: {base_url}")
        print(f"Keywords: {', '.join(self.keywords[:10])}")
        if len(self.keywords) > 10:
            print(f"          ... and {len(self.keywords) - 10} more")
        
        all_articles = []
        
        print(f"\n{'='*70}")
        print(f"CRAWLING SECTIONS")
        print(f"{'='*70}")
        
        for section in self.sections:
            section_url = urljoin(base_url, section)
            print(f"\n[Section]: {section}")
            print(f"   URL: {section_url}")
            
            html = self.fetch_page(section_url)
            if not html:
                print(f"   Status: FAILED or 404")
                continue
            
            print(f"   Status: OK")
            
            # Extract and filter articles
            articles = self.extract_articles(html, base_url, section, section_url)
            print(f"   Matching articles: {len(articles)}")
            
            # Show sample
            for i, article in enumerate(articles[:3], 1):
                print(f"      [{i}] {article['title'][:55]}...")
                print(f"          Keywords: {', '.join(article['matched_keywords'])}")
            
            if len(articles) > 3:
                print(f"      ... and {len(articles) - 3} more")
            
            all_articles.extend(articles)
            time.sleep(0.5)  # Respectful delay
        
        # Summary
        print(f"\n{'='*70}")
        print(f"CRAWL SUMMARY")
        print(f"{'='*70}")
        print(f"Sections crawled: {len(self.sections)}")
        print(f"Total articles found: {len(all_articles)}")
        
        return all_articles
    
    def crawl_and_save(self, base_url: str, keywords: List[str], output_file: str = None, source_name: str = None) -> str:
        """
        Crawl a website and save results to JSON
        
        Args:
            base_url: The website URL to crawl
            keywords: List of keywords to filter articles
            output_file: Output JSON file path (optional)
            source_name: Name of the source (optional)
        
        Returns:
            Path to the output file
        """
        source_name = source_name or urlparse(base_url).netloc
        
        # Crawl
        articles = self.crawl(base_url, source_name, keywords)
        
        # Add metadata
        for article in articles:
            article['source_name'] = source_name
            article['base_url'] = base_url
            article['discovered_via'] = 'active_crawl'
            article['discovered_at'] = datetime.now().isoformat()
        
        # Prepare output
        output = {
            'site': source_name,
            'base_url': base_url,
            'keywords': keywords,
            'total_articles': len(articles),
            'crawl_date': datetime.now().isoformat(),
            'articles': articles
        }
        
        # Save to file
        if not output_file:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            output_file = f"output/active_crawl_{timestamp}.json"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(output, f, indent=2, ensure_ascii=False)
        
        print(f"\nOutput saved to: {output_file}")
        return output_file


def main():
    """Main function to run active crawling"""
    
    # Example usage
    crawler = ActiveCrawler()
    
    # Define base URL and keywords
    base_url = "https://www.zawya.com"
    keywords = [
        'hindustan', 'chemical', 'hydrogen', 'sulphide', 
        'plant', 'project', 'construction', 'facility',
        'epc', 'epcm', 'petrochemical'
    ]
    
    # Crawl and save
    output_file = crawler.crawl_and_save(
        base_url=base_url,
        keywords=keywords,
        source_name="Zawya"
    )
    
    print(f"\nDone! Results saved to: {output_file}")


if __name__ == "__main__":
    main()
