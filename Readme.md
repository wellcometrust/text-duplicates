Detecting plagiarism in 19th century sexual health books

We're aiming to make a thing that can:
* Take a pile of 19th century books from the Wellcome MHL
* Scan them to find matching sentences and paragraphs
* Display which books are most related
* For each book, be able to list which other books are related
* Compare matching paragraphs from two or more books next to each other

So far:
* We're importing some sample texts into elastic search
* We can search across these for sentences using kibana

Next:
* Calculate similarity/overlap of books
* Search and match sentences between books
* Make it visual (Gephi? D3.js?)
