# Swakopmund Tourist Attraction Review Automation

This project automates the extraction and AI-based summarization of user reviews for Swakopmund tourist attractions using Robot Framework, SeleniumLibrary, and Gemini (Google) AI. It is designed to extract reviews from Google Maps for several attractions, save them to text files, and generate structured summaries using Gemini, with all results and evidence organized in dedicated folders.

> **Note:** During development, I initially attempted to extract reviews from other platforms (such as TripAdvisor, Facebook, and Yelp). However, these sites presented significant obstacles due to reCAPTCHA, login requirements, and anti-bot protections. As a result, the solution focuses on Google Maps, which allows for more reliable automated extraction without requiring user authentication or solving CAPTCHAs. Images of failed tests are found in images_of_failed_tests folder.

## Features
- **Automated Review Extraction:**
  - Uses SeleniumLibrary to open Google Maps, scroll and extract user reviews for each attraction.
  - Supports Swakopmund Museum, Swakopmund Genocide Museum, Platz Am Meer Waterfront, Kristall Galerie, and Desert Explorers Adventure Centre.
  - The first test case (Swakopmund Museum) includes detailed step-by-step explanations as comments in the Robot Framework file to help new users understand the workflow. Other similar tests are provided without repeated comments for clarity and brevity.
- **Evidence Capture:**
  - Takes a screenshot of the reviews section for each extraction and saves it to `review_screenshots/`.
- **Review Summarization:**
  - After extraction, automatically calls a Python script to summarize reviews using Gemini (Google Generative AI).
  - Summaries are saved to `review_summaries/` with a consistent, structured format (grouped/sorted bullet points and a review grade).
- **Organized Output:**
  - Raw reviews are saved in `review_texts/`.
  - Summaries are saved in `review_summaries/`.
  - Screenshots are saved in `review_screenshots/`.
- **Robust Error Handling:**
  - Clear logging and error messages for missing files, API issues, or script errors.

## Project Structure
```
review_texts/           # Raw extracted reviews as .txt files
review_summaries/       # Gemini AI summaries as .txt files
review_screenshots/     # Screenshots of review extraction
swakopmund_attractions.robot  # Main Robot Framework suite
summarize_reviews_with_file.py # Python script for Gemini summarization
requirements.txt        # Python dependencies
```

## Prerequisites
- Python 3.8+
- Google Chrome browser
- ChromeDriver (matching your Chrome version)
- Robot Framework and required libraries
- Gemini API key (Google Generative AI)

## Installation
1. **Clone the repository** (or copy the project files).
2. **Install Python dependencies:**
   ```powershell
   pip install -r requirements.txt
   ```
3. **Set up your Gemini API key:**
   - In PowerShell (for the current session):
     ```powershell
     $env:GEMINI_API_KEY="your-gemini-api-key-here"
     ```
   - Or set it permanently in your system/user environment variables as `GEMINI_API_KEY`.
4. **Ensure ChromeDriver is in your PATH** (or specify its location in your SeleniumLibrary config).

## Usage
### 1. Run All Tests
To run all extraction and summarization tests:
```powershell
robot swakopmund_attractions.robot
```

### 2. Run a Single Extraction & Summarization
You can run a specific test case (e.g., for Platz Am Meer):
```powershell
robot --test "Extract Platz Am Meer Reviews From Google Maps" swakopmund_attractions.robot
```
This will extract reviews, save them, take a screenshot, and generate a Gemini summary.

### 3. Review Outputs
- **Raw reviews:** See `review_texts/` for `.txt` files.
- **Summaries:** See `review_summaries/` for Gemini summaries.
- **Screenshots:** See `review_screenshots/` for evidence images.
- **Logs/Reports:** See `log.html`, `report.html`, and `output.xml` for Robot Framework run details.

## Customization
- To add new attractions, duplicate an extraction test and update the Google Maps URL and output filenames.
- The summarization prompt is in `summarize_reviews_with_file.py` and can be further refined for your needs.

## Troubleshooting
- **Gemini API errors:** Ensure your API key is set and valid.
- **File not found:** Make sure extraction runs before summarization, and paths are correct.
- **Selenium/ChromeDriver issues:** Ensure ChromeDriver matches your Chrome version and is in your PATH.

## License
This project is for educational and demonstration purposes.
