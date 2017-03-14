rule '.pdf' => '.Rmd' do |t|
  sh "Rscript -e \"library(knitr); knitr::opts_chunk\\$set(dev = 'pdf'); knit('#{t.source}', 'tmp.md')\""
  sh "pandoc tmp.md -f markdown+inline_notes --filter pandoc-citeproc -V geometry:margin=1in --highlight-style tango -o #{t.name}"
end

rule '.html' => '.Rmd' do |t|
  sh "Rscript -e \"library(knitr); knitr::opts_chunk\\$set(dev = 'png'); knit('#{t.source}', 'tmp.md')\""
  sh "pandoc tmp.md -s -f markdown+inline_notes -t html5 --filter pandoc-citeproc --highlight-style tango --katex=https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.js -o #{t.name}"
end

file 'presentation.html' => 'presentation.Rmd' do |t|
  sh "Rscript -e \"library(knitr); knitr::opts_chunk\\$set(dev = 'svg'); knit('#{t.source}', 'tmp.md')\""
  sh "pandoc tmp.md -s -t revealjs -V theme:sky -V revealjs-url=http://lab.hakim.se/reveal-js --section-divs --highlight-style tango --katex=https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.js -o #{t.name}"
end

file 'poster.tex' => 'poster.Rnw' do |t|
  sh "Rscript -e \"library(knitr); knitr::opts_chunk\\$set(dev = 'pdf'); knit('#{t.source}', '#{t.name}')\""
end

file 'poster.pdf' => 'poster.tex' do |t|
  sh "pdflatex #{t.source}"
end
