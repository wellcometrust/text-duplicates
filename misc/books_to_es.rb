require 'scalpel'
require 'similarity'
require 'elasticsearch'

files = [
  'manhood/b21114444-0.txt',
  'silentfriend/silentfriendame00cogoog_djvu.txt',
  'nervousexhaustion.txt',
  'b28114759_djvu.txt',
  'b22382379_djvu.txt',
  'b22033294_djvu.txt',
  'b22027257_djvu.txt',
  'b21939743_djvu.txt',
  'b20407385_djvu.txt'
]


# lets put manhood into elasticsearch
client = Elasticsearch::Client.new log: true

# delete/wipe any existing index
client.indices.delete index: 'publications'

# create a publications index
client.indices.create index: 'publications',
                      body: {
                        mappings: {
                          document: {
                            properties: {
                              content: {
                                type: 'string'
                              }
                            }
                          }
                        }
                      }


files.each_with_index{|path, index|
  book = File.read("../books/" + path)
  book_sentences = Scalpel.cut(book)

  # add something
  client.index index: 'publications', type: 'publication', id: index, body: { content: book_sentences }

}

# refresh?
client.indices.refresh index: 'publications'
