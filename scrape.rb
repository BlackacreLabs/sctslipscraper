require 'bundler/setup'
require 'mechanize'

TERM_XPATH = ".//div[@class='dslist2']/ul/li[position()=1]/a"
PDF_XPATH = ".//table[@class='datatables']//tr/td[position()=4]/a"

a = Mechanize.new
a.pluggable_parser.pdf = Mechanize::FileSaver
a.get('http://www.supremecourt.gov/opinions/opinions.aspx') do |terms_page|
  terms_page.search(TERM_XPATH).each do |link|
    a.transact do
      opinions_page = a.click(link)
      puts opinions_page.title
      opinions_page.search(PDF_XPATH).each do |pdflink|
        puts "\tDownloading #{pdflink.attributes['href']}"
        a.transact { a.click(pdflink) }
      end
    end
  end
end
