# Text Copying in 19th Century Sexual Health Books

This website is a product of Wellcome Data Week, and can be found at http://ghp.wellcomecollection.org/text-duplicates 

This site takes books from the Wellcome Medical Heritage Library and tries to find instances of copying between texts.

This repository features:
`/books` – various texts used either on the site or during development.
`/docs` – the website found at http://ghp.wellcomecollection.org/text-duplicates/
`/misc` – scripts used during exploration and development to understand the texts
`/plagiarise` – a Ruby on Rails app used to import books, find similarities and browse similarities. 

## Using the Ruby on Rails app

The Rails app includes a set of Rake tasks for importing books into both itself and elastic search. These rake tasks query elasticsearch and cache the results in the database. Elasticsearch is only used in the initial import, and is not needed while the Ruby on Rails app is running

## Generating the static site

To save hosting costs and ensure longevity, the ruby on rails site is saved as static html hosted as a Github Pages site.

This site is found in `/docs`.

The site is generated using wget: 

`wget --mirror --convert-links --adjust-extension --page-requisites --no-parent [rails-url]`

## Further information

More information on Wellcome Data Week can be found at:

* http://blog.wellcomelibrary.org/2016/11/meet-the-digital-data-dabblers/ 
* https://wordpress31554.wordpress.com/ 

## Next steps:

This site is a quick experiment to see what's possible and could be improved in many ways, including: 

* Importing more books into the system.
* Improve the design and interface.
* Improve how we're using elasticsearch to find similarities.
