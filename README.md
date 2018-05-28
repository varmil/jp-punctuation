### How to Use


###### Basic

```sh
# show all texts
cat json/001.json | jq -r .paragraphs[].cues[].text

# show only one paragraph
cat json/001.json | jq -r .paragraphs[0].cues[].text

# redirect to file
cat json/001.json | jq -r .paragraphs[0].cues[].text > raw_text/001.txt

# remove line breaks
cat json/001.json | jq -r '.paragraphs[].cues[].text | gsub("[\\n\\t]"; "")'
```
