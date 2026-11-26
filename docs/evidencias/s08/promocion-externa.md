# S08 — Promoción externa comprobada

- [S08 en main f61eb33](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45751184545): todos los jobs aprobados; token temporal y apertura de PR dev completados, no omitidos.
- [PR inicial de manifiestos](https://github.com/silvadaniel-mac/equipo-02-gitops/pull/1): integrado.
- [PR automático dev #2](https://github.com/silvadaniel-mac/equipo-02-gitops/pull/2): creado por midama-aulaviva-release[bot] y fusionado por el propietario en a7e2497.
- El PR modificó exclusivamente overlays/dev/kustomization.yaml, de digest a39d94c1… a b2049bca…; producción no se promovió.
- [Validación posterior al merge](https://github.com/silvadaniel-mac/equipo-02-gitops/actions/runs/45751787130): success.
- API de ramas consultada el 26/11/2026: main protegida en ambos repositorios. La configuración detallada de GitOps se observó en las capturas del propietario (dos aprobaciones, CODEOWNERS, manifests, actualización de rama y sin bypass/force push/eliminación).
- App dedicada, instalada exclusivamente en GitOps, con Contents y Pull requests read/write y Metadata read. Credencial almacenada como secret de Actions, no en el repositorio.

Esto acredita automatización entre repositorios y actualización declarativa de dev. No acredita sincronización con un clúster externo permanente ni promoción a producción. No se atribuyen aprobaciones humanas no observadas.
