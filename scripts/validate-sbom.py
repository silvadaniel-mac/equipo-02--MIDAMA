"""Comprueba la estructura y los componentes del SBOM generado por Trivy."""
import json
import sys

with open(sys.argv[1], encoding="utf-8") as source:
    bom = json.load(source)
assert bom.get("bomFormat") == "CycloneDX", "Formato incorrecto"
assert bom.get("specVersion") in {"1.4", "1.5", "1.6", "1.7"}, "Versión no soportada"
assert isinstance(bom.get("version"), int) and bom["version"] >= 1
components = bom.get("components", [])
assert components, "SBOM vacío: revisar detección de package-lock.json"
for component in components:
    assert component.get("name"), "Componente sin nombre"
    assert component.get("bom-ref"), "Componente sin identificador"
print(f"SBOM CycloneDX {bom['specVersion']}: {len(components)} componentes")
