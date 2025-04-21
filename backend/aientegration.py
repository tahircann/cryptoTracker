from openai import OpenAI

client = OpenAI(
  base_url="https://openrouter.ai/api/v1",
  api_key="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",
)

completion = client.chat.completions.create(
  extra_headers={
    "HTTP-Referer": "<YOUR_SITE_URL>", # Optional. Site URL for rankings on openrouter.ai.
    "X-Title": "<YOUR_SITE_NAME>", # Optional. Site title for rankings on openrouter.ai.
  },
  extra_body={},
  model="microsoft/mai-ds-r1:free",
  messages=[
    {
      "role": "user",
      "content": "Questions about cryptocurency"
    }
  ]
)
print(completion.choices[0].message.content)