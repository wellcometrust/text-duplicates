namespace :import do

  desc "Import a bunch of hardcoded books into rails db"
  task :all_books => [:environment] do
    books = [
      {
        :title => "Manhood: the causes of its premature decline",
        :author => "J L. Curtis",
        :year => "1852",
        :wellcome_id => "",
        :text_file => "../books/first_test/manhood_1852.txt",
        :original_source => "https://books.google.co.uk/books?id=AiEDAAAAQAAJ&amp;printsec=frontcover&amp;source=gbs_ge_summary_r&amp;cad=0"
      },
      {
        :title => "The silent friend: a medical work, on the disorders produced by the dangerous effects of onanism [&c.].",
        :author => "Perry R. and L. and co",
        :year => "1847",
        :wellcome_id => "",
        :text_file => "../books/first_test/silentfriend_1847.txt",
        :original_source => "https://books.google.co.uk/books/about/The_silent_friend_a_medical_work_on_the.html?id=rBUEAAAAQAAJ&redir_esc=y"
      },
      {
        :title => "Nervous exhaustion [electronic resource] : its cause and cure : comprising a series of lectures on debility and disease ... with practical information on marriage, its obligations and impediments",
        :author => "Kahn, L. J",
        :year => "1870",
        :wellcome_id => "",
        :text_file => "../books/first_test/nervous.txt",
        :original_source => "https://archive.org/details/b20391894"
      }
    ]



    books.each{|book|
      publication = Publication.new
      publication.title = book[:title]
      publication.author = book[:author]
      publication.year = book[:year]
      publication.wellcome_id = book[:wellcome_id]
      publication.save

      book_text = File.read(book[:text_file])
      book_sentences = Scalpel.cut(book_text)

      book_sentences.each{|s|
        sentence = Sentence.new
        sentence.text = s
        sentence.publication = publication
        sentence.save
      }
    }


  end

end
