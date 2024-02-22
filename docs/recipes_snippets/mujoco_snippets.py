import markdown
md = markdown.Markdown(extensions=['pymdownx.snippets'], extension_configs={'pymdownx.snippets': {'url_download': True}})

# Convert .md to html
input_file_path = 'mujoco_pre.md'
with open(input_file_path, 'r', encoding='utf-8') as file:
    markdown_content = file.read()

html_content = md.convert(markdown_content)

# Save html as .md file
output_md_file_path = 'mujoco_result.md'
with open(output_md_file_path, 'w', encoding='utf-8') as md_file:
    md_file.write(html_content)


print(html_content)

