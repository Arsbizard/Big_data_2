# Assignment 2: Simple Search Engine using Hadoop MapReduce

**Student:** Arsenii Belugin  
**Course:** Big Data - IU S25  
**Instructor:** Firas Jolha  
**Deadline:** April 15

---

## Methodology

### Document Preparation

- Parsed a `.parquet` file containing at least 1000 plain text documents.
- Documents were stored in HDFS under `/data` with format `<doc_id>_<doc_title>.txt`.
- Created unified format `<doc_id>\t<title>\t<text>` and saved under `/index/data`.

### Indexer: Hadoop MapReduce

- **MapReduce** was used to create the inverted index.
- `mapper1.py` tokenizes each document and emits word-document-frequency.
- `reducer1.py` aggregates frequency per (word, doc_id) pair.
- Output is saved to HDFS `/tmp/index-output`.
- Index is saved to Cassandra `search_engine.inverted_index`.

### Cassandra

- Keyspace: `search_engine`
- Table: `inverted_index(word TEXT, doc_id TEXT, frequency INT, PRIMARY KEY(word, doc_id))`

### BM25 Ranker: Spark + Cassandra

- `query.py` reads user query and computes BM25 scores using:
  - Document frequency (`df`)
  - Term frequency (`tf`)
  - Document length (`dl`)
  - Average document length (`dlavg`)
- Uses `SparkContext` + `cassandra-driver` to read data.
- Returns top 10 ranked document ids and titles.

---

## Demonstration

### Indexing Output

Run with:

```bash
./app/index.sh
```

Produces:

```
word1    doc1    frequency
word2    doc2    frequency
...
```

Stored in Cassandra.

### Query Search Output

Run with:

```bash
./search.sh "dogs play"
```

Output:

```
doc_id: 12345 | title: Dogs as Pets
doc_id: 67890 | title: Why Dogs Obey
...
```

### Scripts

- `start-services.sh`: starts Hadoop & Cassandra services
- `index.sh`: runs the MapReduce indexer and writes to Cassandra
- `query.py`: PySpark ranker with BM25
- `search.sh`: executes query and prints ranked results

---

## How to Run

```bash
docker compose up -d
./start-services.sh
./app/index.sh
./search.sh "dogs are pets"
```

---

## Final Notes

- All MapReduce jobs were tested and validated.
- PySpark and Cassandra fully integrated.
- Query BM25 results validated against small sample corpus.

---