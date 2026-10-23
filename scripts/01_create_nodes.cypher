// Carga legível (sem UNIQUE IMPORT LABEL). Equivalente aos nós do export APOC.
MATCH (n) DETACH DELETE n;

UNWIND [
  { nome: 'Caio', idade: 30, cidade: 'Fortaleza', plano: 'Premium' },
  { nome: 'Jorge', idade: 28, cidade: 'Recife', plano: 'Gratuito' },
  { nome: 'Lucas', idade: 25, cidade: 'São Paulo', plano: 'Premium' },
  { nome: 'Gabriel', idade: 32, cidade: 'Fortaleza', plano: 'Gratuito' },
  { nome: 'Ethan', idade: 27, cidade: 'Curitiba', plano: 'Premium' },
  { nome: 'Chrono', idade: 29, cidade: 'Belo Horizonte', plano: 'Gratuito' },
  { nome: 'Tiburcio', idade: 35, cidade: 'Salvador', plano: 'Premium' },
  { nome: 'Jubileu', idade: 24, cidade: 'Recife', plano: 'Gratuito' },
  { nome: 'Mariana', idade: 26, cidade: 'Fortaleza', plano: 'Premium' },
  { nome: 'Felipinho', idade: 31, cidade: 'São Paulo', plano: 'Gratuito' }
] AS row
CREATE (:Usuário { nome: row.nome, idade: row.idade, cidade: row.cidade, plano: row.plano });

UNWIND [
  'Rock brasileiro', 'MPB', 'Tropicália', 'Bossa nova',
  'Rock', 'Rock progressivo', 'Rock alternativo', 'Post-punk'
] AS nome
CREATE (:Gênero { nome: nome });

UNWIND [
  { nome: 'Fagner', genero: 'MPB' },
  { nome: 'Belchior', genero: 'MPB' },
  { nome: 'Legião Urbana', genero: 'Rock brasileiro' },
  { nome: 'Engenheiros do Hawaii', genero: 'Rock brasileiro' },
  { nome: 'Pink Floyd', genero: 'Rock progressivo' },
  { nome: 'The Beatles', genero: 'Rock' },
  { nome: 'Radiohead', genero: 'Rock alternativo' },
  { nome: 'The Cure', genero: 'Post-punk' },
  { nome: 'Joy Division', genero: 'Post-punk' },
  { nome: 'The Smiths', genero: 'Indie rock' },
  { nome: 'David Bowie', genero: 'Glam rock' },
  { nome: 'Black Sabbath', genero: 'Heavy metal' },
  { nome: 'Iron Maiden', genero: 'Heavy metal' },
  { nome: 'Metallica', genero: 'Thrash metal' },
  { nome: 'Daft Punk', genero: 'Eletrônica' },
  { nome: 'Kraftwerk', genero: 'Eletrônica' },
  { nome: 'Chico Buarque', genero: 'MPB' },
  { nome: 'Caetano Veloso', genero: 'MPB' },
  { nome: 'Milton Nascimento', genero: 'MPB' },
  { nome: 'Tom Jobim', genero: 'Bossa nova' },
  { nome: 'Casa das Máquinas', genero: 'Rock brasileiro' }
] AS row
CREATE (:Artista { nome: row.nome, genero: row.genero });

UNWIND [
  'Dois', 'As Quatro Estações', 'Que País É Este', 'A Revolta dos Dândis',
  'O Papa é Pop', 'Longe Demais das Capitais', 'Manera Fru Fru, Manera',
  'Pedras que Cantam', 'Alucinação', 'Construção', 'Apesar de Você',
  'Caetano Veloso', 'Muito', 'Travessia', 'Getz/Gilberto',
  'Hey Jude', 'Abbey Road', 'The Wall', 'Wish You Were Here',
  'Pablo Honey', 'OK Computer', 'Kiss Me Kiss Me Kiss Me', 'Closer',
  'The Queen Is Dead'
] AS nome
CREATE (:Álbum { nome: nome });

UNWIND [
  { nome: 'Tempo Perdido', ano: 1986 },
  { nome: 'Pais e Filhos', ano: 1989 },
  { nome: 'Faroeste Caboclo', ano: 1987 },
  { nome: 'Infinita Highway', ano: 1987 },
  { nome: 'O Papa é Pop', ano: 1990 },
  { nome: 'Toda Forma de Poder', ano: 1986 },
  { nome: 'Asa Branca', ano: 1973 },
  { nome: 'Borbulhas de Amor', ano: 1991 },
  { nome: 'Como Nossos Pais', ano: 1976 },
  { nome: 'Apenas um Rapaz Latino-Americano', ano: 1976 },
  { nome: 'Construção', ano: 1971 },
  { nome: 'Apesar de Você', ano: 1970 },
  { nome: 'Alegria, Alegria', ano: 1968 },
  { nome: 'Sampa', ano: 1978 },
  { nome: 'Travessia', ano: 1967 },
  { nome: 'Garota de Ipanema', ano: 1964 },
  { nome: 'Hey Jude', ano: 1968 },
  { nome: 'Come Together', ano: 1969 },
  { nome: 'Comfortably Numb', ano: 1979 },
  { nome: 'Wish You Were Here', ano: 1975 },
  { nome: 'Creep', ano: 1993 },
  { nome: 'Karma Police', ano: 1997 },
  { nome: 'Just Like Heaven', ano: 1987 },
  { nome: 'Love Will Tear Us Apart', ano: 1980 },
  { nome: 'Enjoy the Silence', ano: 1986 }
] AS row
CREATE (:Música { nome: row.nome, ano: row.ano });
