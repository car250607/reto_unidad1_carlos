-- ═══════════════════════════════════════════════════════
-- Q1 - Productos únicos disponibles
-- ═══════════════════════════════════════════════════════
SELECT DISTINCT producto AS producto_disponible
FROM ventas
ORDER BY producto_disponible;

-- ═══════════════════════════════════════════════════════
-- Q2 - Pedidos del primer trimestre con cantidad mayor a 5
-- ═══════════════════════════════════════════════════════
SELECT *
FROM ventas
WHERE fecha BETWEEN '2024-01-01' AND '2024-03-31'
AND cantidad > 5;

-- ═══════════════════════════════════════════════════════
-- Q3 - Vendedores con ingreso bruto total mayor a $10,000
-- ═══════════════════════════════════════════════════════
SELECT vendedor, 
       SUM(cantidad * precio_unitario) AS ingreso_bruto_total
FROM ventas
GROUP BY vendedor
HAVING ingreso_bruto_total > 10000
ORDER BY ingreso_bruto_total DESC;

-- ═══════════════════════════════════════════════════════
-- Q4 - Resumen por categoría
-- ═══════════════════════════════════════════════════════
SELECT categoria,
       COUNT(order_id) AS total_pedidos,
       SUM(cantidad) AS total_unidades,
       ROUND(AVG(precio_unitario), 2) AS precio_promedio
FROM ventas
GROUP BY categoria
ORDER BY total_pedidos DESC;

-- ═══════════════════════════════════════════════════════
-- Q5 - Cumplimiento de meta por vendedor
-- ═══════════════════════════════════════════════════════
SELECT v.vendedor,
       v.zona,
       v.meta_mensual,
       SUM(ve.cantidad * ve.precio_unitario) AS ingreso_total,
       ROUND(SUM(ve.cantidad * ve.precio_unitario) / (v.meta_mensual * 6) * 100, 2) AS pct_cumplimiento
FROM vendedores v
JOIN ventas ve ON v.vendedor = ve.vendedor
GROUP BY v.vendedor
ORDER BY pct_cumplimiento DESC;

-- ═══════════════════════════════════════════════════════
-- Q6 - Cliente con mayor ingreso total en el primer semestre
-- ═══════════════════════════════════════════════════════
SELECT cliente_id,
       cliente_nombre,
       SUM(cantidad * precio_unitario) AS ingreso_total
FROM ventas
GROUP BY cliente_id, cliente_nombre
HAVING ingreso_total = (
    SELECT MAX(ingreso_total)
    FROM (
        SELECT SUM(cantidad * precio_unitario) AS ingreso_total
        FROM ventas
        GROUP BY cliente_id
    )
);