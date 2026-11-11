"""Cada alerta High de AulaViva produce un registro de incidente, incluso en un simulacro."""
import hashlib
import json
import os
from pathlib import Path
import sys

source, output = map(Path, sys.argv[1:])
output.mkdir(parents=True, exist_ok=True)
expected = {"AulaViva Unexpected Shell", "AulaViva Write Below Etc", "AulaViva Unexpected Outbound"}
seen = set()
events = []
for line in source.read_text().splitlines():
    try:
        event = json.loads(line)
    except json.JSONDecodeError:
        continue
    rule = event.get("rule")
    if rule not in expected:
        continue
    assert event.get("priority", "").lower() in ("error", "critical", "alert", "emergency")
    seen.add(rule)
    events.append(event)
    identifier = hashlib.sha256(line.encode()).hexdigest()[:12]
    fields = event.get("output_fields", {})
    drill = fields.get("k8s.ns.name") == "equipo-02-falco-test"
    incident = {
        "id": f"S10-{identifier}", "severity": "High", "rule": rule,
        "type": "drill" if drill else "incident", "status": "recorded",
        "owner": "MIDAMA / responsable de seguridad de turno",
        "workflow_run": f"https://github.com/{os.getenv('GITHUB_REPOSITORY', '')}/actions/runs/{os.getenv('GITHUB_RUN_ID', '')}",
        "event": event,
        "actions": ["Conservar evidencia", "Validar origen y alcance", "Aislar workload si no es simulacro", "Revocar credenciales afectadas y escalar al equipo"],
    }
    (output / f"{identifier}.json").write_text(json.dumps(incident, indent=2) + "\n")
(output.parent / "falco-alerts.json").write_text(json.dumps(events, indent=2) + "\n")
summary = {"rules_observed": sorted(seen), "incidents_created": len(events), "missing": sorted(expected - seen)}
(output.parent / "falco-summary.json").write_text(json.dumps(summary, indent=2) + "\n")
print(json.dumps(summary, ensure_ascii=False))
assert seen == expected, "Falta evidencia de ejecución de alguna regla propia"
