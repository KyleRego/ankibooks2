import sys
import os
import json
import random
import string

import genanki

style = """
.card {
    font-family: sans-serif;
    font-size: 20px;
    text-align: center;
    color: black;
}
"""

def generateId():
    return random.randrange(1 << 30, 1 << 31)

def generateName(length = 32):
    return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(length))

def generateDeck(title):
    return genanki.Deck(
        generateId(),
        title
    )

def generateModel():
    return genanki.Model(
        1845328941,
        'AnkiBooksCloze',
        fields=[
            {'name': 'Text'},
            {'name': 'Images'}
        ],
        templates=[
            {
            'name': 'Card 1',
            'qfmt': '{{cloze:Text}}',
            'afmt': '{{cloze:Text}}<hr id="answer">{{hint:Images}}',
            }
        ],
        css = style,
        model_type=1 # cloze deletion model
    )

def main():
    args = sys.argv

    data = args[1]
    out_path = args[2]

    json_data = json.loads(data)

    anki_model = generateModel()

    deck_title = json_data['title']

    deck = generateDeck(deck_title)

    for raw_note in json_data['notes']:
        note = genanki.Note(
            model = anki_model,
            fields = [raw_note, '']
        )

        deck.add_note(note)

    package = genanki.Package(deck)
    
    filename = generateName() + '.apkg'

    package.write_to_file(os.path.join(out_path, filename))

    print(filename, end='')

if __name__ == "__main__":
    main()