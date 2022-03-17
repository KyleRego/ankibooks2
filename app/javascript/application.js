// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import { marked } from 'marked';

document.addEventListener('turbo:load', function(){

const ankiExtension = {
  name: 'ankiNote',
  level: 'inline',
  start(src) { return src.match(/\[\[/)?.index; },
  tokenizer(src, tokens) {
    const rule = /^\[\[.*?\]\]/;
    const match = rule.exec(src);
    if (match) {
      return {
        type: 'ankiNote',
        raw: match[0],
        text: match[0].replace('[[', '').replace(']]', '').replace(/{{c\d::(.*?)}}/g, "<span class='ankiCloze'>$1</span>"),
        tokens: []
      };
    }
  },
  renderer(token) {
    return `<span class="ankiNote">${token.text}</span>`;
  }
};

marked.use({ extensions: [ankiExtension] });

try { // for views/articles/edit.html.erb

    const textArea = document.querySelector("#markdown-editor");
    const preview = document.querySelector("#preview");
    const updatePreviewButton = document.querySelector("#update-preview-button");

    function updatePreview(){
        preview.innerHTML = marked.parse(textArea.value);
    }
    updatePreview();

    updatePreviewButton.addEventListener('click', function(event){
        event.preventDefault();
        updatePreview();
    });

    const header1Button = document.querySelector("#header-1-button");
    const header2Button = document.querySelector("#header-2-button");
    const header3Button = document.querySelector("#header-3-button");
    const italicizeButton = document.querySelector("#italicize-button");
    const boldButton = document.querySelector("#bold-button");
    const codeButton = document.querySelector("#code-button");

    const c1Button = document.querySelector("#c1-button");
    const c2Button = document.querySelector("#c2-button");
    const ankiNoteButton = document.querySelector("#anki-note-button");

    // writes text1 to the start of the selection and text2 at the end of the selection
    function writeTextToMarkdownEditor(text1, text2="") {
        let start = textArea.selectionStart;
        let end = textArea.selectionEnd;
        textArea.setRangeText(text1, start, start);
        textArea.setRangeText(text2, end+text1.length, end+text1.length, 'end');
        textArea.focus();
    }

    // add click event lister to button which calls writeTextToMarkdownEditor
    function addClickEventToMarkdownEditorButton(button, text1, text2=""){
        button.addEventListener('click', function(event){
        event.preventDefault();
        writeTextToMarkdownEditor(text1, text2);
        })
    }

    addClickEventToMarkdownEditorButton(header1Button, "# ");
    addClickEventToMarkdownEditorButton(header2Button, "## ");
    addClickEventToMarkdownEditorButton(header3Button, "### ");
    addClickEventToMarkdownEditorButton(italicizeButton, "*", "*");
    addClickEventToMarkdownEditorButton(boldButton, "**", "**");
    addClickEventToMarkdownEditorButton(codeButton, "`", "`");
    addClickEventToMarkdownEditorButton(c1Button, "{{c1::", "}}");
    addClickEventToMarkdownEditorButton(c2Button, "{{c2::", "}}");
    addClickEventToMarkdownEditorButton(ankiNoteButton, "[[", "]]");

} catch (error) {
    console.log('from application.js content for articles/edit.html.erb')
    console.log(error)
}

try { // for views/books/show.html.erb
    let book_id = document.querySelector('.book-title').id.split('-')[5];
    let initial_article_id = document.querySelectorAll(".reader-article-tree-parts")[0].id.split('-')[7];
    let articleContentDiv = document.querySelector("#article-content-div");
    let readerArticleTreeParts = document.querySelectorAll(".reader-article-tree-parts");
  
    
    function loadArticleContent(book_id, article_id){
      let fetchResponsePromise = fetch(`/books/${book_id}/articles/${article_id}`)
      fetchResponsePromise
      .then(response => response.json())
      .then(function(data){
        articleContentDiv.innerHTML = marked.parse(data["content"]);
      })
    }
  
    loadArticleContent(book_id, initial_article_id);
  
    readerArticleTreeParts.forEach(function(element) {
      element.addEventListener('click', function(){
        let article_id = element.id.split('-')[7];
        loadArticleContent(book_id, article_id);
      });
    });
  
  } catch(error) {
    console.log('from application.js content for books/show.html.erb')
    console.log(error);
  }
});