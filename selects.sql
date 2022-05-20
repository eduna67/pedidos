-- Selecionar as lojas
-- Para saber quais lojas o cliente tem
SELECT 
	lojcod AS loja,
	lojfantas AS nome_fantasia,
	lojendere AS endereco,
	lojbairro AS bairro,
	lojmunicip AS cidade,
	lojestado AS estado,
	lojcep AS cep,
	lojcnpj AS cnpj
FROM hiploj;

-- 1) TOTAL VENDIDO NO DIA
SELECT 
	ROUND(SUM(saiqtsai * saiprvenu),2) as Valor,
	ROUND(SUM(saiqtsai * saicttotu),2) as Custo,
	ROUND(SUM(saiqtsai * saiprvenu),2) - ROUND(SUM(saiqtsai * saicttotu),2) as Lucro
FROM hipsai 
WHERE saidtsai = curdate()
AND INSTR("BDNOP",saitipo) > 0
AND sailoja = 1;

-- 2) TICKET MÉDIO DIA
SELECT
(
	SELECT IFNULL(SUM(valor_pago),0) as Valor
	FROM hipcom_cupom_tr
	WHERE item_cancelado = 'N' 
	AND cupom_cancelado = 'N'
	AND loja = 1
	AND data = CURDATE()
)
/
(
	SELECT COUNT(1)
	FROM
	(
		SELECT 1
		FROM hipcom_cupom_tr
		WHERE cupom_cancelado = 'N'
		AND loja = 1
		AND data = CURDATE()
		GROUP BY loja, data, terminal, numero_cupom
	) CUPONS_VALIDOS
) AS MediaValor;
	
	
-- 3) MÉDIA DE PRODUTOS POR ATENDIMENTO NO DIA
SELECT 
	IFNULL(SUM(valor_pago),0)/IFNULL(SUM(quantidade),1) AS MediaItens
FROM hipcom_cupom_tr
WHERE item_cancelado = 'N' 
AND cupom_cancelado = 'N'
AND data = CURDATE()
AND loja = 1;

-- 4) CUPONS VALIDOS NO DIA
SELECT COUNT(1) AS 'Cupons validos por dia'
FROM
(
	SELECT 1
	FROM hipcom_cupom_tr
	WHERE cupom_cancelado = 'N'
	AND loja = 1
	AND data = CURDATE()
	GROUP BY loja, data, terminal, numero_cupom
) CUPONS_VALIDOS;

-- 5) CUPONS CANCELADOS NO DIA
SELECT COUNT(1) AS 'Cupons cancelados por dia'
FROM
(
	SELECT 1
	FROM hipcom_cupom_tr
	WHERE cupom_cancelado = 'S'
	AND loja = 1
	AND data = CURDATE()
	GROUP BY loja, data, terminal, numero_cupom
) CUPONS_INVALIDOS;


-- 6) VENDAS POR FAIXA-HORÁRIA NO DIA.
SELECT 
	data AS Data, 
	SUBSTRING(hora,1,2) Hora,
	IFNULL(SUM(valor_pago),0) AS Valor,
	CUPONS.NumCupons AS NumCupons,
	COUNT(valor_pago) AS NumItens,
	COUNT(valor_pago)/CUPONS.NumCupons AS MediaItens,
	IFNULL(SUM(valor_pago),0)/CUPONS.NumCupons AS MediaValor
FROM hipcom_cupom_tr
LEFT OUTER JOIN hipccf ON ccfloja = loja AND ccfdata = data	AND ccfter = terminal AND ccfcup = numero_cupom	AND ccfseq = 1
JOIN 
(
	SELECT ccfoper, count(distinct numero_cupom) AS NumCupons
	FROM hipcom_cupom_tr
	LEFT OUTER JOIN hipccf ON ccfloja = loja AND ccfdata = data	AND ccfter = terminal AND ccfcup = numero_cupom	AND ccfseq = 1
	WHERE item_cancelado = 'N' 
	AND cupom_cancelado = 'N'
	AND (data >= CURDATE() AND data < CURDATE()+1)
	AND loja = 1
	GROUP BY ccfoper
) CUPONS ON CUPONS.ccfoper = hipccf.ccfoper
WHERE item_cancelado = 'N' 
AND cupom_cancelado = 'N'
AND (data >= CURDATE() AND data < CURDATE()+1)
AND loja = 1
GROUP BY data, SUBSTRING(hora,1,2)
ORDER BY  data, SUBSTRING(hora,1,2);

-- 7) OS 100 PRODUTOS MAIS VENDIDOS NO DIA
SELECT 
	saicodplu as Codigo, 
	prodescr AS Descricao, 
	ROUND(saiprvenu,2) as ValorUnitario, 
	ROUND(sum(saiqtsai),2) as Quantidade, 
	ROUND(sum(saiqtsai*saiprvenu),2) as Valor,
	ROUND(SUM(saiqtsai * saicttotu),2) AS Custo, 
	ROUND(SUM(saiqtsai*saiprvenu),2) - ROUND(SUM(saiqtsai * saicttotu),2) as Lucro
FROM hipsai 
LEFT JOIN hippro ON hippro.procodplu = hipsai.saicodplu 
WHERE sailoja = 1 
AND saidtsai = CURDATE()
AND INSTR("BDNOP",saitipo) > 0
GROUP BY saicodplu 
ORDER BY valor DESC 
LIMIT 200;

-- 8) OS 3000 PRODUTOS MAIS VENDIDOS NO DIA
SELECT 
	saicodplu as Codigo, 
	prodescr AS Descricao, 
	ROUND(saiprvenu,2) as ValorUnitario, 
	ROUND(sum(saiqtsai),2) as Quantidade, 
	ROUND(sum(saiqtsai*saiprvenu),2) as Valor,
	ROUND(SUM(saiqtsai * saicttotu),2) AS Custo, 
	ROUND(SUM(saiqtsai*saiprvenu),2) - ROUND(SUM(saiqtsai * saicttotu),2) as Lucro
FROM hipsai 
LEFT JOIN hippro ON hippro.procodplu = hipsai.saicodplu 
WHERE sailoja = 1 
AND saidtsai = CURDATE()
AND INSTR("BDNOP",saitipo) > 0
GROUP BY saicodplu 
ORDER BY valor DESC 
LIMIT 3000;

-- 9) TOTAL VENDIDO POR MODALIDADE NO DIA
SELECT 
	cti.ctifin AS Meio_Pagto,
	flz.flzdescr AS Descricao,
	COUNT(*) AS Quantidade,
	SUM(tes.tesvalor) AS Valor 
from fintes tes
LEFT OUTER JOIN fincti cti on (ctiloja = tesloja AND cticonta = 1 AND ctigrupo = tesgrupo AND ctisubgr = tessubgr)
LEFT OUTER JOIN finflz flz on (flz.flzloja = tes.tesloja AND flz.flzcod = cti.ctifin)
LEFT OUTER JOIN finprm prm on (prmloja = tesloja)
WHERE tesdtemiss = CURDATE()
AND NOT (tes.tescod = prm.prmclireccel AND tes.tesclilj = prm.prmcliljreccel)
AND NOT (tes.tescod = prm.prmclireccta AND tes.tesclilj = prm.prmcliljreccta) 
AND cti.ctiloja = 1
GROUP BY cti.ctifin,flz.flzdescr
ORDER BY SUM(tes.tesvalor) DESC;

-- 10) ESTORNOS DE CUPONS
SELECT
	terminal AS Pdv, 
	data AS Dataproc, 
	hora, 
	ccfoper, 
	null AS Supervisor , 
	SUM(valor_pago) as Valor, 
	numero_cupom as Nrocupom
FROM hipcom_cupom_tr
LEFT OUTER JOIN hipccf ON ccfloja = loja AND ccfdata = data	AND ccfter = terminal AND ccfcup = numero_cupom	AND ccfseq = 1
WHERE cupom_cancelado = 'S'
AND (data >= CURDATE() AND data < CURDATE()+1)
AND loja = 1
GROUP BY data, terminal, numero_cupom
ORDER BY data;

-- 11) DESCONTO DE ITENS NO DIA
-- select que mostra todos os descontos de todos os itens (mesmo os descontos rateados).
SELECT
	data AS Dataproc,
	hora AS Hora,
	oprnome AS Operador,
	null AS Supervisor,
	valor_desconto_item AS Valor,
	numero_cupom AS Nrocupom,
	sequencia AS Item,
	codigo_plu_bar AS codigoean,
	'' AS descricao -- Se fizer esse join vai ficar muito lento
FROM hipcom_cupom_tr
JOIN hipccf ON ccfloja = loja AND ccfdata = data	AND ccfter = terminal AND ccfcup = numero_cupom	AND ccfseq = 1
LEFT JOIN finopr ON oprloja = loja AND oprcod = ccfoper 
WHERE item_cancelado = 'N' 
AND cupom_cancelado = 'N'
AND valor_desconto_item > 0
AND data = '2018-05-08'
AND loja = 1;

-- select que mostra o valor de desconto no cupom
SELECT
	data AS Dataproc,
	hora AS Hora,
	oprnome AS Operador,
	null AS Supervisor,
	sum(valor_desconto_item) AS valor_desconto_cupom,
	numero_cupom AS Nrocupom
FROM hipcom_cupom_tr
JOIN hipccf ON ccfloja = loja AND ccfdata = data	AND ccfter = terminal AND ccfcup = numero_cupom	AND ccfseq = 1
LEFT JOIN finopr ON oprloja = loja AND oprcod = ccfoper 
WHERE item_cancelado = 'N' 
AND cupom_cancelado = 'N'
AND valor_desconto_item > 0
AND data = '2018-05-08'
AND loja = 1
GROUP BY loja, data, terminal, numero_cupom;

-- 12) VENDAS POR SEÇÃO NO DIA
SELECT 
	depdepto as Cod_Secao, 
	depdescr AS Descricao, 
	ROUND(SUM(saiqtsai),2) as Quantidade, 
	ROUND(SUM(saiqtsai*saiprvenu),2) AS Valor, 
	ROUND(SUM(saiqtsai * saicttotu),2) AS Custo, 
	ROUND(SUM(saiqtsai*saiprvenu),2) - ROUND(SUM(saiqtsai * saicttotu),2) as Lucro
FROM hipsai
LEFT JOIN hippro ON hippro.procodplu = hipsai.saicodplu 
LEFT JOIN hipdep ON depdepto = prodepto AND depsecao = 0 AND depgrupo = 0 AND depsubgr = 0 
WHERE sailoja = 1 
AND saidtsai = CURDATE()
AND INSTR("BDNOP",saitipo) > 0
GROUP BY depdepto 
ORDER BY valor DESC;

-- 13) TOTAL DE CUPONS PROCESSADOS POR OPERADOR.
SELECT 
	data AS Data, 
	oprnome as Operador,
	IFNULL(SUM(valor_pago),0) AS Valor,
	CUPONS.NumCupons AS NumCupons,
	COUNT(valor_pago) AS NumItens,
	COUNT(valor_pago)/CUPONS.NumCupons AS MediaItens,
	IFNULL(SUM(valor_pago),0)/CUPONS.NumCupons AS MediaValor
FROM hipcom_cupom_tr
JOIN hipccf ON ccfloja = loja AND ccfdata = data	AND ccfter = terminal AND ccfcup = numero_cupom	AND ccfseq = 1
LEFT JOIN finopr ON oprloja = loja AND oprcod = ccfoper
JOIN 
(
	SELECT ccfoper, count(distinct numero_cupom) AS NumCupons
	FROM hipcom_cupom_tr
	JOIN hipccf ON ccfloja = loja AND ccfdata = data	AND ccfter = terminal AND ccfcup = numero_cupom	AND ccfseq = 1
	WHERE item_cancelado = 'N' 
	AND cupom_cancelado = 'N'
	AND (data >= CURDATE() AND data < CURDATE()+1)
	GROUP BY ccfoper
) CUPONS ON CUPONS.ccfoper = hipccf.ccfoper
WHERE item_cancelado = 'N' 
AND cupom_cancelado = 'N'
AND (data >= CURDATE() AND data < CURDATE()+1)
AND loja = 1
GROUP BY hipccf.ccfoper
ORDER BY SUM(valor_pago);

-- 14) VENDAS VENDEDOR
-- TODO Colocar o nome dos vendedores (Hoje só existe na pdvvdd)
SELECT 
	data AS Data,
	hipcom_cupom_tr.codigo_vendedor, 
	IFNULL(SUM(valor_pago),0) AS Valor,
	CUPONS.NumCupons AS NumCupons,
	COUNT(valor_pago) AS NumItens,
	COUNT(valor_pago)/CUPONS.NumCupons AS MediaItens,
	IFNULL(SUM(valor_pago),0)/CUPONS.NumCupons AS MediaValor
FROM hipcom_cupom_tr
JOIN 
(
	SELECT codigo_vendedor, count(distinct numero_cupom) AS NumCupons
	FROM hipcom_cupom_tr
	WHERE item_cancelado = 'N' 
	AND cupom_cancelado = 'N'
	AND (data >= CURDATE() AND data < CURDATE()+1)
	AND loja = 1
	GROUP BY codigo_vendedor
) CUPONS ON CUPONS.codigo_vendedor = hipcom_cupom_tr.codigo_vendedor
WHERE item_cancelado = 'N' 
AND cupom_cancelado = 'N'
AND (data >= CURDATE() AND data < CURDATE()+1)
AND loja = 1
GROUP BY hipcom_cupom_tr.codigo_vendedor
ORDER BY SUM(valor_pago);

-- 15) MODALIDADE POR OPERADOR
SELECT
	tes.tesdtemiss AS Data,
	oprnome AS Operador,
	cti.ctifin AS Meio_Pagto,
	flz.flzdescr AS Descricao,
	COUNT(*) AS Quantidade,
	SUM(tes.tesvalor) AS Valor 
FROM fintes tes
LEFT JOIN fincti cti on (ctiloja = tesloja AND cticonta = 1 AND ctigrupo = tesgrupo AND ctisubgr = tessubgr)
LEFT JOIN finflz flz on (flz.flzloja = tes.tesloja AND flz.flzcod = cti.ctifin)
LEFT JOIN finprm prm on (prmloja = tesloja)
LEFT JOIN finopr ON oprloja = tesloja AND oprcod = tesoper
WHERE (tesdtemiss >= CURDATE() AND tesdtemiss < CURDATE() + 1)
AND NOT (tes.tescod = prm.prmclireccel AND tes.tesclilj = prm.prmcliljreccel)
AND NOT (tes.tescod = prm.prmclireccta AND tes.tesclilj = prm.prmcliljreccta) 
AND tes.tesloja = 1
GROUP BY tes.tesoper, cti.ctifin,flz.flzdescr
ORDER BY tes.tesdtemiss, tes.tesoper, cti.ctifin DESC;
