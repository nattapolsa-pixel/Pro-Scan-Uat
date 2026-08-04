import re
import subprocess
import sys

with open("index.html", "r", encoding="utf-8") as f:
    html = f.read()

# Extract script blocks
scripts = re.findall(r'<script>(.*?)</script>', html, re.DOTALL)
print(f"Found {len(scripts)} inline script blocks.")

full_js = "\n".join(scripts)

with open("scratch/temp_check.js", "w", encoding="utf-8") as f:
    f.write(full_js)

# Run node --check scratch/temp_check.js
try:
    res = subprocess.run(["node", "--check", "scratch/temp_check.js"], capture_output=True, text=True)
    if res.returncode == 0:
        print("✅ JavaScript Syntax Check PASSED cleanly!")
    else:
        print("🚨 JavaScript Syntax Error Found:")
        print(res.stderr)
except Exception as e:
    print(f"Execution error: {e}")
