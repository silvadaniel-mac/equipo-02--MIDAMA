"""Sembrar rutas reales sin enviar credenciales ni datos."""
def zap_started(zap, target):
    for path in ("/", "/healthz", "/readyz", "/missing", "/api/v1/schools/sch_01/courses/crs_01/content", "/api/v1/schools/sch_01/courses/crs_01/tutor-queries"):
        zap.core.access_url(target.rstrip("/") + path)
