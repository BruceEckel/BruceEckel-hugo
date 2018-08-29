---
date: '{{ now.Format "2006-01-02" }}'
published: false
title: {{ replace .TranslationBaseName "-" " " | title }}
url: {{ now.Format "/2006/01/02/" }}{{ .TranslationBaseName }}
author: "Bruce Eckel"
---

