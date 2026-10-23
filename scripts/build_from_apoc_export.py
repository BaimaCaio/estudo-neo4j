#!/usr/bin/env python3
"""Gera data.cypher e 02_create_relationships.cypher a partir de apoc-export.json."""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPORT_JSON = ROOT / "apoc-export.json"

ID_NAME: dict[int, tuple[str, str]] = {
    0: ("Usuário", "Caio"),
    1: ("Usuário", "Jorge"),
    2: ("Usuário", "Lucas"),
    3: ("Usuário", "Gabriel"),
    4: ("Usuário", "Ethan"),
    5: ("Usuário", "Chrono"),
    6: ("Usuário", "Tiburcio"),
    7: ("Usuário", "Jubileu"),
    8: ("Usuário", "Mariana"),
    9: ("Usuário", "Felipinho"),
    10: ("Artista", "Fagner"),
    11: ("Artista", "Belchior"),
    12: ("Artista", "Legião Urbana"),
    13: ("Artista", "Engenheiros do Hawaii"),
    14: ("Artista", "Pink Floyd"),
    15: ("Artista", "The Beatles"),
    16: ("Artista", "Radiohead"),
    17: ("Artista", "The Cure"),
    18: ("Artista", "Joy Division"),
    19: ("Artista", "The Smiths"),
    20: ("Artista", "David Bowie"),
    21: ("Artista", "Black Sabbath"),
    22: ("Artista", "Iron Maiden"),
    23: ("Artista", "Metallica"),
    24: ("Artista", "Daft Punk"),
    25: ("Artista", "Kraftwerk"),
    26: ("Artista", "Chico Buarque"),
    27: ("Artista", "Caetano Veloso"),
    28: ("Artista", "Milton Nascimento"),
    29: ("Artista", "Tom Jobim"),
    30: ("Artista", "Casa das Máquinas"),
    31: ("Música", "Tempo Perdido"),
    32: ("Música", "Pais e Filhos"),
    33: ("Música", "Faroeste Caboclo"),
    34: ("Música", "Infinita Highway"),
    35: ("Música", "O Papa é Pop"),
    36: ("Música", "Toda Forma de Poder"),
    37: ("Música", "Asa Branca"),
    38: ("Música", "Borbulhas de Amor"),
    39: ("Música", "Como Nossos Pais"),
    40: ("Música", "Apenas um Rapaz Latino-Americano"),
    41: ("Música", "Construção"),
    42: ("Música", "Apesar de Você"),
    43: ("Música", "Alegria, Alegria"),
    44: ("Música", "Sampa"),
    45: ("Música", "Travessia"),
    46: ("Música", "Garota de Ipanema"),
    47: ("Música", "Hey Jude"),
    48: ("Música", "Come Together"),
    49: ("Música", "Comfortably Numb"),
    50: ("Música", "Wish You Were Here"),
    51: ("Música", "Creep"),
    52: ("Música", "Karma Police"),
    53: ("Música", "Just Like Heaven"),
    54: ("Música", "Love Will Tear Us Apart"),
    55: ("Música", "Enjoy the Silence"),
    56: ("Álbum", "Dois"),
    57: ("Álbum", "As Quatro Estações"),
    58: ("Álbum", "Que País É Este"),
    59: ("Álbum", "A Revolta dos Dândis"),
    60: ("Álbum", "O Papa é Pop"),
    61: ("Álbum", "Longe Demais das Capitais"),
    62: ("Álbum", "Manera Fru Fru, Manera"),
    63: ("Álbum", "Pedras que Cantam"),
    64: ("Álbum", "Alucinação"),
    65: ("Álbum", "Construção"),
    66: ("Álbum", "Apesar de Você"),
    67: ("Álbum", "Caetano Veloso"),
    68: ("Álbum", "Muito"),
    69: ("Álbum", "Travessia"),
    70: ("Álbum", "Getz/Gilberto"),
    71: ("Álbum", "Hey Jude"),
    72: ("Álbum", "Abbey Road"),
    73: ("Álbum", "The Wall"),
    74: ("Álbum", "Wish You Were Here"),
    75: ("Álbum", "Pablo Honey"),
    76: ("Álbum", "OK Computer"),
    77: ("Álbum", "Kiss Me Kiss Me Kiss Me"),
    78: ("Álbum", "Closer"),
    79: ("Álbum", "The Queen Is Dead"),
    80: ("Gênero", "Rock brasileiro"),
    81: ("Gênero", "MPB"),
    82: ("Gênero", "Tropicália"),
    83: ("Gênero", "Bossa nova"),
    84: ("Gênero", "Rock"),
    85: ("Gênero", "Rock progressivo"),
    86: ("Gênero", "Rock alternativo"),
    87: ("Gênero", "Post-punk"),
}

ROW_RE = re.compile(
    r"\{start: \{_id:(\d+)\}, end: \{_id:(\d+)\}, properties:(\{[^}]*\})\}"
)
REL_CREATE_RE = re.compile(
    r"CREATE \(start\)-\[r:([^\]]+)\]->\(end\) SET r \+= row\.properties;"
)


def parse_all_relationships(full_cypher: str) -> dict[str, list[dict]]:
    by_type: dict[str, list[dict]] = {}
    parts = REL_CREATE_RE.split(full_cypher)
    # [prefix, rel_type, after, rel_type, after, ...]
    for i in range(1, len(parts), 2):
        rel_type = parts[i]
        preceding = parts[i - 1]
        unwind_idx = preceding.rfind("UNWIND [")
        if unwind_idx == -1:
            continue
        list_part = preceding[unwind_idx:]
        rows = by_type.setdefault(rel_type, [])
        for start_id, end_id, props_str in ROW_RE.findall(list_part):
            props: dict = {}
            nota = re.search(r"nota:(\d+)", props_str)
            if nota:
                props["nota"] = int(nota.group(1))
            rows.append(
                {
                    "start": int(start_id),
                    "end": int(end_id),
                    "properties": props,
                }
            )
    return by_type


def main() -> None:
    batches = json.loads(EXPORT_JSON.read_text(encoding="utf-8"))
    full_cypher = "\n".join(b["cypherStatements"] for b in batches)
    (ROOT / "data.cypher").write_text(full_cypher + "\n", encoding="utf-8")

    by_type = parse_all_relationships(full_cypher)

    lines = [
        "// Gerado por scripts/build_from_apoc_export.py — espelho de apoc-export.json",
        "// 196 relacionamentos, 88 nós.",
        "",
    ]

    def emit_section(title: str, rel_type: str, rows: list[dict], fmt_row) -> None:
        if not rows:
            return
        lines.append(f"// {title}")
        lines.append("UNWIND [")
        for i, row in enumerate(rows):
            comma = "," if i < len(rows) - 1 else ""
            lines.append(f"  {fmt_row(row)}{comma}")
        lines.append("] AS row")
        label_a, key_a, label_b, key_b = {
            "AVALIOU": ("Usuário", "usuario", "Música", "musica"),
            "GOSTA_DE": ("Usuário", "usuario", "Artista", "artista"),
            "INFLUENCIOU": ("Artista", "de", "Artista", "para"),
            "LANÇOU": ("Artista", "artista", "Álbum", "album"),
            "GRAVOU": ("Artista", "artista", "Música", "musica"),
            "CLASSIFICADA_COMO": ("Música", "musica", "Gênero", "genero"),
            "CONTÉM": ("Álbum", "album", "Música", "musica"),
        }[rel_type]
        lines.append(
            f"MATCH (a:{label_a} {{ nome: row.{key_a} }}), (b:{label_b} {{ nome: row.{key_b} }})"
        )
        if rel_type == "AVALIOU":
            lines.append("CREATE (a)-[:AVALIOU { nota: row.nota }]->(b);")
        else:
            lines.append(f"CREATE (a)-[:{rel_type}]->(b);")
        lines.append("")

    order = [
        "AVALIOU",
        "GOSTA_DE",
        "INFLUENCIOU",
        "LANÇOU",
        "GRAVOU",
        "CLASSIFICADA_COMO",
        "CONTÉM",
    ]
    for rel in order:
        if rel not in by_type:
            by_type[rel] = []

    emit_section(
        "Usuário —[:AVALIOU { nota }]→ Música",
        "AVALIOU",
        by_type["AVALIOU"],
        lambda r: (
            f"{{ usuario: {json.dumps(ID_NAME[r['start']][1], ensure_ascii=False)}, "
            f"musica: {json.dumps(ID_NAME[r['end']][1], ensure_ascii=False)}, "
            f"nota: {r['properties']['nota']} }}"
        ),
    )
    emit_section(
        "Usuário —[:GOSTA_DE]→ Artista",
        "GOSTA_DE",
        by_type["GOSTA_DE"],
        lambda r: (
            f"{{ usuario: {json.dumps(ID_NAME[r['start']][1], ensure_ascii=False)}, "
            f"artista: {json.dumps(ID_NAME[r['end']][1], ensure_ascii=False)} }}"
        ),
    )
    emit_section(
        "Artista —[:INFLUENCIOU]→ Artista",
        "INFLUENCIOU",
        by_type["INFLUENCIOU"],
        lambda r: (
            f"{{ de: {json.dumps(ID_NAME[r['start']][1], ensure_ascii=False)}, "
            f"para: {json.dumps(ID_NAME[r['end']][1], ensure_ascii=False)} }}"
        ),
    )
    emit_section(
        "Artista —[:LANÇOU]→ Álbum",
        "LANÇOU",
        by_type["LANÇOU"],
        lambda r: (
            f"{{ artista: {json.dumps(ID_NAME[r['start']][1], ensure_ascii=False)}, "
            f"album: {json.dumps(ID_NAME[r['end']][1], ensure_ascii=False)} }}"
        ),
    )
    emit_section(
        "Artista —[:GRAVOU]→ Música",
        "GRAVOU",
        by_type["GRAVOU"],
        lambda r: (
            f"{{ artista: {json.dumps(ID_NAME[r['start']][1], ensure_ascii=False)}, "
            f"musica: {json.dumps(ID_NAME[r['end']][1], ensure_ascii=False)} }}"
        ),
    )
    emit_section(
        "Música —[:CLASSIFICADA_COMO]→ Gênero",
        "CLASSIFICADA_COMO",
        by_type["CLASSIFICADA_COMO"],
        lambda r: (
            f"{{ musica: {json.dumps(ID_NAME[r['start']][1], ensure_ascii=False)}, "
            f"genero: {json.dumps(ID_NAME[r['end']][1], ensure_ascii=False)} }}"
        ),
    )
    emit_section(
        "Álbum —[:CONTÉM]→ Música",
        "CONTÉM",
        by_type["CONTÉM"],
        lambda r: (
            f"{{ album: {json.dumps(ID_NAME[r['start']][1], ensure_ascii=False)}, "
            f"musica: {json.dumps(ID_NAME[r['end']][1], ensure_ascii=False)} }}"
        ),
    )

    out = ROOT / "scripts" / "02_create_relationships.cypher"
    out.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")

    counts = {k: len(v) for k, v in by_type.items()}
    total = sum(counts.values())
    print(f"data.cypher written; relationships: {total} ({counts})")


if __name__ == "__main__":
    main()
