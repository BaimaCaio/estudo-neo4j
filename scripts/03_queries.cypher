// ---------------------------------------------------------------------------
// 1. Contagem por tipo (deve bater: 196 rels, 7 tipos)
// ---------------------------------------------------------------------------
MATCH ()-[r]->()
RETURN type(r) AS tipo, count(r) AS quantidade
ORDER BY tipo;

// ---------------------------------------------------------------------------
// 2. Nota média por usuário
// ---------------------------------------------------------------------------
MATCH (u:Usuário)-[av:AVALIOU]->(:Música)
RETURN u.nome AS usuario, round(avg(av.nota) * 10) / 10 AS notaMedia
ORDER BY notaMedia DESC;

// ---------------------------------------------------------------------------
// 3. Músicas MPB que Caio ainda não avaliou (via CLASSIFICADA_COMO + GOSTA_DE indireto)
// ---------------------------------------------------------------------------
MATCH (u:Usuário { nome: 'Caio' })
MATCH (m:Música)-[:CLASSIFICADA_COMO]->(g:Gênero { nome: 'MPB' })
WHERE NOT (u)-[:AVALIOU]->(m)
RETURN m.nome AS musica, m.ano AS ano
ORDER BY ano;

// ---------------------------------------------------------------------------
// 4. Álbum completo: faixas via CONTÉM + artista via GRAVOU
// ---------------------------------------------------------------------------
MATCH (al:Álbum { nome: 'Que País É Este' })-[:CONTÉM]->(m:Música)<-[:GRAVOU]-(a:Artista)
RETURN al.nome AS album, collect(m.nome) AS faixas, a.nome AS artista;

// ---------------------------------------------------------------------------
// 5. Recomendação: artistas que Mariana curte → músicas gravadas, não avaliadas
// ---------------------------------------------------------------------------
MATCH (u:Usuário { nome: 'Mariana' })-[:GOSTA_DE]->(a:Artista)-[:GRAVOU]->(m:Música)
WHERE NOT (u)-[:AVALIOU]->(m)
RETURN DISTINCT a.nome AS artista, m.nome AS sugestao, m.ano AS ano
ORDER BY artista, ano;

// ---------------------------------------------------------------------------
// 6. Cadeia de influência até Radiohead (até 4 saltos)
// ---------------------------------------------------------------------------
MATCH path = (origem:Artista)-[:INFLUENCIOU*1..4]->(alvo:Artista { nome: 'Radiohead' })
RETURN [n IN nodes(path) | n.nome] AS cadeia
ORDER BY length(path)
LIMIT 10;

// ---------------------------------------------------------------------------
// 7. Gênero mais avaliado (soma de notas em músicas CLASSIFICADA_COMO)
// ---------------------------------------------------------------------------
MATCH (u:Usuário)-[av:AVALIOU]->(m:Música)-[:CLASSIFICADA_COMO]->(g:Gênero)
RETURN g.nome AS genero, sum(av.nota) AS somaNotas, count(av) AS avaliacoes
ORDER BY somaNotas DESC;

// ---------------------------------------------------------------------------
// 8. Usuários Premium que gostam do mesmo artista que Gabriel
// ---------------------------------------------------------------------------
MATCH (gabriel:Usuário { nome: 'Gabriel' })-[:GOSTA_DE]->(a:Artista)<-[:GOSTA_DE]-(outro:Usuário)
WHERE outro.plano = 'Premium' AND outro <> gabriel
RETURN DISTINCT outro.nome AS usuario, a.nome AS artistaEmComum
ORDER BY usuario, artistaEmComum;
