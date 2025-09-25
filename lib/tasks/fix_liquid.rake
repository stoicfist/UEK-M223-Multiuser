namespace :templates do
  desc "Fix leere Liquid-if in Templates"
  task fix_liquid: :environment do
    fixed = 0
    LatexTemplate.find_each do |lt|
      new_body = lt.body.to_s
                      .sub(/^%%%.*\n/, "%%% LaTeXHub Default A4 Template\n")
                      .gsub(/{%\s*if\s*%}/, "")
      next if new_body == lt.body
      lt.update!(body: new_body)
      fixed += 1
    end
    puts "Gefixt: #{fixed} Templates"
  end
end