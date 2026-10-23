// =============================================================================
// Indicação de artistas para usuários — só Cypher, sem ML externo
// Troque $nomeUsuario ou use parâmetro { nome: 'Caio' }
// =============================================================================

// -----------------------------------------------------------------------------
// 1) Colaborativo (user-based): "quem curte os mesmos artistas que eu"
//    Ranqueia artistas que usuários parecidos curtem e eu ainda não curto.
// -----------------------------------------------------------------------------
:param nomeUsuario => 'Caio';

MATCH (eu:Usuário { nome: $nomeUsuario })-[:GOSTA_DE]->(emComum:Artista)<-[:GOSTA_DE]-(outro:Usuário)
WHERE outro <> eu
WITH eu, outro, count(emComum) AS afinidade
WHERE afinidade >= 2
ORDER BY afinidade DESC
LIMIT 8
MATCH (outro)-[:GOSTA_DE]->(rec:Artista)
WHERE NOT (eu)-[:GOSTA_DE]->(rec)
RETURN rec.nome AS artistaIndicado,
       count(DISTINCT outro) AS usuariosQueRecomendam,
       sum(afinidade) AS scoreAfinidade
ORDER BY usuariosQueRecomendam DESC, scoreAfinidade DESC
LIMIT 10;

// -----------------------------------------------------------------------------
// 2) Colaborativo + notas: peso extra se o "vizinho" também nota alto
//    músicas do mesmo gênero que eu já gosto.
// -----------------------------------------------------------------------------
MATCH (eu:Usuário { nome: $nomeUsuario })-[:GOSTA_DE]->(a:Artista)
MATCH (eu)-[av:AVALIOU]->(m:Música)-[:CLASSIFICADA_COMO]->(g:Gênero)
WHERE av.nota >= 8
WITH eu, collect(DISTINCT g) AS generosQueEuValorizo
UNWIND generosQueEuValorizo AS g
MATCH (outro:Usuário)-[:GOSTA_DE]->(rec:Artista)-[:GRAVOU]->(:Música)-[:CLASSIFICADA_COMO]->(g)
WHERE outro <> eu AND NOT (eu)-[:GOSTA_DE]->(rec)
RETURN rec.nome AS artistaIndicado,
       g.nome AS generoEmComum,
       count(DISTINCT outro) AS usuarios
ORDER BY usuarios DESC, artistaIndicado
LIMIT 10;

// -----------------------------------------------------------------------------
// 3) Conteúdo via grafo: artistas que GRAVAM no mesmo gênero dos meus favoritos
//    (sem depender de outro usuário).
// -----------------------------------------------------------------------------
MATCH (eu:Usuário { nome: $nomeUsuario })-[:GOSTA_DE]->(fav:Artista)-[:GRAVOU]->(:Música)-[:CLASSIFICADA_COMO]->(g:Gênero)
MATCH (rec:Artista)-[:GRAVOU]->(:Música)-[:CLASSIFICADA_COMO]->(g)
WHERE NOT (eu)-[:GOSTA_DE]->(rec) AND rec <> fav
RETURN rec.nome AS artistaIndicado,
       g.nome AS genero,
       count(DISTINCT fav) AS favoritosMeusNesseGenero
ORDER BY favoritosMeusNesseGenero DESC, rec.nome
LIMIT 10;

// -----------------------------------------------------------------------------
// 4) Influência: artistas alcançados por INFLUENCIOU a partir dos que eu curto
//    (descoberta estilo "radar de linhagem").
// -----------------------------------------------------------------------------
MATCH (eu:Usuário { nome: $nomeUsuario })-[:GOSTA_DE]->(fav:Artista)
MATCH path = (fav)-[:INFLUENCIOU*1..2]->(rec:Artista)
WHERE NOT (eu)-[:GOSTA_DE]->(rec)
RETURN rec.nome AS artistaIndicado,
       min(length(path)) AS distanciaInfluencia,
       collect(DISTINCT fav.nome)[..3] AS viaArtistas
ORDER BY distanciaInfluencia, artistaIndicado
LIMIT 10;

// -----------------------------------------------------------------------------
// 5) Híbrido (score simples): soma sinais colaborativo + gênero + influência
//    Um único ranking; ajuste os pesos W_* se quiser.
// -----------------------------------------------------------------------------
:param W_vizinho => 3;
:param W_genero => 2;
:param W_influencia => 1;

MATCH (eu:Usuário { nome: $nomeUsuario })
OPTIONAL MATCH (eu)-[:GOSTA_DE]->(f1:Artista)<-[:GOSTA_DE]-(viz:Usuário)-[:GOSTA_DE]->(rec:Artista)
WHERE viz <> eu AND NOT (eu)-[:GOSTA_DE]->(rec)
WITH eu, rec, count(DISTINCT viz) AS sVizinho
WHERE rec IS NOT NULL
OPTIONAL MATCH (eu)-[:GOSTA_DE]->(:Artista)-[:GRAVOU]->(:Música)-[:CLASSIFICADA_COMO]->(g:Gênero)<-[:CLASSIFICADA_COMO]-(:Música)<-[:GRAVOU]-(rec)
WITH eu, rec, sVizinho, count(DISTINCT g) AS sGenero
OPTIONAL MATCH (eu)-[:GOSTA_DE]->(f2:Artista)-[:INFLUENCIOU*1..2]->(rec)
WITH rec, sVizinho, sGenero, count(DISTINCT f2) AS sInfluencia
RETURN rec.nome AS artistaIndicado,
       coalesce(sVizinho, 0) * $W_vizinho
         + coalesce(sGenero, 0) * $W_genero
         + coalesce(sInfluencia, 0) * $W_influencia AS score,
       coalesce(sVizinho, 0) AS vizinhos,
       coalesce(sGenero, 0) AS generos,
       coalesce(sInfluencia, 0) AS influencias
ORDER BY score DESC, artistaIndicado
LIMIT 10;

// -----------------------------------------------------------------------------
// 6) "Para outro usuário" — mesma query 1, parametrizada (uso em app/API)
// -----------------------------------------------------------------------------
// cypher-shell: --param "nomeUsuario=>Mariana"
// Browser: :params { nomeUsuario: 'Mariana' }

MATCH (eu:Usuário { nome: $nomeUsuario })-[:GOSTA_DE]->(emComum:Artista)<-[:GOSTA_DE]-(outro:Usuário)
WHERE outro <> eu
WITH eu, outro, count(emComum) AS overlap
ORDER BY overlap DESC
LIMIT 5
MATCH (outro)-[:GOSTA_DE]->(rec:Artista)
WHERE NOT (eu)-[:GOSTA_DE]->(rec)
RETURN $nomeUsuario AS paraUsuario,
       rec.nome AS artistaIndicado,
       count(DISTINCT outro) AS score
ORDER BY score DESC
LIMIT 5;
