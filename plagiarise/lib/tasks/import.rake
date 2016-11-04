namespace :import do

  desc "Run all tasks, to take us from an empty db to all the things populated"
  task :all => [:all_books, :to_elasticsearch, :build_elasticsearch_relations, :build_max_score]

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
      },
      {
        :title => "Brodie's medical work on virility",
        :author => "R.J. Brodie (and co.)",
        :year => "1843",
        :wellcome_id => "",
        :text_file => "../books/second_batch/brodie.txt",
        :original_source => "https://books.google.co.uk/books?id=WcgDAAAAQAAJ&dq=brodie%27s+virility&source=gbs_navlinks_s"
      },
      {
        :title => "A practical treatise on the prevention and cure of the venereal disease; particularly its consequences ... in which a mild and successful mode of treatment is pointed out",
        :author => " Caton, T. M. (Thomas Mott)",
        :year => "1809",
        :wellcome_id => "b22033294",
        :text_file => "../books/second_batch/caton.txt",
        :original_source => "https://archive.org/details/b22033294"
      },
      {
        :title => "The student's manual of venereal diseases : being a concise description of those affections and of their treatment",
        :author => " Hill, Berkeley, 1834-1892; Cooper, Arthur; University of Leeds. Library",
        :year => "1878",
        :wellcome_id => "b21516996",
        :text_file => "../books/second_batch/hill.txt",
        :original_source => "https://archive.org/details/b21516996"
      }
    ]



    books.each{|book|
      publication = Publication.new
      publication.title = book[:title]
      publication.author = book[:author]
      publication.year = book[:year]
      publication.wellcome_id = book[:wellcome_id]
      publication.original_url = book[:original_source]
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

  desc "Take all the sentences from the db, and put them in elastic search"
  task :to_elasticsearch => [:environment] do
    client = Elasticsearch::Client.new log: true

    # delete/wipe any existing index
    client.indices.delete index: 'publications'

    client.indices.create index: 'publications', body: {
      mappings: {
        document: {
          properties: {
            text: {
              type: 'string'
            },
            publication_title: {
              type: 'string'
            },
            publication_id: {
              type: 'string'
            }
          }
        }
      }
    }

    Sentence.all.each{|sentence|
      client.index index: 'publications', type: 'sentence', id: sentence.id, body: { text: sentence.text, publication_title: sentence.publication.title, publication_id: sentence.publication.id }
    }

    client.indices.refresh index: 'publications'

  end


  desc "For each sentence, use elasticsearch to find similar sentences"
  task :build_elasticsearch_relations => [:environment] do
    client = Elasticsearch::Client.new log: true
    Sentence.all.each{|sentence|
      result = client.search index: 'publications', body: {
        query: {
          bool: {
            must: [{
              match: {
                text: sentence.text
              }
            }],
            must_not: [{
              match: {
                publication_id: sentence.publication.id
              }
            }]
          }
        },
        highlight: {
          fields: {
            text: {}
          }
        }
      }

      sentence.max_score = result["hits"]["max_score"]
      sentence.save

      result["hits"]["hits"].each{|hit|
        similarity = Similarity.new
        similarity.original = sentence
        similarity.similar = Sentence.find(hit["_id"])
        similarity.score = hit["_score"]
        similarity.highlight = hit["highlight"]["text"].join(" ")

        similarity.save
      }
    }
  end

  desc "For each publication, calculate max_score"
  task :build_max_score => [:environment] do

    Publication.all.each{|publication|

      publication.max_score = publication.sentences.where.not('max_score' => nil).order("max_score DESC").first.max_score
      publication.save

    }

  end
end
