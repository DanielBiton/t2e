from fastapi import FastAPI, Query
from pydantic import BaseModel

app = FastAPI()


EMOJI_RULES = [
    ("love", "❤️"),
    ("happy", "😄"),
    ("smile", "😊"),
    ("sad", "😢"),
    ("cry", "😭"),
    ("angry", "😠"),
    ("mad", "😡"),
    ("fire", "🔥"),
    ("cool", "😎"),
    ("ok", "👌"),
    ("yes", "✅"),
    ("no", "❌"),
    ("cat", "🐱"),
    ("dog", "🐶"),
    ("pizza", "🍕"),
    ("coffee", "☕"),
    ("laugh", "😂"),
    ("party", "🥳"),
    ("rocket", "🚀"),
]

DEFAULT_EMOJI = "🤔"


@app.get("/convert")
def convert(text: str = Query(..., min_length=1)):
    text = text.lower()
    for keyword, emoji in EMOJI_RULES:
        if keyword in text:
            return {"emoji": emoji}
    return {"emoji": DEFAULT_EMOJI}
