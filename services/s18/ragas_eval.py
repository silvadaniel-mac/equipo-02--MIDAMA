"""Métricas Ragas sin juez LLM sobre recuperación real reproducida en evaluate.mjs."""
import asyncio
import json
import os
from pathlib import Path
from statistics import mean
from ragas import SingleTurnSample
from ragas.metrics import NonLLMContextPrecisionWithReference, NonLLMContextRecall
from importlib.metadata import version

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "docs/evidencias/s18"

async def main():
    golden = json.loads((ROOT / "docs/ai/golden-set.json").read_text())
    report = json.loads((OUT / "evaluation-results.json").read_text())
    corpus = {m["key"]: m["description"] for m in golden["materials"]}
    precision = NonLLMContextPrecisionWithReference()
    recall = NonLLMContextRecall()
    rows = []
    for row in report["rows"]:
        if row["kind"] != "grounded":
            continue
        sample = SingleTurnSample(
            retrieved_contexts=[corpus[key] for key in row["retrievedContextKeys"]],
            reference_contexts=[corpus[row["expected"]]],
        )
        rows.append({
            "id": row["id"],
            "context_precision": float(await precision.single_turn_ascore(sample)),
            "context_recall": float(await recall.single_turn_ascore(sample)),
        })
    result = {
        "scope": "Ragas no LLM: precisión y recall del recuperador en 20 casos con fuente, no faithfulness generativa",
        "ragas": version("ragas"), "commit": os.getenv("GITHUB_SHA", "local"),
        "cases": len(rows),
        "mean_context_precision": mean(r["context_precision"] for r in rows),
        "mean_context_recall": mean(r["context_recall"] for r in rows),
        "rows": rows,
    }
    (OUT / "ragas-results.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))
    assert len(rows) == 20
    assert result["mean_context_precision"] >= .85
    assert result["mean_context_recall"] >= .85

if __name__ == "__main__":
    asyncio.run(main())
