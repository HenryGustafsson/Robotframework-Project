import google.generativeai as genai
import os

def summarize_reviews_with_gemini(api_key, reviews_path, model="models/gemini-2.0-flash"):
    genai.configure(api_key=api_key)
    with open(reviews_path, "r", encoding="utf-8") as f:
        reviews = f.read()
    model_obj = genai.GenerativeModel(model)
    response = model_obj.generate_content(
        f"Analyze the following reviews and summarize the main good and bad points as bullet points. If there is similar bulletpoints, combine them and add plus one point to that. Lastly rearrange bulletpoints according how many points it has from high to low amount.\nReviews:\n{reviews}\nSummary:\nGood:\n-"
    )
    return response.text

if __name__ == "__main__":
    import sys
    api_key = os.getenv("GEMINI_API_KEY") or "AIzaSyA3bMDhO2eHzMUUt6-lX50-9fLEXFp04u4"
    reviews_path = "museum_reviews.txt"
    summary = summarize_reviews_with_gemini(api_key, reviews_path)
    print("\n===== SUMMARY =====\n")
    print(summary)
