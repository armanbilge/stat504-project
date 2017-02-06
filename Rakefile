rule '.pdf' => '.Rmd' do |t|
  sh "Rscript -e \"library(knitr); knitr::opts_chunk\\$set(dev = 'pdf'); knit('#{t.source}', 'tmp.md')\""
  sh "pandoc tmp.md -f markdown+inline_notes -V geometry:margin=1in --highlight-style tango -o #{t.name}"
end

rule '.html' => '.Rmd' do |t|
  sh "Rscript -e \"library(knitr); knitr::opts_chunk\\$set(dev = 'png'); knit('#{t.source}', 'tmp.md')\""
  sh "pandoc tmp.md -s -f markdown+inline_notes -t html5 --highlight-style tango --katex=https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.js -o #{t.name}"
end
