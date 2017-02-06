rule '.md' => '.Rmd' do |t|
  sh "Rscript -e \"library(knitr); knit('#{t.source}', '#{t.name}')\""
end

rule '.pdf' => '.md' do |t|
  sh "pandoc -f markdown+inline_notes -V geometry:margin=1in --highlight-style tango #{t.source} -o #{t.name}"
end
