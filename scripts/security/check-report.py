"""Gates que no aceptan un reporte vacío ni hallazgos bloqueantes."""
import json
import sys

kind, path = sys.argv[1:]
report = json.load(open(path, encoding="utf-8"))
if kind == "checkov":
    reports = report if isinstance(report, list) else [report]
    summaries = [r["summary"] for r in reports]
    assert sum(s["resource_count"] for s in summaries) > 0, "IaC sin recursos analizados"
    assert sum(s["passed"] for s in summaries) > 0, "IaC sin checks ejecutados"
    assert sum(s["failed"] + s["parsing_errors"] for s in summaries) == 0
    assert sum(s["skipped"] for s in summaries) == 0, "No se admiten ignores silenciosos"
    print("CHECKOV PASS:", summaries)
elif kind == "trivy":
    assert report.get("Results"), "Trivy no inventarió la imagen"
    findings = [v for r in report["Results"] for v in r.get("Vulnerabilities", [])
                if v["Severity"] in ("HIGH", "CRITICAL")]
    assert not findings, f"Trivy bloquea {len(findings)} HIGH/CRITICAL"
    print("TRIVY PASS: 0 HIGH/CRITICAL en la imagen final")
elif kind == "zap":
    assert report.get("site"), "ZAP sin sitio analizado"
    findings = [a for s in report["site"] for a in s.get("alerts", [])
                if int(a["riskcode"]) >= 2]
    assert not findings, f"ZAP bloquea Medium+: {[a['name'] for a in findings]}"
    print("ZAP PASS: 0 alertas Medium/High. Las Low/Info quedan en el reporte.")
else:
    raise ValueError(kind)
