import PyPDF2
from pathlib import Path


def load_text(path_str):
    path = Path(path_str)
    reader = PyPDF2.PdfReader(str(path))
    text = ""
    for page in reader.pages:
        txt = page.extract_text()
        if txt:
            text += txt + "\n"
    return text

rubric_text = load_text("rubric.pdf")
assign_text = load_text("docs/Assignment Description.pdf")

print("=== Rubric tasks overview ===")
for i in range(1, 8):
    key = f"Task {i}"
    idx = rubric_text.find(key)
    if idx == -1:
        continue
    start = max(0, idx - 150)
    end = min(len(rubric_text), idx + 1000)
    segment = rubric_text[start:end]
    try:
        out = segment.encode("gbk", "ignore").decode("gbk", "ignore")
    except Exception:
        out = segment
    print("\n---", key, "---")
    print(out)

print("\n=== Assignment tasks overview ===")
for i in range(1, 8):
    key = f"Task {i}"
    idx = assign_text.find(key)
    if idx == -1:
        continue
    start = max(0, idx - 150)
    end = min(len(assign_text), idx + 800)
    segment = assign_text[start:end]
    try:
        out = segment.encode("gbk", "ignore").decode("gbk", "ignore")
    except Exception:
        out = segment
    print("\n---", key, "---")
    print(out)
