# FinOps S18

Escenario ilustrativo de la presentación: 5 colegios, 1000 usuarios activos, 10000 consultas/mes, us-east-1, 730 h. No es factura ni cotización verificada.

| Partida | USD/mes |
| --- | ---: |
| Fargate x86 | 18,02 |
| RDS PostgreSQL | 15,00 |
| OpenSearch Serverless Classic | 175,20 |
| Bedrock Nova Micro | 0,77 |
| Red y observabilidad | 70,00 |
| Almacenamiento y eventos | 5,00 |
| Total | 283,99 |

Costo estimado 56,80 USD/colegio y 0,28 USD/usuario. Presupuesto propuesto 300 USD con alerta al 80%. Tags propuestos project=aula-viva, env=pilot, owner=midama; atribución de uso por tenant agregado. No se han creado recursos AWS ni alertas reales.

Mediciones reproducibles en evaluate.mjs: comparar bytes JSON del corpus completo vs contexto recuperado; comparar contexto con duplicados sintéticos vs deduplicación. Reporte registra ambos pares y calidad. Son proxies de tamaño de contexto, no tokens cobrados ni medición ARM. Las palancas de Fargate ARM y reducción de tokens de la PPT se mantienen como simulaciones. Validar rendimiento y precios antes de contratar. Fuentes: https://aws.amazon.com/fargate/pricing/ ; https://aws.amazon.com/rds/postgresql/pricing/ ; https://aws.amazon.com/opensearch-service/pricing/ ; https://aws.amazon.com/bedrock/pricing/.
