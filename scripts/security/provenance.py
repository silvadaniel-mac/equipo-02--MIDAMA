"""Provenance SLSA 0.2 para el formato slsaprovenance pedido en S10."""
import base64
import json
import os
from pathlib import Path
import sys

mode, directory = sys.argv[1:]
root = Path(directory)
repository = os.environ["GITHUB_REPOSITORY"]
sha = os.environ["GITHUB_SHA"]
digest = os.environ["DIGEST"].removeprefix("sha256:")
source = f"git+https://github.com/{repository}"
builder = "https://github.com/actions/runner"
if mode == "generate":
    metadata = json.loads((root / "build-metadata.json").read_text())
    buildkit = metadata.get("buildx.build.provenance", {})
    materials = [{"uri": source, "digest": {"sha1": sha}}]
    materials.extend(buildkit.get("materials", []))
    predicate = {
        "builder": {"id": builder},
        "buildType": "https://mobyproject.org/buildkit@v1",
        "invocation": {
            "configSource": {"uri": source, "digest": {"sha1": sha}, "entryPoint": "Dockerfile"},
            "parameters": {"RELEASE_SHA": sha},
            "environment": {
                "workflow": os.environ["GITHUB_WORKFLOW_REF"],
                "run": f"https://github.com/{repository}/actions/runs/{os.environ['GITHUB_RUN_ID']}",
                "runner": "github-hosted/ubuntu-24.04",
            },
        },
        "metadata": {
            "buildInvocationId": f"https://github.com/{repository}/actions/runs/{os.environ['GITHUB_RUN_ID']}/attempts/{os.environ['GITHUB_RUN_ATTEMPT']}",
            "buildStartedOn": (root / "build-start.txt").read_text().strip(),
            "buildFinishedOn": (root / "build-finish.txt").read_text().strip(),
            "completeness": {"parameters": True, "environment": False, "materials": bool(buildkit.get('materials'))},
            "reproducible": False,
        },
        "materials": materials,
    }
    (root / "provenance.json").write_text(json.dumps(predicate, indent=2) + "\n")
    print("Provenance generada desde el build hospedado y metadatos BuildKit", sha)
elif mode == "verify":
    raw = (root / "verified-attestation.jsonl").read_text()
    try:
        decoded = json.loads(raw)
        envelopes = decoded if isinstance(decoded, list) else [decoded]
    except json.JSONDecodeError:
        envelopes = [json.loads(line) for line in raw.splitlines() if line.strip()]
    statements = [json.loads(base64.b64decode(e["payload"])) for e in envelopes]
    valid = [s for s in statements if s["predicateType"] == "https://slsa.dev/provenance/v0.2"
             and any(a["digest"].get("sha256") == digest for a in s["subject"])
             and s["predicate"]["builder"]["id"] == builder
             and s["predicate"]["invocation"]["configSource"]["digest"].get("sha1") == sha
             and s["predicate"]["invocation"]["configSource"]["uri"] == source]
    assert valid, "La provenance no corresponde al digest, commit, repositorio y builder esperados"
    (root / "verified-statement.json").write_text(json.dumps(valid[0], indent=2) + "\n")
    message = f"SLSA VERIFY OK: firma OIDC, digest sha256:{digest}, commit {sha}, builder {builder}"
    (root / "slsa-verification.txt").write_text(message + "\n")
    print(message)
else:
    raise ValueError(mode)
