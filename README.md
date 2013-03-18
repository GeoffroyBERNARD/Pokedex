# Pokedex

Extrait le pokedex depuis http://www.pokepedia.fr

## Utilisation

Extraire les textes de pokepedia.fr:

```bash
ruby src/extract.rb
```

Générer le pokedex au format JSON:

```bash
ruby src/to_json.rb data/txt/*
```
