with open("index.html", "r", encoding="utf-8") as f:
    lines = f.readlines()

script_lines = lines[1343:4866]

stack = []
for idx, line in enumerate(script_lines, start=1344):
    in_single_quote = False
    in_double_quote = False
    in_backtick = False
    in_comment = False
    
    for c_idx, char in enumerate(line):
        if char == '/' and c_idx < len(line) - 1 and line[c_idx+1] == '/' and not (in_single_quote or in_double_quote or in_backtick):
            break # rest of line is comment
        if char == '"' and not (in_single_quote or in_backtick):
            in_double_quote = not in_double_quote
        elif char == "'" and not (in_double_quote or in_backtick):
            in_single_quote = not in_single_quote
        elif char == '`' and not (in_single_quote or in_double_quote):
            in_backtick = not in_backtick
        
        if not (in_single_quote or in_double_quote or in_backtick):
            if char in '({[':
                stack.append((char, idx, c_idx + 1))
            elif char in ')}]':
                if not stack:
                    print(f"🚨 UNMATCHED CLOSING '{char}' at line {idx}, col {c_idx + 1}")
                else:
                    top, top_line, top_col = stack.pop()
                    expected = {'(': ')', '{': '}', '[': ']'}[top]
                    if char != expected:
                        print(f"🚨 MISMATCH: expected '{expected}' for '{top}' (from L{top_line}:C{top_col}), but found '{char}' at L{idx}:C{c_idx+1}")

if stack:
    print(f"🚨 UNCLOSED ELEMENTS REMAIN: {len(stack)}")
    for top, line_no, col_no in stack[-10:]:
        print(f"   Unclosed '{top}' at L{line_no}:C{col_no}")
else:
    print("✅ Stack check clean!")
