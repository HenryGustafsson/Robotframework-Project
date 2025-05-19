import sys
import os
import google.generativeai as genai

# Function to summarize reviews using Gemini API
# - Reads reviews from a text file
# - Sends a prompt to Gemini to analyze and summarize the reviews
# - Returns the summary text
# - Handles file not found and API errors robustly

def summarize_reviews_with_gemini(api_key, reviews_path, model="models/gemini-2.0-flash"):
    # Check if the reviews file exists
    if not os.path.isfile(reviews_path):
        print(f"ERROR: Review file not found: {reviews_path}", file=sys.stderr)
        sys.exit(1)
    # Configure Gemini API with the provided API key
    genai.configure(api_key=api_key)
    # Read all reviews from the file
    with open(reviews_path, "r", encoding="utf-8") as f:
        reviews = f.read()
    # Initialize the Gemini model
    model_obj = genai.GenerativeModel(model)
    # Compose a detailed prompt for Gemini to analyze the reviews
    prompt = (
        "You are an expert review analyst."
        " Analyze the following user reviews for a tourist attraction."
        " Your task:"
        "\n1. Identify and group the main good points and bad points as bullet points."
        "\n2. If similar points appear multiple times, merge them and indicate the total count in parentheses, e.g. (17)."
        "\n3. Sort bullet points in good and bad points section from most points to least points."
        "\n4. After the bullet points, provide a single overall review grade from 0 to 5 stars (in 0.1 increments) based on the balance of good and bad feedback."
        "\n5. Use this output format exactly:"
        "\n\nGood Points:"
        "\n- <point> (<count if >1>)"
        "\n..."
        "\n\nBad Points:"
        "\n- <point> (<count if >1>)"
        "\n..."
        "\n\nReview Grade: <number> / 5 stars"
        f"\n\nREVIEWS:\n{reviews}\n"
    )
    # Generate the summary using Gemini
    response = model_obj.generate_content(prompt)
    return response.text

if __name__ == "__main__":
    # Check for correct usage
    if len(sys.argv) < 2:
        print("Usage: python summarize_reviews_with_file.py <reviews_file>", file=sys.stderr)
        sys.exit(1)
    reviews_path = sys.argv[1]
    # Get Gemini API key from environment variable
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("ERROR: GEMINI_API_KEY environment variable not set.", file=sys.stderr)
        sys.exit(1)
    try:
        # Call the summarization function and print the result
        summary = summarize_reviews_with_gemini(api_key, reviews_path)
        print("\n===== SUMMARY =====\n")
        print(summary)
    except Exception as e:
        # Print any errors to stderr and exit with error code
        print(f"Gemini script failed. See stderr above.\n{e}", file=sys.stderr)
        sys.exit(1)
