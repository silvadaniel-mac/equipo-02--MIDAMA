"""Sembrar rutas reales de la base desplegada. Sin datos de alumnos ni tokens."""


def zap_started(zap, target):
    for path in ("/", "/healthz", "/readyz", "/missing", "/api/v1/contents"):
        zap.core.access_url(target.rstrip("/") + path)
