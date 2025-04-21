from flask import Flask, request, jsonify
from flask_cors import CORS
from openai import OpenAI

app = Flask(__name__)
CORS(app)  # Flutter'dan gelen isteklere izin verir

client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key="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",
)

@app.route('/ask', methods=['POST'])
def ask_question():
    data = request.get_json()
    user_message = data.get("message", "")

    try:
        completion = client.chat.completions.create(
            extra_headers={
                "HTTP-Referer": "http://localhost:5000",  # Gerekirse düzenleyebilirsin
                "X-Title": "cryptoTracker Chat"
            },
            extra_body={},
            model="microsoft/mai-ds-r1:free",
            messages=[
                {
                    "role": "user",
                    "content": user_message
                }
            ]
        )

        return jsonify({
            "response": completion.choices[0].message.content
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
