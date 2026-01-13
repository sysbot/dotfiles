# ExoPriors Alignment Research Skill

This skill should be used when the user asks questions about AI alignment, AI safety, rationality, effective altruism, or related research topics. Trigger phrases include: "alignment research", "AI safety", "mesa optimization", "inner alignment", "outer alignment", "corrigibility", "deceptive alignment", "rationality", "LessWrong", "EA Forum", "alignment forum", "MIRI", "Anthropic research", "AI existential risk", "x-risk", "interpretability", "mechanistic interpretability", "RLHF", "constitutional AI", "scalable oversight", "reward hacking", "goal misgeneralization", "instrumental convergence", "orthogonality thesis", "coherent extrapolated volition", "friendly AI", "AGI safety", "superintelligence", "AI governance", "compute governance", "alignment tax", "capability control", "value learning", "iterated amplification", "debate (AI safety)", "relaxed adversarial training", "ELK", "eliciting latent knowledge". (user)

---

## ExoPriors Alignment Scry API

Claude has access to the ExoPriors alignment research corpus containing 60M+ documents from alignment research sources.

### API Key
```
exopriors_public_readonly_v1_2025
```

### Base URL
```
https://api.exopriors.com
```

### Available Sources
`lesswrong`, `eaforum`, `twitter`, `bluesky`, `arxiv`, `hackernews`, `datasecretslox`, `slatestarcodex`, `marginalrevolution`, `rethinkpriorities`, `wikipedia`, and more.

### Document Kinds
`post`, `comment`, `paper`, `tweet`, `twitter_thread`, `text`

---

## Query Patterns

### 1. Lexical Search (BM25) - Start Here
```bash
curl -X POST https://api.exopriors.com/v1/alignment/query \
  -H "Authorization: Bearer exopriors_public_readonly_v1_2025" \
  -H "Content-Type: application/json" \
  -d '{"sql": "SELECT * FROM alignment.search('\''mesa optimization'\'', kinds => ARRAY['\''post'\''], limit_n => 20)"}'
```

### 2. Get Schema
```bash
curl -X GET https://api.exopriors.com/v1/alignment/schema \
  -H "Authorization: Bearer exopriors_public_readonly_v1_2025"
```

### 3. Query Estimate (Check Before Heavy Queries)
```bash
curl -X POST https://api.exopriors.com/v1/alignment/estimate \
  -H "Authorization: Bearer exopriors_public_readonly_v1_2025" \
  -H "Content-Type: application/json" \
  -d '{"sql": "SELECT id FROM alignment.entities WHERE source = '\''lesswrong'\'' LIMIT 1000"}'
```

### 4. Exhaustive Search (When Completeness Matters)
```sql
SELECT * FROM alignment.search_exhaustive(
  'corrigibility',
  kinds => ARRAY['post', 'paper'],
  limit_n => 500,
  offset_n => 0
);
```

### 5. Author Topic Intersection
```sql
SELECT * FROM alignment.author_topics(
  NULL,
  ARRAY['alignment', 'interpretability'],
  kinds => ARRAY['post'],
  limit_n => 200
);
```

---

## Materialized Views (Fast Queries)

Use these for filtered semantic search:
- `alignment.mv_lesswrong_posts` - LessWrong posts
- `alignment.mv_eaforum_posts` - EA Forum posts
- `alignment.mv_af_posts` - Alignment Forum posts
- `alignment.mv_arxiv_papers` - arXiv papers
- `alignment.mv_hackernews_posts` - Hacker News posts
- `alignment.mv_high_karma_comments` - High-score comments

Columns: `entity_id`, `uri`, `source`, `kind`, `original_author`, `original_timestamp`, `title`, `score`, `comment_count`, `vote_count`, `word_count`, `is_af`, `preview`, `embedding`

---

## Search Function Return Schema

`alignment.search()` returns: `(id, score, snippet, uri, kind, original_author, title, original_timestamp)`

To get full metadata, join to entities:
```sql
SELECT s.title, s.score, e.metadata->>'baseScore' AS base_score
FROM alignment.search('alignment tax', kinds => ARRAY['post'], limit_n => 50) s
JOIN alignment.entities e ON e.id = s.id
ORDER BY s.score DESC
LIMIT 20;
```

---

## Search Modes

- `mode => 'auto'` (default): quoted phrases use phrase search, otherwise AND semantics
- `mode => 'or'`: any-term matching
- `mode => 'phrase'`: exact sequence matching
- `mode => 'fuzzy'`: handles typos

---

## Semantic Search with Embeddings

### Store an Embedding
```bash
curl -X POST https://api.exopriors.com/v1/alignment/embed \
  -H "Authorization: Bearer exopriors_public_readonly_v1_2025" \
  -H "Content-Type: application/json" \
  -d '{"text": "concept description", "name": "p_8f3a1c2d_concept_name"}'
```

### Use Stored Embedding
```sql
SELECT e.id, e.original_author, e.metadata->>'title'
FROM alignment.embeddings emb
JOIN alignment.entities e ON e.id = emb.entity_id
WHERE emb.chunk_index = 0
  AND emb.embedding IS NOT NULL
ORDER BY emb.embedding <=> @p_8f3a1c2d_concept_name
LIMIT 20;
```

---

## Execution Guidelines

1. **Always start with exploratory queries** (LIMIT 10-50) to understand results
2. **Show query summary before executing** - let user confirm or revise
3. **Treat as heavy if**: missing LIMIT, LIMIT > 1000, estimated_rows > 100k
4. **Use estimate endpoint** when unsure about query cost
5. **Keep result sets small** to avoid flooding context
6. **Use kinds parameter** in search() rather than WHERE clause for efficiency

---

## Performance Tips

- Simple searches: ~1-5s
- Embedding joins (<500K rows): ~5-20s
- Complex aggregations (<2M rows): ~20-60s
- `alignment.search()` caps at 100 rows - use `search_exhaustive()` for more
- If timeout: reduce sample size, pre-filter with search(), or intersect smaller sets

---

## Example Workflow

When user asks about an alignment topic:

1. **Identify the concept** they're asking about
2. **Start with a simple search**:
   ```sql
   SELECT * FROM alignment.search('concept', kinds => ARRAY['post'], limit_n => 20)
   ```
3. **Show relevant titles and authors** from results
4. **Offer to dig deeper** - more results, specific authors, related concepts
5. **Provide URIs** so user can read full posts
