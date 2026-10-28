USE Bancodedados_Curso2026

CREATE TABLE preco_procedimento(Nome_procedimento VARCHAR(50), valor INT)

---------- inserindo dados na tabela de preco_procedimento

INSERT INTO preco_procedimento VALUES ('Exame', 200)
INSERT INTO preco_procedimento VALUES ('Consulta básica', 50)
INSERT INTO preco_procedimento VALUES ('Terapia', 400)
INSERT INTO preco_procedimento VALUES ('Consulta', 100)

------------------- deletando linha devido a duplicidade

DELETE FROM preco_procedimento
WHERE Nome_procedimento = 'Exame' 


-------------------------- Alterando a coluna de "valor" na tabela preco_procedimento

USE Bancodedados_Curso2026

ALTER TABLE preco_procedimento
ALTER COLUMN valor MONEY;


------------------- Criando a coluna de prazo e atualizando os prazos de cada procedimento

 USE Bancodedados_Curso2026

ALTER TABLE preco_procedimento
ADD prazo_procedimento NUMERIC 

UPDATE preco_procedimento
SET prazo_procedimento = '7'
WHERE Nome_procedimento = 'Consulta básica'

UPDATE preco_procedimento
SET prazo_procedimento = '14'
WHERE Nome_procedimento = 'Consulta'

UPDATE preco_procedimento
SET prazo_procedimento = '10'
WHERE Nome_procedimento = 'Exame'

UPDATE preco_procedimento
SET prazo_procedimento = '10'
WHERE Nome_procedimento = 'Terapia'


------------------- Buscando protocolos de exames com o prazo utilizando uma função: retornar_dados

CREATE FUNCTION retornar_dados_W(@valor VARCHAR(50)) RETURNS TABLE as RETURN(

SELECT Tipo_procedimento,Nome_procedimento,prazo_procedimento 
FROM Basededados AS PT 
INNER JOIN preco_procedimento AS PC 
ON PT.Tipo_procedimento = PC.Nome_procedimento 
WHERE Tipo_procedimento = @valor
)

SELECT tIPO_PROCEDIMENTO, prazo_procedimento FROM retornar_dados_W('Consulta')


------------------ Identificando quais protocolos estão atrasados pela data de entrada e de conclusão

USE Bancodedados_Curso2026

SELECT ID_Proto, tIPO_PROCEDIMENTO, data_entrada, data_conclusão,

    DATEDIFF(DAY, data_entrada, data_conclusão) AS dias_decorridos,

    CASE
        WHEN Tipo_procedimento IN ('Exame', 'Consulta', 'Terapia')
             AND DATEDIFF(DAY, data_entrada, data_conclusão) > 10
            THEN 'Atrasado'

        WHEN Tipo_procedimento = 'Consulta básica'
             AND DATEDIFF(DAY, data_entrada, data_conclusão) > 14
            THEN 'Atrasado'

        ELSE 'Dentro do prazo'
    END AS status_protocolo

FROM Basededados;


----------------------------------- Criando tabela responsável e gerencia e inserindo dados

USE Bancodedados_Curso2026

CREATE TABLE responsável_protocolo(Nome_responsável VARCHAR(50), equipe VARCHAR(50), gerente VARCHAR(50))

CREATE TABLE gerencia (Nome_gerente VARCHAR(50), equipe VARCHAR(50))

INSERT INTO responsável_protocolo VALUES ('Richard','Azul','Carla')
INSERT INTO responsável_protocolo VALUES ('Clara','Amarelo','Vanessa')
INSERT INTO responsável_protocolo VALUES ('Welligton','Roxo','Rogério')


INSERT INTO gerencia VALUES ('Carla','Azul')
INSERT INTO gerencia VALUES ('Vanessa','Amarelo')
INSERT INTO gerencia VALUES ('Rogério','Roxo')

------------------------------------- Localizando o procedimento, o responsável, gerência e o motivo do atraso do time Amarelo


SELECT tipo_procedimento, nome_responsável, Nome_gerente, motivo_atraso 

FROM Basededados AS P 

INNER JOIN responsável_protocolo AS R  

ON P.equipe = R.equipe 

INNER JOIN gerencia AS G ON R.gerente = G.Nome_gerente 

WHERE P.equipe = 'Amarelo'

---------------------------------- Declarando variáveis e utilizando IF e ELSE

USE Bancodedados_Curso2026

DECLARE @preco1 MONEY
SET @preco1 = 200

Declare @procedimento1 VARCHAR(50)
SET @procedimento1 = 'Consultas'


IF @procedimento1 = 'EXAMES'
BEGIN 
SELECT 'CORRETO'
END
ELSE
BEGIN
SELECT 'VERIFICAR SE TRATA-SE DE EXAME OU TERAPIA'
END


IF @preco1 >= 200
BEGIN 
SELECT 'Exame ou Terapia'
END
ELSE
BEGIN
SELECT 'Consultas'
END
