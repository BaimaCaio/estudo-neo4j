// Gerado por scripts/build_from_apoc_export.py — espelho de apoc-export.json
// 196 relacionamentos, 88 nós.

// Usuário —[:AVALIOU { nota }]→ Música
UNWIND [
  { usuario: "Caio", musica: "Tempo Perdido", nota: 10 },
  { usuario: "Caio", musica: "Construção", nota: 9 },
  { usuario: "Caio", musica: "Comfortably Numb", nota: 10 },
  { usuario: "Caio", musica: "Creep", nota: 8 },
  { usuario: "Jorge", musica: "Hey Jude", nota: 9 },
  { usuario: "Jorge", musica: "Come Together", nota: 8 },
  { usuario: "Jorge", musica: "Wish You Were Here", nota: 10 },
  { usuario: "Lucas", musica: "Creep", nota: 7 },
  { usuario: "Lucas", musica: "Karma Police", nota: 10 },
  { usuario: "Lucas", musica: "Just Like Heaven", nota: 9 },
  { usuario: "Gabriel", musica: "Tempo Perdido", nota: 9 },
  { usuario: "Gabriel", musica: "Infinita Highway", nota: 10 },
  { usuario: "Gabriel", musica: "O Papa é Pop", nota: 8 },
  { usuario: "Ethan", musica: "Hey Jude", nota: 8 },
  { usuario: "Ethan", musica: "Love Will Tear Us Apart", nota: 10 },
  { usuario: "Ethan", musica: "Enjoy the Silence", nota: 9 },
  { usuario: "Chrono", musica: "Pais e Filhos", nota: 9 },
  { usuario: "Chrono", musica: "Sampa", nota: 8 },
  { usuario: "Chrono", musica: "Travessia", nota: 10 },
  { usuario: "Tiburcio", musica: "Faroeste Caboclo", nota: 10 },
  { usuario: "Tiburcio", musica: "Asa Branca", nota: 8 },
  { usuario: "Tiburcio", musica: "Como Nossos Pais", nota: 9 },
  { usuario: "Jubileu", musica: "Borbulhas de Amor", nota: 9 },
  { usuario: "Jubileu", musica: "Construção", nota: 10 },
  { usuario: "Jubileu", musica: "Alegria, Alegria", nota: 8 },
  { usuario: "Mariana", musica: "Wish You Were Here", nota: 9 },
  { usuario: "Mariana", musica: "Karma Police", nota: 8 },
  { usuario: "Mariana", musica: "Just Like Heaven", nota: 10 },
  { usuario: "Felipinho", musica: "Infinita Highway", nota: 8 },
  { usuario: "Felipinho", musica: "Come Together", nota: 10 },
  { usuario: "Felipinho", musica: "Comfortably Numb", nota: 9 }
] AS row
MATCH (a:Usuário { nome: row.usuario }), (b:Música { nome: row.musica })
CREATE (a)-[:AVALIOU { nota: row.nota }]->(b);

// Usuário —[:GOSTA_DE]→ Artista
UNWIND [
  { usuario: "Caio", artista: "Engenheiros do Hawaii" },
  { usuario: "Caio", artista: "Radiohead" },
  { usuario: "Caio", artista: "Black Sabbath" },
  { usuario: "Jorge", artista: "Fagner" },
  { usuario: "Jorge", artista: "Pink Floyd" },
  { usuario: "Jorge", artista: "The Beatles" },
  { usuario: "Jorge", artista: "David Bowie" },
  { usuario: "Jorge", artista: "Chico Buarque" },
  { usuario: "Jorge", artista: "Tom Jobim" },
  { usuario: "Lucas", artista: "Belchior" },
  { usuario: "Lucas", artista: "Pink Floyd" },
  { usuario: "Lucas", artista: "Black Sabbath" },
  { usuario: "Lucas", artista: "Iron Maiden" },
  { usuario: "Lucas", artista: "Metallica" },
  { usuario: "Lucas", artista: "Daft Punk" },
  { usuario: "Lucas", artista: "Kraftwerk" },
  { usuario: "Lucas", artista: "Casa das Máquinas" },
  { usuario: "Gabriel", artista: "Legião Urbana" },
  { usuario: "Gabriel", artista: "The Cure" },
  { usuario: "Gabriel", artista: "Joy Division" },
  { usuario: "Gabriel", artista: "The Smiths" },
  { usuario: "Ethan", artista: "The Cure" },
  { usuario: "Chrono", artista: "The Beatles" },
  { usuario: "Chrono", artista: "Radiohead" },
  { usuario: "Chrono", artista: "The Smiths" },
  { usuario: "Chrono", artista: "David Bowie" },
  { usuario: "Chrono", artista: "Caetano Veloso" },
  { usuario: "Chrono", artista: "Milton Nascimento" },
  { usuario: "Chrono", artista: "Tom Jobim" },
  { usuario: "Tiburcio", artista: "Legião Urbana" },
  { usuario: "Tiburcio", artista: "Engenheiros do Hawaii" },
  { usuario: "Tiburcio", artista: "Pink Floyd" },
  { usuario: "Tiburcio", artista: "Black Sabbath" },
  { usuario: "Tiburcio", artista: "Iron Maiden" },
  { usuario: "Tiburcio", artista: "Metallica" },
  { usuario: "Jubileu", artista: "Fagner" },
  { usuario: "Jubileu", artista: "Belchior" },
  { usuario: "Jubileu", artista: "Chico Buarque" },
  { usuario: "Mariana", artista: "Legião Urbana" },
  { usuario: "Mariana", artista: "Radiohead" },
  { usuario: "Mariana", artista: "The Cure" },
  { usuario: "Mariana", artista: "Joy Division" },
  { usuario: "Mariana", artista: "The Smiths" },
  { usuario: "Mariana", artista: "David Bowie" },
  { usuario: "Mariana", artista: "Daft Punk" },
  { usuario: "Mariana", artista: "Kraftwerk" },
  { usuario: "Mariana", artista: "Casa das Máquinas" },
  { usuario: "Felipinho", artista: "Fagner" },
  { usuario: "Felipinho", artista: "Pink Floyd" },
  { usuario: "Felipinho", artista: "The Beatles" },
  { usuario: "Felipinho", artista: "Caetano Veloso" },
  { usuario: "Felipinho", artista: "Milton Nascimento" }
] AS row
MATCH (a:Usuário { nome: row.usuario }), (b:Artista { nome: row.artista })
CREATE (a)-[:GOSTA_DE]->(b);

// Artista —[:INFLUENCIOU]→ Artista
UNWIND [
  { de: "Belchior", para: "Fagner" },
  { de: "Legião Urbana", para: "Engenheiros do Hawaii" },
  { de: "Pink Floyd", para: "Radiohead" },
  { de: "The Beatles", para: "Radiohead" },
  { de: "The Beatles", para: "David Bowie" },
  { de: "The Cure", para: "Radiohead" },
  { de: "Joy Division", para: "The Cure" },
  { de: "David Bowie", para: "Radiohead" },
  { de: "David Bowie", para: "The Cure" },
  { de: "Black Sabbath", para: "Iron Maiden" },
  { de: "Iron Maiden", para: "Metallica" },
  { de: "Kraftwerk", para: "Daft Punk" },
  { de: "Caetano Veloso", para: "Chico Buarque" },
  { de: "Tom Jobim", para: "Milton Nascimento" }
] AS row
MATCH (a:Artista { nome: row.de }), (b:Artista { nome: row.para })
CREATE (a)-[:INFLUENCIOU]->(b);

// Artista —[:LANÇOU]→ Álbum
UNWIND [
  { artista: "Fagner", album: "Manera Fru Fru, Manera" },
  { artista: "Fagner", album: "Pedras que Cantam" },
  { artista: "Belchior", album: "Alucinação" },
  { artista: "Legião Urbana", album: "Dois" },
  { artista: "Legião Urbana", album: "As Quatro Estações" },
  { artista: "Legião Urbana", album: "Que País É Este" },
  { artista: "Engenheiros do Hawaii", album: "A Revolta dos Dândis" },
  { artista: "Engenheiros do Hawaii", album: "O Papa é Pop" },
  { artista: "Engenheiros do Hawaii", album: "Longe Demais das Capitais" },
  { artista: "Pink Floyd", album: "The Wall" },
  { artista: "Pink Floyd", album: "Wish You Were Here" },
  { artista: "The Beatles", album: "Hey Jude" },
  { artista: "The Beatles", album: "Abbey Road" },
  { artista: "Radiohead", album: "Pablo Honey" },
  { artista: "Radiohead", album: "OK Computer" },
  { artista: "The Cure", album: "Kiss Me Kiss Me Kiss Me" },
  { artista: "Joy Division", album: "Closer" },
  { artista: "The Smiths", album: "The Queen Is Dead" },
  { artista: "Chico Buarque", album: "Construção" },
  { artista: "Chico Buarque", album: "Apesar de Você" },
  { artista: "Caetano Veloso", album: "Caetano Veloso" },
  { artista: "Caetano Veloso", album: "Muito" },
  { artista: "Milton Nascimento", album: "Travessia" },
  { artista: "Tom Jobim", album: "Getz/Gilberto" }
] AS row
MATCH (a:Artista { nome: row.artista }), (b:Álbum { nome: row.album })
CREATE (a)-[:LANÇOU]->(b);

// Artista —[:GRAVOU]→ Música
UNWIND [
  { artista: "Fagner", musica: "Asa Branca" },
  { artista: "Fagner", musica: "Borbulhas de Amor" },
  { artista: "Belchior", musica: "Como Nossos Pais" },
  { artista: "Belchior", musica: "Apenas um Rapaz Latino-Americano" },
  { artista: "Legião Urbana", musica: "Tempo Perdido" },
  { artista: "Legião Urbana", musica: "Pais e Filhos" },
  { artista: "Legião Urbana", musica: "Faroeste Caboclo" },
  { artista: "Engenheiros do Hawaii", musica: "Infinita Highway" },
  { artista: "Engenheiros do Hawaii", musica: "O Papa é Pop" },
  { artista: "Engenheiros do Hawaii", musica: "Toda Forma de Poder" },
  { artista: "Pink Floyd", musica: "Comfortably Numb" },
  { artista: "Pink Floyd", musica: "Wish You Were Here" },
  { artista: "The Beatles", musica: "Hey Jude" },
  { artista: "The Beatles", musica: "Come Together" },
  { artista: "Radiohead", musica: "Creep" },
  { artista: "Radiohead", musica: "Karma Police" },
  { artista: "The Cure", musica: "Just Like Heaven" },
  { artista: "Joy Division", musica: "Love Will Tear Us Apart" },
  { artista: "The Smiths", musica: "Enjoy the Silence" },
  { artista: "Chico Buarque", musica: "Construção" },
  { artista: "Chico Buarque", musica: "Apesar de Você" },
  { artista: "Caetano Veloso", musica: "Alegria, Alegria" },
  { artista: "Caetano Veloso", musica: "Sampa" },
  { artista: "Milton Nascimento", musica: "Travessia" },
  { artista: "Tom Jobim", musica: "Garota de Ipanema" }
] AS row
MATCH (a:Artista { nome: row.artista }), (b:Música { nome: row.musica })
CREATE (a)-[:GRAVOU]->(b);

// Música —[:CLASSIFICADA_COMO]→ Gênero
UNWIND [
  { musica: "Tempo Perdido", genero: "Rock brasileiro" },
  { musica: "Pais e Filhos", genero: "Rock brasileiro" },
  { musica: "Faroeste Caboclo", genero: "Rock brasileiro" },
  { musica: "Infinita Highway", genero: "Rock brasileiro" },
  { musica: "O Papa é Pop", genero: "Rock brasileiro" },
  { musica: "Toda Forma de Poder", genero: "Rock brasileiro" },
  { musica: "Asa Branca", genero: "MPB" },
  { musica: "Borbulhas de Amor", genero: "MPB" },
  { musica: "Como Nossos Pais", genero: "MPB" },
  { musica: "Apenas um Rapaz Latino-Americano", genero: "MPB" },
  { musica: "Construção", genero: "MPB" },
  { musica: "Apesar de Você", genero: "MPB" },
  { musica: "Alegria, Alegria", genero: "Tropicália" },
  { musica: "Sampa", genero: "MPB" },
  { musica: "Travessia", genero: "MPB" },
  { musica: "Garota de Ipanema", genero: "Bossa nova" },
  { musica: "Hey Jude", genero: "Rock" },
  { musica: "Come Together", genero: "Rock" },
  { musica: "Comfortably Numb", genero: "Rock progressivo" },
  { musica: "Wish You Were Here", genero: "Rock progressivo" },
  { musica: "Creep", genero: "Rock alternativo" },
  { musica: "Karma Police", genero: "Rock alternativo" },
  { musica: "Just Like Heaven", genero: "Rock alternativo" },
  { musica: "Love Will Tear Us Apart", genero: "Post-punk" },
  { musica: "Enjoy the Silence", genero: "Rock alternativo" }
] AS row
MATCH (a:Música { nome: row.musica }), (b:Gênero { nome: row.genero })
CREATE (a)-[:CLASSIFICADA_COMO]->(b);

// Álbum —[:CONTÉM]→ Música
UNWIND [
  { album: "Dois", musica: "Tempo Perdido" },
  { album: "As Quatro Estações", musica: "Pais e Filhos" },
  { album: "Que País É Este", musica: "Faroeste Caboclo" },
  { album: "A Revolta dos Dândis", musica: "Infinita Highway" },
  { album: "O Papa é Pop", musica: "O Papa é Pop" },
  { album: "Longe Demais das Capitais", musica: "Toda Forma de Poder" },
  { album: "Manera Fru Fru, Manera", musica: "Asa Branca" },
  { album: "Pedras que Cantam", musica: "Borbulhas de Amor" },
  { album: "Alucinação", musica: "Como Nossos Pais" },
  { album: "Alucinação", musica: "Apenas um Rapaz Latino-Americano" },
  { album: "Construção", musica: "Construção" },
  { album: "Apesar de Você", musica: "Apesar de Você" },
  { album: "Caetano Veloso", musica: "Alegria, Alegria" },
  { album: "Muito", musica: "Sampa" },
  { album: "Travessia", musica: "Travessia" },
  { album: "Getz/Gilberto", musica: "Garota de Ipanema" },
  { album: "Hey Jude", musica: "Hey Jude" },
  { album: "Abbey Road", musica: "Come Together" },
  { album: "The Wall", musica: "Comfortably Numb" },
  { album: "Wish You Were Here", musica: "Wish You Were Here" },
  { album: "Pablo Honey", musica: "Creep" },
  { album: "OK Computer", musica: "Karma Police" },
  { album: "Kiss Me Kiss Me Kiss Me", musica: "Just Like Heaven" },
  { album: "Closer", musica: "Love Will Tear Us Apart" },
  { album: "The Queen Is Dead", musica: "Enjoy the Silence" }
] AS row
MATCH (a:Álbum { nome: row.album }), (b:Música { nome: row.musica })
CREATE (a)-[:CONTÉM]->(b);
